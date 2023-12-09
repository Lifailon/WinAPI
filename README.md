# WinAPI

[Readme test](https://github.com/Lifailon/WinAPI/Test/blob/rsa/README.md)

Simple REST API and Web server **based on .NET HttpListener**. Using WinAPI, you can quickly set up remote communication with Windows OS without the need to configure WinRM or OpenSSH using APIs and get control from any platform and any REST client, including 🐧 Linux. The goal of the project is to demonstrate the capabilities of PowerShell language and implementation of the functionality in **[Kinozak-Bot](https://github.com/Lifailon/Kinozal-Bot)** due to the lack of a suitable ready-made solution on the market. This implementation is cross-platform, you can try other work for cross-platform managing systemd services in Linux, example **[dotNET-Systemd-API](https://github.com/Lifailon/dotNET-Systemd-API)**.

### 📑 Implemented endpoints:

- GET

`/service` - simple HTTP server with the ability to stop and start services using buttons (using JavaScript functions) \
`/api/service` - Get list all services \
`/apt/service/service_name` - Get list service by the specified name passed in URL (using wildcard format) \
`/apt/process` - Get a list all running processes in an easy-to-read format \
`/apt/process/process_name` - Get list running processes by the specified name passed in URL (using wildcard format)

All GET requests can be output in one of the following formats: JSON (default), HTML, XML, CSV. When using a browser for GET requests, by default the response is processed in table format using HTML markup.

- POST

`/apt/service/service_name` - stop, start and restart services by name (only one at a time, not wildcard format), status is transmitted in the request header (**Status: <Stop/Start/Restart>**). \
`/apt/process/process_name` - check the number of running processes (**Status: Check**), stop a process by name (**Status: Stop**) and start a process (**Status: Start**). To start a process, you can use the function to search for an executable file in the file system by its name, but you can also pass the path to the executable file through the request header (e.g. **Path: C:\Program Files\qBittorrent\qbittorrent.exe**).

### 🔒 Authorization

Base authorization has been implemented (based on Base64).

Default login and password:
```PowerShell
$user = "rest"
$pass = "api"
```
- Example 1.
```PowerShell
$SecureString = ConvertTo-SecureString $pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($user, $SecureString)
Invoke-RestMethod -Credential $Credential -AllowUnencryptedAuthentication -Uri http://192.168.3.99:8443/api/service
```
- Example 2. Password transfer via the request header, also used for password decoding.
```PowerShell
$EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))
$Headers = @{"Authorization" = "Basic ${EncodingCred}"}
Invoke-RestMethod -Headers $Headers -Uri http://192.168.3.99:8443/api/service
```
- Example 3. cURL client.
```Bash
user="rest"
pass="api"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service | jq  -r '.[] | {data: "\(.Name) - \(.Status)"} | .data'
curl -s -X GET -u $user:$pass -H 'Content-Type: application/json' http://192.168.3.99:8443/api/service/win
curl -s -X GET -u $user:$pass -H 'Content-Type: application/html' http://192.168.3.99:8443/api/service/winrm
curl -s -X GET -u $user:$pass -H 'Content-Type: application/xml' http://192.168.3.99:8443/api/service/winrm
curl -s -X GET -u $user:$pass -H 'Content-Type: application/csv' http://192.168.3.99:8443/api/service/winrm
```

### 💡 Response code

**200. Request completed successfully.**

**400. Bad Request.** Invalid header and service or process could not be found.

**401. Unauthorized.** Login or password is invalid.

**404. Not found endpoint.** Response to the lack of endpoints.

**405. Method not allowed.** Response to other methods.

### Simple web server

- Service management

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Service.jpg)

- Process management

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Process.jpg)
