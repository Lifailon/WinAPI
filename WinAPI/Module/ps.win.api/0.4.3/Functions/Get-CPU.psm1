function Get-CPU {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        $CPU_Perf = Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor
        $CPU_Cores = $CPU_Perf | Where-Object Name -ne "_Total" | Sort-Object {[int]$_.Name}
        $CPU_Total = $CPU_Perf | Where-Object Name -eq "_Total"
        $CPU_All = $CPU_Cores + $CPU_Total
        $CPU_All | Select-Object Name,
        @{Label="ProcessorTime"; Expression={[String]$_.PercentProcessorTime+" %"}},
        @{Label="PrivilegedTime"; Expression={[String]$_.PercentPrivilegedTime+" %"}},
        @{Label="UserTime"; Expression={[String]$_.PercentUserTime+" %"}},
        @{Label="InterruptTime"; Expression={[String]$_.PercentInterruptTime+" %"}},
        @{Label="IdleTime"; Expression={[String]$_.PercentIdleTime+" %"}}
    }
    else {
        $url = "http://$($ComputerName):$($Port)/api/cpu"
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
