function Get-CPU {
    param (
        [switch]$Total
    )
    $CPU_Perf = Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor
    if ($Total) {
        $CPU_Replace = $CPU_Perf | Where-Object name -eq "_Total"
    }
    else {
        $CPU_Replace = $CPU_Perf | Where-Object name -ne "_Total"
    }
    $CPU_Replace = $CPU_Replace | Select-Object Name,
    @{Label="ProcessorTime"; Expression={[String]$_.PercentProcessorTime+" %"}},
    @{Label="PrivilegedTime"; Expression={[String]$_.PercentPrivilegedTime+" %"}},
    @{Label="UserTime"; Expression={[String]$_.PercentUserTime+" %"}},
    @{Label="InterruptTime"; Expression={[String]$_.PercentInterruptTime+" %"}},
    @{Label="IdleTime"; Expression={[String]$_.PercentIdleTime+" %"}}
    $CPU_Replace | Sort-Object {[int]$_.Name}
}