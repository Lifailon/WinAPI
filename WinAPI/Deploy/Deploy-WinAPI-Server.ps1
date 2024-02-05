### Get version
$GitHub_Tag = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
$Version = $GitHub_Tag -replace ".+-"
$Version = "0.4.3"

### Clear and creat path module
$path_root = "$(($env:PSModulePath -split ";")[0])\WInAPI\"
$path = "$(($env:PSModulePath -split ";")[0])\WInAPI\$Version"
if (Test-Path $path_root) {
    Remove-Item "$path_root\*" -Recurse -Force
}
New-Item -Path $path -ItemType Directory
New-Item -Path "$path\Functions" -ItemType Directory

### Download main server script
$url_raw = "https://raw.githubusercontent.com/Lifailon/WinAPI/rsa/WinAPI/Server/WinAPI-$Version.ps1"
Invoke-RestMethod -Uri $url_raw -OutFile "$path\WinAPI.ps1"

### Download module
$url_process = "https://api.github.com/repos/Lifailon/WinAPI/WinAPI/Module/WniAPI/$version"
$Process_Files = Invoke-RestMethod -Uri $url_process
foreach ($Process_File in $Process_Files) {
    $File_Name = $Process_File.name
    $Url_Download = $Process_File.download_url
    Invoke-RestMethod -Uri $Url_Download -OutFile "$path\$File_Name"
}

### Download functions
$url_process = "https://api.github.com/repos/Lifailon/WinAPI/WinAPI/Module/WniAPI/$version/Functions"
$Process_Files = Invoke-RestMethod -Uri $url_process
foreach ($Process_File in $Process_Files) {
    $File_Name = $Process_File.name
    $Url_Download = $Process_File.download_url
    Invoke-RestMethod -Uri $Url_Download -OutFile "$path\Functions\$File_Name"
}