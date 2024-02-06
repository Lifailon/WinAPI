function Get-Driver {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        Get-CimInstance -Class Win32_PnPSignedDriver |
        Select-Object DriverProviderName, FriendlyName, Description, DriverVersion, DriverDate |
        Group-Object DriverProviderName, FriendlyName, Description, DriverVersion, DriverDate |
        ForEach-Object {$_.Group[0]}
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/driver"
        $EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${User}:${Pass}"))
        $Headers = @{"Authorization" = "Basic ${EncodingCred}"}
        try {
            Invoke-RestMethod -Headers $Headers -Uri $url
        }
        catch {
            Write-Host "Error connection" -ForegroundColor Red
        }
    }
}