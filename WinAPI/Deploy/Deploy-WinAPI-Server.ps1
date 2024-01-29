$path = "$home\Documents\WinAPI"
if (Test-Path $path) {
    Remove-Item "$path\*" -Recurse -Force
}
else {
    New-Item -Path $path -ItemType Directory
}

### Install script script
$GitHub_Tag = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
$Version = $GitHub_Tag -replace ".+-"
#$Version = "0.4.1"
$url_raw = "https://raw.githubusercontent.com/Lifailon/WinAPI/rsa/WinAPI/Source/WinAPI-$Version.ps1"
Invoke-RestMethod -Uri $url_raw -OutFile "$path\WinAPI.ps1"

### Install process scripts
$url_process = "https://api.github.com/repos/Lifailon/WinAPI/contents/WinAPI/Process"
$Process_Files = Invoke-RestMethod -Uri $url_process
foreach ($Process_File in $Process_Files) {
    $File_Name = $Process_File.name
    $Url_Download = $Process_File.download_url
    Invoke-RestMethod -Uri $Url_Download -OutFile "$path\$File_Name"
}

### Install modules
New-Item -Path "$path\Modules\Get-Hardware" -ItemType Directory
$url_modules = "https://api.github.com/repos/Lifailon/WinAPI/contents/WinAPI/Modules/CIM/Get-Hardware"
$Modules_Files = Invoke-RestMethod -Uri $url_modules
$url_modules_download = $($Modules_Files | Where-Object Name -eq "Get-Hardware.psm1").download_url
Invoke-RestMethod -Uri $url_modules_download -OutFile "$path\Modules\Get-Hardware\Get-Hardware.psm1"