# Заполняем переменны с номером порта и данными для авторизации
$port = 8443
$user = "rest"
$pass = "api"
# Формируем строку Base64 из данных логина и пароля
$cred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))

# Функция для логирования запросов
function Get-Log {
    ### Debug (Get all Request, Headers and Response parameters):
	# Используя содержимое запросов (Request), чтение передаваемых заголовков и ответа (Response), можно расширить возможности логирования для отладки процесса
    # $context.Request | Out-Default
    # foreach ($header in $context.Request.Headers) {
    #     Write-Host "$header = $($context.Request.Headers[$header])"
    # }
    # $context.Response | Out-Default
	# Забираем содержимое из запроса: адрес клиента, наименование агента, метод и url конечной точки
    $remote_host   = $context.Request.RemoteEndPoint
    $client_agent  = $context.Request.UserAgent
    $method        = $context.Request.HttpMethod
    $endpoint      = $context.Request.RawUrl
    $response_code = $context.Response.StatusCode
    $date = Get-Date -Format "dd.MM.yyyy hh:mm:ss"
	# Выводим в консоль или в файл
    "$date $remote_host $client_agent => $method $endpoint => $response_code"
    # "$date $remote_host $client_agent => $method $endpoint => $response_code" | Out-File $Log_Path -Encoding utf8 -Append
}

# Функция для ответа клиенту
function Send-Response {
    param (
        $Data,
        [int]$Code
    )
    # Проверяем код ответа, если он равен 200 (успех), то конвертируем данные перед отправкой клиенту
    if ($Code -eq 200) {
        # Дополнительно можем проверить название агента на клиентской стороне, который может выступать в роли браузера или явно задан тип данных HTML
        if (($context.Request.UserAgent -match "Chrome") -or ($context.Request.ContentType -match "html")) {
            # Конвертируем полученные данные в HTML и указываем тип контента в ответе
			$Data = $Data | ConvertTo-Html
            $context.Response.ContentType = "text/html; charset=utf-8"
        }
		# Далее проверяем только тип контента из заголовка (если он задан явным образом), и конвертируем вывод в соответствующий тип данных
        elseif ($context.Request.ContentType -match "xml") {
            $Data = ($Data | ConvertTo-Xml).OuterXml
            $context.Response.ContentType = "text/xml; charset=utf-8"
        }
        elseif ($context.Request.ContentType -match "csv") {
            $Data = $Data | ConvertTo-Csv
            $context.Response.ContentType = "text/csv; charset=utf-8"
        }
		# По умолчанию, конвертируем в JSON
        else {
            $Data = $Data | ConvertTo-Json
            $context.Response.ContentType = "text/json; charset=utf-8"
        }
    }
    # Указываем код статуса для ответа
    $context.Response.StatusCode = $Code
    # Преобразуем данные в массив байтов, используя кодировку UTF-8 (особенно важно, при передачи в формате HTML)
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($Data)
    # Выполняем функцию логирования
    Get-Log
    # Забираем число количества байт буффера для записи в поток, который передается в параметр ответа. Это является важным условием, что все даныне были переданы и прочитаны на стороне клиента.
    $context.Response.ContentLength64 = $buffer.Length
    # Передаем массив байтов (наш буффер ответа с данными) в поток ответа, обязательно нужно передать параметры смешения (если бы нужно было начать запись с определенного места в массиве) и длинны буффера
    $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
	# Данный метод обновляет буфер вывода, убеждаясь, что все данные из буфера отправлены клиенту
    $context.Response.OutputStream.Flush()
	# Закрываем поток ответа
    $context.Response.OutputStream.Close()
}

# Создаем сокет слушателя
Add-Type -AssemblyName System.Net.Http
$http = New-Object System.Net.HttpListener
# Указываем адрес слушателя (+ что бы слушать на всех интерфейсах) и порт
$http.Prefixes.Add("http://+:$port/")
# Указываем использование базового метода аутентификации
$http.AuthenticationSchemes = [System.Net.AuthenticationSchemes]::Basic
# Запускаем сокет (начинаем слушать запросы на указанном порту)
$http.Start()
# Обработчик try-finally нужен для закрытия сокета в случае его непредвиденного завершения
try {
    # Отправляем в бесконечный цикл прослушивание входящих запросов, пока свойство IsListening объекта $http равно true
    while ($http.IsListening) {
	    # Используем асинхронный режим, для ожидания новых запросов
        $contextTask = $http.GetContextAsync()
        # Синхронно ожидает завершения асинхронной задачи, чтобы дождаться завершения асинхронной операции, прежде чем продолжить выполнение кода
        while (-not $contextTask.AsyncWaitHandle.WaitOne(200)) { }
		# Получение результата асинхронной задачи
        $context = $contextTask.GetAwaiter().GetResult()
        # Проверяем полученные данные авторизации (в формате Base64) из заголовка запроса на соответветствие переменной $cred
        $CredRequest = $context.Request.Headers["Authorization"]
        # Write-Host $CredRequest
        $CredRequest = $CredRequest -replace "Basic\s"
        if ( $CredRequest -ne $cred ) {
            # Если авторизационные данные не прошли проверку (неверно передан логин или пароль), передаем в функцию ответа параметры с текстом ошибки и кодом возравата 401
            $Data = "Unauthorized (login or password is invalid)"
            Send-Response -Data $Data -Code 401
        }
        else {
            # Если авторизация прошла, проверяем метод и url конечной точки на соответветствие, что бы его обработать
            if ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/service") {
                $GetService = Get-Service -ErrorAction Ignore
                Send-Response -Data $GetService -Code 200
            }
            # Дальше по аналогии дополнительными условиями (elseif) добавляем обработку других конечных точек
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/process") {
                $GetService = Get-Process
                Send-Response -Data $GetService -Code 200
            }
	        # Если не одно из методов не прошел соответветствие, отправляем ответ с кодом 405
            elseif ($context.Request.HttpMethod -ne "GET") {
                $Data = "Method not allowed"
                Send-Response -Data $Data -Code 405
            }
            # Если не одно из условий не подошло, отправляем ответ с кодом 404
            else {
                $Data = "Not found endpoint"
                Send-Response -Data $Data -Code 404
            }
        }
    }
}
finally {
    # Освобождаем сокет
    $http.Stop()
}