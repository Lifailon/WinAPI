## Web-WinService-Management

Example simple web server based on **.NET Class System.Net.HttpListener** for windows service management vie REST API.

![Image alt](https://github.com/Lifailon/Web-WinServiceMan/blob/rsa/Web-WinService-Management.jpg)

## REST-WinService-Endpoints

Example create endpoints for **GET** and **POST** request

### GET

`irm -Uri http://192.168.3.99:8080/get-service -Method GET`

### Wildcard format for endpoint

`irm -Uri http://192.168.3.99:8080/get-service/Any -Method GET` \
`irm -Uri http://192.168.3.99:8080/get-service/AnyDesk -Method GET`

### POST

`irm -Uri http://192.168.3.99:8080/restart-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}` \
`irm -Uri http://192.168.3.99:8080/stop-service -Method POST -Headers @{"ServiceName" = "AnyDesk"}`

![Image alt](https://github.com/Lifailon/Web-WinServiceMan/blob/rsa/REST-WinService-Endpoints.jpg)

### Curl

Linux integration via REST API:

`curl -X GET http://192.168.3.99:8080/get-service/service/ping` \
`curl -X POST -H 'ServiceName: PingTo-InfluxDB' -d '' http://192.168.3.99:8080/stop-service` \
`curl -X POST -H 'ServiceName: PingTo-InfluxDB' -d '' http://192.168.3.99:8080/restart-service`

![Image alt](https://github.com/Lifailon/WinService-Management/blob/rsa/REST-Curl.jpg)

### Client connections output

![Image alt](https://github.com/Lifailon/WinService-Management/blob/rsa/REST-Connects.jpg)
