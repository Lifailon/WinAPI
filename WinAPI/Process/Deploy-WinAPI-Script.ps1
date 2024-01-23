$path = "$home\Documents\WinAPI"
if (Test-Path $path) {
    Remove-Item "$path\*" -Recurse -Force
}
else {
    New-Item -Path $path -ItemType Directory
}
$GitHub_Tag = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
$Version = $GitHub_Tag -replace ".+-"
$Version = "0.3.2"
$url_raw = "https://raw.githubusercontent.com/Lifailon/WinAPI/rsa/WinAPI/Source/WinAPI-$Version.ps1"
Invoke-RestMethod -Uri $url_raw -OutFile "$path\WinAPI.ps1"
$url_process = "https://api.github.com/repos/Lifailon/WinAPI/contents/WinAPI/Process"
$Process_Files = Invoke-RestMethod -Uri $url_process
foreach ($Process_File in $Process_Files) {
    $File_Name = $Process_File.name
    $Url_Download = $Process_File.download_url
    Invoke-RestMethod -Uri $Url_Download -OutFile "$path\$File_Name"
}