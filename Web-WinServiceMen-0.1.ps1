$http = [System.Net.HttpListener]::new()
$http.Prefixes.Add("http://localhost:8080/")
$http.Start()

if ($http.IsListening) {
Write-Host "Web Server Running: $($http.Prefixes)" -f "y"
}

try {
while ($http.IsListening) {
$contextTask = $http.GetContextAsync()
while (-not $contextTask.AsyncWaitHandle.WaitOne(200)) { }
$context = $contextTask.GetAwaiter().GetResult()

### Main Form
if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/') {

Write-Host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'Green'

[string]$html_form = "
<h1>Web Interface Windows Service Management</h1>

<form action='/Get-Service' method='post'>
<input type='submit' value='Get-Service'>
</form>

<form action='/Restart-Service' method='post'>
<input type='text' name='service_name'>
<input type='submit' value='Restart-Service'>
</form>

<form action='/Stop-Service' method='post'>
<input type='text' name='service_name'>
<input type='submit' value='Stop-Service'>
</form>
"

$buffer = [System.Text.Encoding]::UTF8.GetBytes($html_form)
$context.Response.ContentLength64 = $buffer.Length
$context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
$context.Response.OutputStream.Close()
}

# Get-Service
if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/Get-Service') {
$FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

Write-Host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'Green'
Write-Host $FormContent -f 'Green'

$GetService = Get-Service -ErrorAction Ignore | select Name,DisplayName,Status,StartType | ConvertTo-HTML -Charset UTF-8
[string]$html_service = $html_form + $GetService

$buffer = [System.Text.Encoding]::UTF8.GetBytes($html_service)
$context.Response.ContentLength64 = $buffer.Length
$context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
$context.Response.OutputStream.Close() 
}

### Restart-Service
if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/Restart-Service') {
$FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

Write-Host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'Green'
$Service_Name = $FormContent -replace "service_name="
Write-Host "Restart service: $Service_Name" -f 'Green'
Restart-Service $Service_Name

$GetService = Get-Service -ErrorAction Ignore | select Name,DisplayName,Status,StartType | ConvertTo-HTML -Charset UTF-8
[string]$html_service = $html_form + $GetService

$buffer = [System.Text.Encoding]::UTF8.GetBytes($html_service)
$context.Response.ContentLength64 = $buffer.Length
$context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
$context.Response.OutputStream.Close() 
}

### Stop-Service
if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/Stop-Service') {
$FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

Write-Host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'Green'
$Service_Name = $FormContent -replace "service_name="
Write-Host "Stop service: $Service_Name" -f 'Green'
Stop-Service $Service_Name

$GetService = Get-Service -ErrorAction Ignore | select Name,DisplayName,Status,StartType | ConvertTo-HTML -Charset UTF-8
[string]$html_service = $html_form + $GetService

$buffer = [System.Text.Encoding]::UTF8.GetBytes($html_service)
$context.Response.ContentLength64 = $buffer.Length
$context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
$context.Response.OutputStream.Close() 
}

}
}
finally {
$http.Stop()
}