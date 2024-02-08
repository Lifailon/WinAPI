function Get-NetIpConfig {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true |
        Select-Object Description,
        @{Label="IPAddress"; Expression={[string]($_.IPAddress)}},
        @{Label="GatewayDefault"; Expression={[string]($_.DefaultIPGateway)}},
        @{Label="Subnet"; Expression={[string]($_.IPSubnet)}},
        @{Label="DNSServer"; Expression={[string]($_.DNSServerSearchOrder)}},
        MACAddress,
        DHCPEnabled,
        DHCPServer,
        DHCPLeaseObtained,
        DHCPLeaseExpires
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/network/ipconfig"
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