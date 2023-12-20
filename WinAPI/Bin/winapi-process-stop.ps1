if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{
$arguments = "& '" +$myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb RunAs -ArgumentList $arguments
Break
}
Get-Process *winapi* | Stop-Process