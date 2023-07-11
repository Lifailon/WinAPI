# Exaples:
# irm -Uri http://192.168.3.99:8080/get-service -Method GET
# irm -Uri http://192.168.3.99:8080/get-service/Any -Method GET
# irm -Uri http://192.168.3.99:8080/get-service/AnyDesk -Method GET
# irm -Uri http://192.168.3.99:8080/stop-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}
# irm -Uri http://192.168.3.99:8080/restart-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}
# Curl:
# curl -X GET http://192.168.3.99:8080/get-service/service/ping
# curl -X POST -H 'ServiceName: PingTo-InfluxDB' -d '' http://192.168.3.99:8080/stop-service
# curl -X POST -H 'ServiceName: PingTo-InfluxDB' -d '' http://192.168.3.99:8080/restart-service

$http = [System.Net.HttpListener]::new()
$http.Prefixes.Add("http://192.168.3.99:8080/")
$http.Start()

if ($http.IsListening) {
Write-Host "Web Server Running: $($http.Prefixes)" -f "y"
}

try {
while ($http.IsListening) {
    $contextTask = $http.GetContextAsync()
    while (-not $contextTask.AsyncWaitHandle.WaitOne(200)) { }
    $context = $contextTask.GetAwaiter().GetResult()

### /Get-Service
if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/Get-Service') {
    Write-Host "$($context.Request.RemoteEndPoint) ($($context.Request.UserAgent))  =>  $($context.Request.LocalEndPoint)" -f 'Green'

    $GetService = Get-Service -ErrorAction Ignore | select name,@{Name="Status"; Expression={[string]$_.Status}},@{Name="StartType"; Expression={[string]$_.StartType}} | ConvertTo-Json
    
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($GetService)
    $context.Response.ContentLength64 = $buffer.Length
    $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
    $context.Response.OutputStream.Close() 
}

### /Get-Service/*
if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -match '/Get-Service/') {
    Write-Host "$($context.Request.RemoteEndPoint) ($($context.Request.UserAgent))  =>  $($context.Request.LocalEndPoint)" -f 'Green'
    
    $ServiceName = ($context.Request.RawUrl) -replace ".+/"
    $ServiceName = ($ServiceName -replace "^","*") + "*"
    $GetService = Get-Service -Name $ServiceName -ErrorAction Ignore | select name,@{Name="Status"; Expression={[string]$_.Status}},@{Name="StartType"; Expression={[string]$_.StartType}} | ConvertTo-Json
    
    if ($GetService) {
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($GetService)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }
}

### /Restart-Service
if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/Restart-Service') {
    $Keys           = $context.Request.Headers.AllKeys[0]   # get all keys headers
    $ServiceName    = $context.Request.Headers[0]           # get value by key
    
    Write-Host "$($context.Request.RemoteEndPoint) ($($context.Request.UserAgent))  =>  $($context.Request.LocalEndPoint)" -f 'Green'
    Write-Host Headers: $Keys - $ServiceName -f 'Green'

    Get-Service -Name $ServiceName -ErrorAction Ignore | Restart-Service
    $GetService = Get-Service -Name $ServiceName -ErrorAction Ignore | select name,@{Name="Status"; Expression={[string]$_.Status}},@{Name="StartType"; Expression={[string]$_.StartType}} | ConvertTo-Json

    if ($GetService) {
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($GetService)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }
}

### /Stop-Service
if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/Stop-Service') {
    $Keys           = $context.Request.Headers.AllKeys[0]
    $ServiceName    = $context.Request.Headers[0]
    
    Write-Host "$($context.Request.RemoteEndPoint) ($($context.Request.UserAgent))  =>  $($context.Request.LocalEndPoint)" -f 'Green'
    Write-Host Headers: $Keys - $ServiceName -f 'Green'

    Get-Service -Name $ServiceName -ErrorAction Ignore | Stop-Service
    $GetService = Get-Service -Name $ServiceName -ErrorAction Ignore | select name,@{Name="Status"; Expression={[string]$_.Status}},@{Name="StartType"; Expression={[string]$_.StartType}} | ConvertTo-Json

    if ($GetService) {
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($GetService)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }
}

}
}
finally {
$http.Stop()
}