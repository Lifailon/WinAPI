> **Functional testing (11 Jul)**

## REST-WinService-Endpoints

Example create endpoints **GET** and **POST** request for windows service managment via REST API use PowerShell.

Run server: `powershell.exe -File "REST-WinService-Endpoints.ps1"`

### GET

`Invoke-RestMethod -Uri http://192.168.3.99:8080/get-service -Method GET`

### Wildcard format for endpoint

`Invoke-RestMethod -Uri http://192.168.3.99:8080/get-service/Any -Method GET` \
`Invoke-RestMethod -Uri http://192.168.3.99:8080/get-service/AnyDesk -Method GET`

### POST

`Invoke-RestMethod -Uri http://192.168.3.99:8080/stop-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}` \
`Invoke-RestMethod -Uri http://192.168.3.99:8080/restart-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}`

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Test/REST-WinService-Endpoints.jpg)

### Curl

Linux integration via REST API:

`curl -X GET http://192.168.3.99:8080/get-service/service/ping` \
`curl -X POST -H 'ServiceName: PingTo-InfluxDB' -d '' http://192.168.3.99:8080/stop-service` \
`curl -X POST -H 'ServiceName: PingTo-InfluxDB' -d '' http://192.168.3.99:8080/restart-service`

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Test/REST-Curl.jpg)

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Test/Wireshark-Show.jpg)

### Client connections output

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Test/REST-Connections.jpg)

## Web-WinService-Management

Example simple web server based on **.NET Class System.Net.HttpListener** for windows service management via REST API.

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Test/Web-WinService-Management.jpg)
