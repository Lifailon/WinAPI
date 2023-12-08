# ©2023 Lifailon for Kinozal-Bot (https://github.com/Lifailon/Kinozal-Bot)
# Source: https://github.com/Lifailon/WinAPI
<# Client
# Login and password default:
$user = "rest"
$pass = "api"
# Example 1:
$SecureString = ConvertTo-SecureString $pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($user, $SecureString)
Invoke-RestMethod -Credential $Credential -AllowUnencryptedAuthentication -Uri http://192.168.3.99:8443/api/service
# Example 2 (Get decoded credentials):
$EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))
$Headers = @{"Authorization" = "Basic ${EncodingCred}"}
Invoke-RestMethod -Headers $Headers -Uri http://192.168.3.99:8443/api/service
Invoke-RestMethod -Headers $Headers -Uri http://192.168.3.99:8443/api/service/win
### POST Request
$Headers += @{"Status" = "Stop"}
Invoke-RestMethod -Headers $Headers -Method Post -Uri http://192.168.3.99:8443/api/service/winrm
# Example 3 (cURL Client):
user="rest"
pass="api"
curl -s -X GET -u $user:$pass -H 'Content-Type: application/json' http://192.168.3.99:8443/api/service | jq  -r '.[] | {data: "\(.Name) - \(.Status)"} | .data'
curl -s -X GET -u $user:$pass -H 'Content-Type: application/html' http://192.168.3.99:8443/api/service/winrm
curl -s -X GET -u $user:$pass -H 'Content-Type: application/xml' http://192.168.3.99:8443/api/service/winrm
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/service/winrm -H "Status: Restart"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/process
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/process/torrent
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Check"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Stop"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start" -H "Path: C:\Program Files\qBittorrent\qbittorrent.exe"
#>

### Variables
$ip   = "192.168.3.99"
$port = "8443"
$path = "$home/documents/WinAPI.log"
$cred = "cmVzdDphcGk="

function Get-Log {
    ### Debug (Get all Request, Headers and Response parameters):
    # $context.Request | Out-Default
    # foreach ($header in $context.Request.Headers) {
    #     Write-Host "$header = $($context.Request.Headers[$header])"
    # }
    # $context.Response | Out-Default
    $remote_host   = $context.Request.RemoteEndPoint
    $client_agent  = $context.Request.UserAgent
    $method        = $context.Request.HttpMethod
    $endpoint      = $context.Request.RawUrl
    $response_code = $context.Response.StatusCode
    ### Output log to console
    Write-Host "$remote_host $client_agent" -f Blue -NoNewline
    Write-Host " => " -NoNewline
    Write-Host "$method $endpoint" -f Green -NoNewline
    Write-Host " => " -NoNewline
    Write-Host "$response_code" -f Green
    ### Output log to file
    $date = Get-Date -Format "dd.MM.yyyy hh:mm:ss"
    "$date $remote_host $client_agent => $method $endpoint => $response_code" >> $path
}

function Send-Response {
    param (
        $Data,
        [int]$Code,
        [switch]$v2
    )
    ### Data convertion and set response encoding in UTF-8
    if ($v2 -eq $false) {
        if ($Code -eq 200) {
            if ($context.Request.UserAgent -match "Chrome") {
                $Data = $Data | ConvertTo-Html
                $context.Response.ContentType = "text/html; charset=utf-8"
            }
            elseif ($context.Request.ContentType -match "html") {
                $Data = $Data | ConvertTo-Html
                $context.Response.ContentType = "text/html; charset=utf-8"
            }
            elseif ($context.Request.ContentType -match "xml") {
                $Data = ($Data | ConvertTo-Xml).OuterXml
                $context.Response.ContentType = "text/xml; charset=utf-8"
            }
            elseif ($context.Request.ContentType -match "csv") {
                $Data = $Data | ConvertTo-Csv
                $context.Response.ContentType = "text/csv; charset=utf-8"
            }
            else {
                $Data = $Data | ConvertTo-Json
                $context.Response.ContentType = "text/json; charset=utf-8"
            }
        }
    }
    $context.Response.StatusCode = $Code
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($Data)
    $context.Response.ContentLength64 = $buffer.Length
    Get-Log
    $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
    $context.Response.OutputStream.Close()
}

function Get-ProcessDescription {
    param (
        [string]$ProcessName
    )
    if ($null -eq $ProcessName) {
        $GetProcess = Get-Process -ErrorAction Ignore
    } else {
        $GetProcess = Get-Process $ProcessName -ErrorAction Ignore
    }
    if ($null -ne $GetProcess) {
        $GetProcess | Sort-Object -Descending CPU | Select-Object ProcessName,
        @{Name="TotalProcTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},
        @{Name="UserProcTime"; Expression={$_.UserProcessorTime -replace "\.\d+$"}},
        @{Name="PrivilegedProcTime"; Expression={$_.PrivilegedProcessorTime -replace "\.\d+$"}},
        @{Name="WorkingSet"; Expression={[string]([int]($_.WS / 1024kb))+" MB"}},
        @{Name="PeakWorkingSet"; Expression={[string]([int]($_.PeakWorkingSet / 1024kb))+" MB"}},
        @{Name="PageMemory"; Expression={[string]([int]($_.PM / 1024kb))+" MB"}},
        @{Name="VirtualMemory"; Expression={[string]([int]($_.VM / 1024kb))+" MB"}},
        @{Name="PrivateMemory"; Expression={[string]([int]($_.PrivateMemorySize / 1024kb))+" MB"}},
        @{Name="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}},
        @{Name="Threads"; Expression={$_.Threads.Count}},
        Handles, Path
    }
}

function Find-Process {
    param (
        $ProcessName
    )
    $ProcessPath = (Get-ChildItem "C:\Program Files" | Where-Object Name -match $ProcessName).FullName
    if ($null -eq $ProcessPath) {
        $ProcessPath = (Get-ChildItem "C:\Program Files (x86)" | Where-Object Name -match $ProcessName).FullName
    }
    if ($null -eq $ProcessPath) {
        $ProcessPath = (Get-ChildItem "C:\Users\lifailon\AppData\Roaming" | Where-Object Name -match $ProcessName).FullName
    }
    $ProcessNameExec = "$ProcessName"+".exe"
    (Get-ChildItem $ProcessPath -Recurse | Where-Object Name -eq $ProcessNameExec).FullName
}

# Find-Process qbittorrent
# Find-Process nmap
# Find-Process telegram

### Creat socket
Add-Type -AssemblyName System.Net.Http
$http = New-Object System.Net.HttpListener
$addr = $ip+":"+$port
$http.Prefixes.Add("http://$addr/")
### Use Basic Authentication
$http.AuthenticationSchemes = [System.Net.AuthenticationSchemes]::Basic
### Start socket
$http.Start()
Write-Host Running on $http.Prefixes
try {
    while ($http.IsListening) {
        $contextTask = $http.GetContextAsync()
        while (-not $contextTask.AsyncWaitHandle.WaitOne(200)) { }
        $context = $contextTask.GetAwaiter().GetResult()
        ### Authorization
        $CredRequest = $context.Request.Headers["Authorization"]
        ### Debug (read decoded credentials)
        # Write-Host $CredRequest
        $CredRequest = $CredRequest -replace "Basic\s"
        if ( $CredRequest -ne $cred ) {
            $Data = "Unauthorized (login or password is invalid)"
            ### Response on not authorization (code 401)
            Send-Response -Data $Data -Code 401
        }
        else {
            ### GET /service
            if ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/service") {
                $Services = Get-Service -ErrorAction Ignor
                $GetService = "<html><head></head><body>"
                foreach ($Service in $Services) {
                    $name   = "<b>$($Service.Name)</b>"
                    $status = $Service.Status
                    if ($status -eq "Running") {
                        $status = "<font color='green'><b>$status</b></font>"
                    }
                    else {
                        $status = "<font color='red'><b>$status</b></font>"
                    }
                    $GetService += "<div>$name - $status "
                    $GetService += "<button onclick='startService(""$($Service.Name)"")'>Start</button> "
                    $GetService += "<button onclick='stopService(""$($Service.Name)"")'>Stop</button>"
                    $GetService += "</div>"
                }
                $GetService += '
                <script>
                    function startService(serviceName) {
                        sendServiceAction("Start", serviceName);
                    }
                    function stopService(serviceName) {
                        sendServiceAction("Stop", serviceName);
                    }
                    function sendServiceAction(action, serviceName) {
                        var request = new XMLHttpRequest();
                        request.open("POST", "/api/service/" + serviceName, true);
                        // Headers request
                        request.setRequestHeader("Status", action);
                        // Body request
                        // var requestBody = JSON.stringify({ action: action, serviceName: serviceName });
                        request.onreadystatechange = function () {
                            if (request.readyState === 4 && request.status === 200) {
                                // Response to console
                                console.log("True");
                                // Update page
                                location.reload();
                            }
                        };
                        // Send POST request
                        // request.send(requestBody);
                        request.send();
                    }
                </script>
                </body></html>
                '
                Send-Response -Data $GetService -Code $Code -v2
            }
            ### GET /api/service
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/service") {
                $GetService = Get-Service -ErrorAction Ignore | Select-Object name,DisplayName,
                    @{Name="Status"; Expression={[string]$_.status}},
                    @{Name="StartType"; Expression={[string]$_.StartType}}
                Send-Response -Data $GetService -Code 200
            }
            ### GET /api/service/*ServiceName* (windcard format)
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -match "/api/service/.") {
                $ServiceName = ($context.Request.RawUrl) -replace ".+/"
                $GetService = Get-Service -ErrorAction Ignore *$ServiceName* | Select-Object name,DisplayName, 
                    @{Name="Status"; Expression={[string]$_.status}},
                    @{Name="StartType"; Expression={[string]$_.StartType}}
                ### Response on not fount service (code 400)
                if ($null -eq $GetService) {
                    $Code = 400
                    $GetService = "Bad Request. Service $ServiceName could not be found."
                }
                else {
                    $Code = 200                    
                }
                Send-Response -Data $GetService -Code $Code
            }
            ### POST /api/service/ServiceName (not windcard format)
            elseif ($context.Request.HttpMethod -eq "POST" -and $context.Request.RawUrl -match "/api/service/.") {
                ### Get Service Name from endpoint
                $ServiceName = ($context.Request.RawUrl) -replace ".+/"
                ### Get Status from Headers Request (stop/start/restart)
                $Status = $context.Request.Headers["Status"]
                ### Check Service
                $GetService = Get-Service -ErrorAction Ignore $ServiceName
                if ($null -eq $GetService) {
                    $Code = 400
                    $GetService = "Bad Request. Service $ServiceName could not be found."
                }
                else {
                    $Code = 200
                    if ($status -eq "stop") {
                        $GetService | Stop-Service
                    }
                    elseif ($status -eq "start") {
                        $GetService | Start-Service
                    }
                    elseif ($status -eq "restart") {
                        $GetService | Restart-Service
                    }
                    else {
                        $Code = 400
                        $GetService = "Bad Request. Invalid status in the header. Available: stop, start, restart."
                    }
                }
                if ($code -eq 200) {
                    $GetService = Get-Service -ErrorAction Ignore *$ServiceName* | Select-Object name,DisplayName, 
                        @{Name="Status"; Expression={[string]$_.status}},
                        @{Name="StartType"; Expression={[string]$_.StartType}}
                }
                Send-Response -Data $GetService -Code $Code
            }
            ### Get /api/process
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/process") {
                $GetProcess = Get-ProcessDescription
                Send-Response -Data $GetProcess -Code 200
            }
            ### GET /api/process/*ProcessName* (windcard format)
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -match "/api/process/.") {
                $ProcessName = ($context.Request.RawUrl) -replace ".+/"
                $GetProcess = Get-ProcessDescription *$ProcessName*
                ### Response on not fount service (code 400)
                if ($null -eq $GetProcess) {
                    $Code = 400
                    $GetProcess = "Bad Request. Process $ProcessName could not be found."
                }
                else {
                    $Code = 200                    
                }
                Send-Response -Data $GetProcess -Code $Code
            }
            ### POST /api/process/ProcessName (not windcard format)
            elseif ($context.Request.HttpMethod -eq "POST" -and $context.Request.RawUrl -match "/api/process/.") {
                $ProcessName = ($context.Request.RawUrl) -replace ".+/"
                ### Get Status (check/stop/start) and Path from Headers Request
                $Status      = $context.Request.Headers["Status"]
                $PathProcess = $context.Request.Headers["Path"]
                if ($status -eq "check") {
                    $Code = 200
                    $GetProcess = "Number active $ProcessName processes: $((Get-Process -ErrorAction Ignore $ProcessName).Count)"
                }
                elseif ($status -eq "start") {
                    if ($null -eq $PathProcess) {
                        ### Find Path Execude for Start Process
                        $PathProcess = Find-Process $ProcessName
                        ### Check Path for Start Process
                        if ($null -eq $PathProcess) {
                            $Code = 400
                            $GetProcess = "Bad Request. Path for start process $ProcessName could not be found. Use header: path."
                        }
                        else {
                            $Code = 200
                            Start-Process "$PathProcess" -WindowStyle Hidden
                            Start-Sleep 1
                            $GetProcess = "Number active $ProcessName processes: $((Get-Process -ErrorAction Ignore $ProcessName).Count)"
                        }
                    }
                    ### Use path from Header for Start Process
                    else {
                        ### Check Path and Extension for Start Process
                        if ($(Test-Path $PathProcess) -and $($PathProcess -match ".exe$")) {
                            $Code = 200
                            Start-Process "$PathProcess" -WindowStyle Hidden
                            Start-Sleep 1
                            $GetProcess = "Number active $ProcessName processes: $((Get-Process -ErrorAction Ignore $ProcessName).Count)"
                        }
                        else {
                            $Code = 400
                            $GetProcess = "Bad Request. Path $PathProcess for start process $ProcessName could not be found."
                        }
                    }
                }
                elseif ($status -eq "stop") {
                    ### Check Service
                    $GetProcess = Get-Process -ErrorAction Ignore $ProcessName
                    if ($null -eq $GetProcess) {
                        $Code = 400
                        $GetProcess = "Bad Request. Process $ProcessName could not be found."
                    }
                    else {
                        $Code = 200
                        $GetProcess | Stop-Process
                        Start-Sleep 1
                        $GetProcess = "Number active $ProcessName processes: $((Get-Process -ErrorAction Ignore $ProcessName).Count)"
                    }
                }
                else {
                    $Code = 400
                    $GetProcess = "Bad Request. Invalid status in the header. Available: check, stop, start."
                }
                Send-Response -Data $GetProcess -Code $Code -v2
            }
            ### Response to other methods (code 405)
            elseif ($context.Request.HttpMethod -ne "GET") {
                $Data = "Method not allowed"
                Send-Response -Data $Data -Code 405
            }
            ### Response to the lack of endpoints (code 404)
            else {
                $Data = "Not found endpoint"
                Send-Response -Data $Data -Code 404
            }
        }
    }
}
finally {
    $http.Stop()
}