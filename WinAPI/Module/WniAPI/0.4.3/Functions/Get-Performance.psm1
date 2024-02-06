function Get-Performance {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        $GC = Get-Counter
        $CollectionPerf = New-Object System.Collections.Generic.List[System.Object]
        $CollectionPerf.Add([PSCustomObject]@{
            CPUTotalTime  = [string]([int]($GC.CounterSamples[4].CookedValue))+" %"
            MemoryUse     = [string]([int]($GC.CounterSamples[2].CookedValue))+" %"
            DiskTotalTime = [string]([int]($GC.CounterSamples[1].CookedValue))+" %"
            AdapterName   = $GC.CounterSamples[0].InstanceName
            AdapterSpeed  = ($GC.CounterSamples[0].CookedValue/1024/1024).ToString("0.000 MByte/Sec")
        })
        $CollectionPerf
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/performance"
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