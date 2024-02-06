function Get-ProcessPerformance {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        $GetProcess = Get-Process -ErrorAction Ignore | Where-Object ProcessName -ne Idle
        $ProcessPerformance = Get-CimInstance Win32_PerfFormattedData_PerfProc_Process
        $Collections = New-Object System.Collections.Generic.List[System.Object]
        foreach ($Process in $GetProcess) {
            $ProcPerf = $ProcessPerformance | Where-Object IDProcess -eq $Process.Id
            $Collections.Add([PSCustomObject]@{
                Name           = $Process.Name
                ProcTime       = "$($ProcPerf.PercentProcessorTime) %"
                IOps           = $ProcPerf.IODataOperationsPersec
                IObsRead       = $($ProcPerf.IOReadBytesPersec / 1mb).ToString("0.00 Mb")
                IObsWrite      = $($ProcPerf.IOWriteBytesPersec / 1mb).ToString("0.00 Mb")
                RunTime        = if ($null -ne $Process.StartTime) {
                    $([string]([datetime](Get-Date) - $Process.StartTime) -replace "\.\d+$")
                }
                TotalTime      = $Process.TotalProcessorTime -replace "\.\d+$"
                UserTime       = $Process.UserProcessorTime -replace "\.\d+$"
                PrivTime       = $Process.PrivilegedProcessorTime -replace "\.\d+$"
                WorkingSet     = $($Process.WorkingSet / 1mb).ToString("0.00 Mb")
                PeakWorkingSet = $($Process.PeakWorkingSet / 1mb).ToString("0.00 Mb")
                PageMemory     = $($Process.PagedMemorySize / 1mb).ToString("0.00 Mb")
                Threads        = $Process.Threads.Count
                Handles        = $Process.Handles
                Path           = $Process.Path
                Company        = $Process.Company
                Version        = $Process.FileVersion
            })
        }
        $Collections | Sort-Object -Descending ProcTime,IOps,TotalTime
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/process"
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
