function Get-NetStat {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        Get-NetTCPConnection -State Established,Listen | Sort-Object -Descending State |
        Select-Object @{name="ProcessName";expression={(Get-Process -Id $_.OwningProcess).ProcessName}},
        LocalAddress,
        LocalPort,
        RemotePort,
        @{name="RemoteHostName";expression={((nslookup $_.RemoteAddress)[3]) -replace ".+:\s+"}},
        RemoteAddress,
        State,
        CreationTime,
        @{Name="RunTime"; Expression={((Get-Date) - $_.CreationTime) -replace "\.\d+$"}},
        @{name="ProcessPath";expression={(Get-Process -Id $_.OwningProcess).Path}}
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/network/stat"
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