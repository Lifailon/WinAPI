function Start-WinAPI {
    $GitHub_Tag  = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
    $Version     = $GitHub_Tag -replace ".+-"
    $Version     = "0.4.3"
    $winapi_path = "$(($env:PSModulePath -split ";")[0])\ps.win.api\$Version\"
    $ini_path    = "$winapi_path\winapi.ini"
    $Log_Path    = "$winapi_path\winapi.log"
    $ini         = Get-Content $ini_path
    $port        = $($ini | ConvertFrom-StringData).port
    if ($null -eq $port) {
        $port = 8443
    }
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
    $GitHub_Tag = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
    $Version    = $GitHub_Tag -replace ".+-"
    $Version    = "0.4.3"
    $path       = "$(($env:PSModulePath -split ";")[0])\ps.win.api\$Version\"
    $proc_id    = Get-Content "$path\process_id.txt"
    Start-Process pwsh -ArgumentList "-Command Stop-Process -Id $proc_id" -Verb RunAs
}

function Test-WinAPI {
    $GitHub_Tag = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
    $Version    = $GitHub_Tag -replace ".+-"
    $Version    = "0.4.3"
    $path       = "$(($env:PSModulePath -split ";")[0])\ps.win.api\$Version\"
    $ini        = Get-Content "$path\winapi.ini"
    $port       = $($ini | ConvertFrom-StringData).port
    $listen     = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction Ignore
    $Collections = New-Object System.Collections.Generic.List[System.Object]
    if ($listen) {
        $Collections.Add([PSCustomObject]@{
            Port = $port;
            Status = "Open"
        })
    } else {
        $Collections.Add([PSCustomObject]@{
            Port = $port;
            Status = "Closed"
        })
    }
    $Collections
}

function Read-WinAPI {
    $GitHub_Tag = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
    $Version    = $GitHub_Tag -replace ".+-"
    $Version    = "0.4.3"
    $winapi_path = "$(($env:PSModulePath -split ";")[0])\ps.win.api\$Version\"
    $Log_Path    = "$winapi_path\winapi.log"
    Get-Content $Log_Path -Wait
}