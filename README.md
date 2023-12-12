# WinAPI

![GitHub release (with filter)](https://img.shields.io/github/v/release/lifailon/WinAPI?color=<green>)
![GitHub top language](https://img.shields.io/github/languages/top/lifailon/WinAPI)
![GitHub last commit (by committer)](https://img.shields.io/github/last-commit/lifailon/WinAPI)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/lifailon/WinAPI)
![GitHub License](https://img.shields.io/github/license/lifailon/WinAPI?color=<green>)

[Readme test](https://github.com/Lifailon/WinAPI/Test/blob/rsa/README.md)

Simple REST API and Web server **based on .NET HttpListener**. Using WinAPI, you can quickly set up remote communication with Windows OS without the need to configure WinRM or OpenSSH using APIs and get control from any platform and any REST client, including 🐧 Linux. The goal of the project is to demonstrate the capabilities of PowerShell language and implementation of the functionality in **[Kinozak-Bot](https://github.com/Lifailon/Kinozal-Bot)** due to the lack of a suitable ready-made solution on the market. This implementation is cross-platform, you can try other work for cross-platform managing systemd services in Linux, example **[dotNET-Systemd-API](https://github.com/Lifailon/dotNET-Systemd-API)**.

### 📑 Implemented endpoints:

All GET requests can be output in one of the following formats: **JSON (default), HTML, XML, CSV**. When using a browser for GET requests, by default the response is processed in table format using HTML markup.

- GET

`/service` - simple HTTP server with the ability to stop and start services using buttons (using JavaScript functions, **only for Web Browser**) \
`/api/service` - Get list **all services** \
`/apt/service/service_name` - Get list service by the specified name passed in URL (using **wildcard** format) \
`/process` - simple HTTP server with the ability to stop and start process using buttons (using JavaScript functions, **only for Web Browser**) \
`/apt/process` - Get a list **all running processes** in an easy-to-read format \
`/apt/process/process_name` - Get list running processes by the specified name passed in URL (using **wildcard** format)
`/api/hardware` - Output of summary statistics of metrics close to Task Manager from **Common Information Model** \
`/api/performance` - Output metrics from **Counter** \
`/api/cpu` \
`/api/memory` \
`/api/memory/slots` \
`/api/disk/physical` \
`/api/disk/logical` \
`/api/disk/iops` \
`/api/video` \
`/api/network`

- POST

`/apt/service/service_name` - stop, start and restart services by name (only one at a time, not wildcard format), status is transmitted in the request header (**Status: <Stop/Start/Restart>**). Upon execution, the service status is returned in the format of a GET request. \
`/apt/process/process_name` - check the number of running processes (**Status: Check**), stop a process by name (**Status: Stop**) and start a process (**Status: Start**). To start a process, you can use the function to search for an executable file in the file system by its name, but you can also pass the path to the executable file through the request header (e.g. **Path: C:\Program Files\qBittorrent\qbittorrent.exe**).

### 🚀 Install

Download the latest [WinAPI-0.2.ps1](https://github.com/Lifailon/WinAPI/blob/rsa/WinAPI/WinAPI-0.2.ps1) script. Use in **PowerShell Core**. No dependencies.

The following variables at the beginning of the script are used to configure the **ip, port, login and password**:

```PowerShell
$ip          = "192.168.3.99"
$port        = "8443"
$user        = "rest"
$pass        = "api"
```

If you want output to log requests to a console and/or write file, enable and set the path.

```PowerShell
$Log_Console = "True"
$Log_File    = "True"
$Log_Path    = "$home/documents/WinAPI.log"
```

And open a port on your firewall:

```PowerShell
New-NetFirewallRule -DisplayName "WinAPI" -Profile Any -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8443
```

Run script in console with **administrator privileges**.

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
- Example 3. cURL client. Receiving data in different formats.

```Bash
user="rest"
pass="api"
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

### 🐧 Examples POST request from Linux client

- Stop and start service **WinRM**:

First find the service to pass its full name to the to url for POST request (example, using part of the name in GET request).

```Bash
user="rest"
pass="api"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service/win | jq -r .[].Name
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/service/winrm -H "Status: Stop"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/service/winrm -H "Status: Start"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service/winrm | jq -r .Status
```

- Stop and start process **qbittorrent**:

First find the process by its name in wilcard format using a GET request. Using **Check** in the **Status** header, we display the number of running processes. To stop the process, use header **Status: Stop**. To run the process, two examples are given using the name to find the executable and the second option, specify the full path to the executable.

```Bash
user="rest"
pass="api"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/process/torrent
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Check"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Stop"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start" -H "Path: C:\Program Files\qBittorrent\qbittorrent.exe"
```

### Windows client

```PowerShell
$user = "rest"
$pass = "api"
$EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))
```

- Stop service **WinRM**:

```PowerShell
$Headers = @{"Authorization" = "Basic ${EncodingCred}"}
$Headers += @{"Status" = "Stop"}
Invoke-RestMethod -Headers $Headers -Uri http://192.168.3.99:8443/api/service/winrm
Invoke-RestMethod -Headers $Headers -Method Post -Uri http://192.168.3.99:8443/api/service/winrm
```
- Start service **WinRM**:

```PowerShell
$Headers = @{"Authorization" = "Basic ${EncodingCred}"}
$Headers += @{"Status" = "Start"}
Invoke-RestMethod -Headers $Headers -Method Post -Uri http://192.168.3.99:8443/api/service/winrm
```

- Module **Get-Hardware**

For an example, import the **[Get-Hardware](https://github.com/Lifailon/WinAPI/blob/rsa/WinAPI/Get-Hardware)** module (or copy it to your modules directory). For local retrieval of information, use the command without parameters, for remote launch via API, use the parameter **-ComputerName**.

```PowerShell
Import-Modules .\Get-Hardware.psm1
Get-Hardware
Get-Hardware -ComputerName 192.168.3.99 -Port 8443 -User rest -Pass api
```

You can add endpoints to the module yourself for fast remote communication via API.

### 🎉 Simple web server

There are buttons for switching between all web pages.

- Process management:

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Process.jpg)

- Service management:

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Service.jpg)

- Hardware statistics from CIM:

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Hardware.jpg)

- Metrics performance, physical, logical disk and iops:

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Metrics.jpg)
