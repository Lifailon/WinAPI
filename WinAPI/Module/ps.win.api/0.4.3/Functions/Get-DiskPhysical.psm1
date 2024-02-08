function Get-DiskPhysical {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        $PhysicalDisk = Get-CimInstance Win32_DiskDrive | 
        Select-Object Model,
        @{Label="Size"; Expression={[int]($_.Size/1Gb)}},
        Partitions,
        InterfaceType,
        Status,
        ConfigManagerErrorCode,
        LastErrorCode
        $CollectionPD = New-Object System.Collections.Generic.List[System.Object]
        $PhysicalDisk | ForEach-Object {
            $CollectionPD.Add([PSCustomObject]@{
                Model                  = $_.Model
                Size                   = [string]$_.Size+" Gb"
                PartitionCount         = $_.Partitions
                Interface              = $_.InterfaceType
                Status                 = $_.Status
                ConfigManagerErrorCode = $_.ConfigManagerErrorCode
                LastErrorCode          = $_.LastErrorCode
            })
        }
        $CollectionPD
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/disk/physical"
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