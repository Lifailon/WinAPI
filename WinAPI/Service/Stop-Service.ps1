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
Get-Service *$service_name* | Stop-Service
Write-Host $($(Get-Service *$service_name*).Status) -ForegroundColor Green