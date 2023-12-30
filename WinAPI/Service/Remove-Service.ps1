### CIM
# $Service = Get-CimInstance win32_service -Filter 'name="WinAPI"'
# $Service.Delete()

### NSSM
# $path    = "$home\Documents\WinAPI"
# $nssm_exe_path = (Get-ChildItem $path -Recurse | Where-Object name -match nssm.exe | Where-Object FullName -Match win64).FullName
# & $nssm_exe_path remove WinAPI

### Only PowerShell Core
function Get-RunAs {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Get-RunAs)) {
    $arguments = "-NoExit", "-Command", "& {", $myinvocation.mycommand.definition, "}"
    Start-Process pwsh -Verb RunAs -ArgumentList $arguments
    Exit
}

$service_name = "WinAPI"
Remove-Service $service_name
if (!(Get-Service $service_name -ErrorAction Ignore)) {
    Write-Host "True" -ForegroundColor Green
}