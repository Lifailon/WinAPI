### Get version
$GitHub_Tag = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
$Version = $GitHub_Tag -replace ".+-"
$Version = "0.4.3"

### Clear and creat path module
$path_root = "$(($env:PSModulePath -split ";")[0])\ps.win.api\"
$path = "$(($env:PSModulePath -split ";")[0])\ps.win.api\$Version"
if (Test-Path $path_root) {
    Remove-Item "$path_root\*" -Recurse -Force
}
New-Item -Path $path -ItemType Directory | Out-Null
New-Item -Path "$path\Functions" -ItemType Directory | Out-Null

### Download main server script
$url_server = "https://raw.githubusercontent.com/Lifailon/WinAPI/rsa/WinAPI/Server/WinAPI-$Version.ps1"
Start-Job {
    Invoke-RestMethod -Uri $using:url_server -OutFile "$using:path\WinAPI.ps1"
} | Out-Null

### Download ini
$url_ini = "https://raw.githubusercontent.com/Lifailon/WinAPI/rsa/WinAPI/Server/winapi.ini"
Start-Job {
    Invoke-RestMethod -Uri $using:url_ini -OutFile "$using:path\WinAPI.ini"
} | Out-Null

### Download module
$url_modules = "https://api.github.com/repos/Lifailon/WinAPI/contents/WinAPI/Module/ps.win.api/$Version"
$Module_Files = Invoke-RestMethod -Uri $url_modules
foreach ($Module_File in $Module_Files) {
    $File_Name = $Module_File.name
    $Url_Download = $Module_File.download_url
    Start-Job {
        Invoke-RestMethod -Uri $using:Url_Download -OutFile "$using:path\$using:File_Name"
    } | Out-Null
}

### Download functions
$url_modules = "https://api.github.com/repos/Lifailon/WinAPI/contents/WinAPI/Module/ps.win.api/$Version/Functions"
$Process_Files = Invoke-RestMethod -Uri $url_modules
foreach ($Process_File in $Process_Files) {
    $File_Name = $Process_File.name
    $Url_Download = $Process_File.download_url
    Start-Job {
        Invoke-RestMethod -Uri $using:Url_Download -OutFile "$using:path\Functions\$using:File_Name"
    } | Out-Null
}

while ($True) {
    $status_job = (Get-Job).State[-1]
    if ($status_job -like "Completed") {
        Get-Job | Remove-Job -Force
        Write-Host "Completed"
        break
    }
}