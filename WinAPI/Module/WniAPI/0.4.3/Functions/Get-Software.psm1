function Get-Software {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        Get-CimInstance Win32_Product  | Sort-Object -Descending  InstallDate | Select-Object Name,
        Version,
        Vendor,
        @{
            name="InstallDate";expression={
                [datetime]::ParseExact($_.InstallDate, "yyyyMMdd", $null).ToString("dd.MM.yyyy")
            }
        },
        InstallLocation,
        InstallSource,
        PackageName,
        LocalPackage
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/software"
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