function Get-MemorySlots {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        $Memory = Get-CimInstance Win32_PhysicalMemory |
        Select-Object Manufacturer,
        PartNumber,
        ConfiguredClockSpeed,
        @{Label="Memory"; Expression={[string]($_.Capacity/1Mb)}},
        Tag,DeviceLocator,
        BankLabel
        $CollectionMemory = New-Object System.Collections.Generic.List[System.Object]
        $Memory | ForEach-Object {
            $CollectionMemory.Add([PSCustomObject]@{
                Tag     = $_.Tag
                Model   = [String]$_.ConfiguredClockSpeed+" Mhz "+$_.Manufacturer+" "+$_.PartNumber
                Size    = [string]($_.Memory)+" Mb"
                Device  = $_.DeviceLocator
                Bank    = $_.BankLabel
            })
        }
        $CollectionMemory
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/memory/slots"
        $EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${User}:${Pass}"))
        $Headers = @{"Authorization" = "Basic ${EncodingCred}"}
        try {
            Invoke-RestMethod -Headers $Headers -Uri $url
        }
        catch {
            Write-Host "Error connection" -ForegroundColor Red
        }
    }
}1