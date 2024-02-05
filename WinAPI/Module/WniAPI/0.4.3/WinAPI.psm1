function Start-WinAPI {
    $Version     = "0.4.3"
    $winapi_path = "$(($env:PSModulePath -split ";")[0])\WInAPI\$Version\"
    $winapi_path = "$home\Documents\WInAPI"
    $ini_path    = "$winapi_path\winapi.ini"
    $Log_Path    = "$winapi_path\winapi.log"
    $ini         = Get-Content $ini_path
    $port        = $($ini | ConvertFrom-StringData).port
    $listen      = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction Ignore
    if ($listen) {
        $date = Get-Date -Format "dd.MM.yyyy hh:mm:ss"
        "$date Port $port is already in use" | Out-File $Log_Path -Encoding utf8 -Append    
    } 
    else {
        $proc_id = $(Start-Process pwsh -ArgumentList "-File $winapi_path\winapi.ps1" -Verb RunAs -WindowStyle Hidden -PassThru).id
        $proc_id > "$winapi_path\process_id.txt"
    }
}

function Stop-WinAPI {
    $Version = "0.4.3"
    $path    = "$(($env:PSModulePath -split ";")[0])\WInAPI\$Version\"
    $proc_id = Get-Content "$path\process_id.txt"
    Start-Process pwsh -ArgumentList "-Command Stop-Process -Id $proc_id" -Verb RunAs
}

function Get-WinAPI {
    $Version = "0.4.3"
    $path    = "$(($env:PSModulePath -split ";")[0])\WInAPI\$Version\"
    $ini     = Get-Content "$path\winapi.ini"
    $port    = $($ini | ConvertFrom-StringData).port
    $listen  = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction Ignore
    if ($listen) {
        Write-Host "Port $port - listen" -ForegroundColor Green
    } else {
        Write-Host "Port $port - not listen" -ForegroundColor Red
    }
}