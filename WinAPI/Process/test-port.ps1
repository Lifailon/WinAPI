$path = "$home\Documents\WinAPI"
$ini = Get-Content "$path\winapi.ini"
$port = $($ini | ConvertFrom-StringData).port
$listen = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction Ignore
if ($listen) {
    Write-Host "Port $port - listen" -ForegroundColor Green
} else {
    Write-Host "Port $port - not listen" -ForegroundColor Red
}
pause