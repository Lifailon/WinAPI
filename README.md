## Web-WinService-Management

Example simple web server based on **.NET Class System.Net.HttpListener** for windows service management vie REST API.

![Image alt](https://github.com/Lifailon/Web-WinServiceMan/blob/rsa/Web-WinService-Management.jpg)

## REST-WinService-Endpoints

Example create endpoints for **GET** and **POST** request

### GET

`irm -Uri http://192.168.3.99:8080/get-service -Method GET`

`irm -Uri http://192.168.3.99:8080/get-service/AnyDesk -Method GET`

`irm -Uri http://192.168.3.99:8080/get-service/Influx -Method GET`

### POST

`irm -Uri http://192.168.3.99:8080/restart-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}`

`irm -Uri http://192.168.3.99:8080/stop-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}`

![Image alt](https://github.com/Lifailon/Web-WinServiceMan/blob/rsa/REST-WinService-Endpoints.jpg)

### Curl

![Image alt](https://github.com/Lifailon/WinService-Management/blob/rsa/Curl-GET.jpg)
