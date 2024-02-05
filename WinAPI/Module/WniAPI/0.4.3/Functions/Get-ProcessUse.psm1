function Get-ProcessUse {
    Get-CimInstance Win32_PerfFormattedData_PerfProc_Process | Select-Object Name,PercentProcessorTime | Sort-Object -Descending PercentProcessorTime | Where-Object PercentProcessorTime -ne 0
}