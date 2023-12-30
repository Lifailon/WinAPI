$path    = "$home\Documents\WinAPI"
$version = "0.3.2"

# Clear and creat directory
if (Test-Path $path) {
    Remove-Item -Recurse -Force -Path $path
    New-Item -ItemType Directory -Path $path
} 
else {
    New-Item -ItemType Directory -Path $path
}

# Download dependencies
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Lifailon/WinAPI/rsa/WinAPI/Source/WinAPI-$version.ps1" -OutFile "$path\winapi.ps1"
Invoke-RestMethod -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "$path\nssm.zip"
Expand-Archive -Path "$path\nssm.zip" -DestinationPath $path

# Install service
$nssm_exe_path = (Get-ChildItem $path -Recurse | Where-Object name -match nssm.exe | Where-Object FullName -Match win64).FullName
$pwsh_path     = (Get-Command pwsh.exe).Source
$script_path   = "$path\winapi.ps1"
$script_params = "-ExecutionPolicy Bypass -NoProfile -File $script_path"
$service_name  = "WinAPI"
& $nssm_exe_path install $service_name $pwsh_path $script_params
& $nssm_exe_path set $Service_Name description "REST API and simple Web server on base PowerShell and .NET HttpListener (GitHub by Lifailon)"
& $nssm_exe_path set $service_name AppExit Default Restart
& $nssm_exe_path set $service_name AppPriority ABOVE_NORMAL_PRIORITY_CLASS

# Start service
& $nssm_exe_path start $service_name
& $nssm_exe_path status $service_name