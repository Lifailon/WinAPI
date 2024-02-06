function Get-DiskPartition {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        $PhysicalDisk = Get-CimInstance -Namespace root/Microsoft/Windows/Storage -ClassName MSFT_PhysicalDisk
        $Partition = Get-CimInstance -Namespace root/Microsoft/Windows/Storage -ClassName MSFT_Partition | 
        Select-Object @{Label="Disk"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DiskNumber | Select-Object -ExpandProperty FriendlyName}},
        IsBoot,
        IsSystem,
        IsHidden,
        IsReadOnly,
        IsShadowCopy,
        @{Label="OffSet"; Expression={($_.OffSet/1Gb).ToString("0.00 Gb")}},
        @{Label="Size"; Expression={($_.Size/1Gb).ToString("0.00 Gb")}}
        $Partition | Sort-Object Disk,OffSet
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/disk/partition"
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