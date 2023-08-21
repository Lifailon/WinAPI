## REST-WinService-Endpoints

Run server: `powershell.exe -File "REST-WinService-Endpoints.ps1"`

Example create endpoints for **GET** and **POST** request

### GET

`Invoke-RestMethod -Uri http://192.168.3.99:8080/get-service -Method GET`

### Wildcard format for endpoint

`Invoke-RestMethod -Uri http://192.168.3.99:8080/get-service/Any -Method GET` \
`Invoke-RestMethod -Uri http://192.168.3.99:8080/get-service/AnyDesk -Method GET`

### POST

`Invoke-RestMethod -Uri http://192.168.3.99:8080/stop-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}` \
`Invoke-RestMethod -Uri http://192.168.3.99:8080/restart-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}`

![Image alt](https://github.com/Lifailon/PS-REST-Endpoints/blob/rsa/screen/REST-WinService-Endpoints.jpg)

### Curl

Linux integration via REST API:

`curl -X GET http://192.168.3.99:8080/get-service/service/ping` \
`curl -X POST -H 'ServiceName: PingTo-InfluxDB' -d '' http://192.168.3.99:8080/stop-service` \
`curl -X POST -H 'ServiceName: PingTo-InfluxDB' -d '' http://192.168.3.99:8080/restart-service`

![Image alt](https://github.com/Lifailon/PS-REST-Endpoints/blob/rsa/screen/REST-Curl.jpg)

![Image alt](https://github.com/Lifailon/PS-REST-Endpoints/blob/rsa/screen/Wireshark-show.jpg)

### Client connections output

![Image alt](https://github.com/Lifailon/PS-REST-Endpoints/blob/rsa/screen/REST-Connections.jpg)

## Web-WinService-Management

Example simple web server based on **.NET Class System.Net.HttpListener** for windows service management vie REST API.

![Image alt](https://github.com/Lifailon/PS-REST-Endpoints/blob/rsa/screen/Web-WinService-Management.jpg)
