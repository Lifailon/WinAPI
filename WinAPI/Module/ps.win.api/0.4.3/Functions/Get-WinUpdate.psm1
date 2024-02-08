function Get-WinUpdate {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        Get-CimInstance Win32_QuickFixEngineering | Sort-Object -Descending InstalledOn | Select-Object HotFixID,
        @{
            name="InstallDate";expression={
                $_.InstalledOn.ToString("dd.MM.yyyy")
            }
        },
        Description,
        InstalledBy
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/update"
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