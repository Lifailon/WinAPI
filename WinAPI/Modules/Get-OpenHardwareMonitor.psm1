function Get-OpenHardwareMonitor {
    $OHM_Proc = $(Get-Process OpenHardwareMonitor -ErrorAction Ignore)
    if ($null -eq $OHM_Proc) {
        $Process_Path = Find-Process OpenHardwareMonitor
        Start-Process $Process_Path
    }
    $Hardware = Get-CimInstance -Namespace "root/OpenHardwareMonitor" -ClassName Hardware |
    Select-Object Name,
    HardwareType,
    Identifier
    Get-CimInstance -Namespace "root/OpenHardwareMonitor" -ClassName Sensor | Select-Object @{
        name = "HardwareName"
        expression = {
            $Parent = $_.Parent
            $Hardware | Where-Object Identifier -match $Parent | Select-Object -ExpandProperty Name
        }
    },
    @{name = "SensorName";expression = { $_.Name }},
    @{name = "SensorType";expression = { "$($_.SensorType) $($_.Index)" }},
    Value,
    Min,
    Max | Sort-Object HardwareName,SensorType,SensorName
}