# Only use PowerShell 5.1
# Install-Module ps2exe
# Import-Module ps2exe

$git_path = "C:\Users\lifailon\Documents\Git\WinAPI" 
$version  = "0.3.1"

Invoke-ps2exe -inputFile "$git_path\WinAPI\Source\WinAPI-$version.ps1" `
-outputFile "$git_path\WinAPI\Bin\winapi-process.exe" `
-iconFile "$git_path\Screen\ico\winapi.ico" `
-title "Win-API" `
-version $version `
-company "GitHub by Lifailon" `
-product "GitHub by Lifailon" `
-copyright "GitHub by Lifailon" `
-description "REST API and simple Web server on base PowerShell and .NET HttpListener" `
-noConsole -noOutput -noError -requireAdmin

Invoke-ps2exe -inputFile "$git_path\WinAPI\Source\WinAPI-$version.ps1" `
-outputFile "$git_path\WinAPI\Bin\winapi-console.exe" `
-iconFile "$git_path\Screen\ico\winapi.ico" `
-title "Win-API" `
-version $version `
-company "GitHub by Lifailon" `
-product "GitHub by Lifailon" `
-copyright "GitHub by Lifailon" `
-description "REST API and simple Web server on base PowerShell and .NET HttpListener" `
-requireAdmin