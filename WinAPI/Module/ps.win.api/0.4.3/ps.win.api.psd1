@{
    RootModule        = "ps.win.api.psm1"
    ModuleVersion     = "0.4.3"
    Author            = "Lifailon"
    Copyright         = "Apache-2.0"
    Description       = "REST API and Web server based on .NET HttpListener and backend PowerShell Core for Windows remote managment via Web browser or curl from Linux"
    PowerShellVersion = "7.3"
    NestedModules = @(
        "Functions\Find-Process.psm1",
        "Functions\Get-ProcessPerformance.psm1",
        "Functions\Get-Performance.psm1",
        "Functions\Get-Files.psm1",
        "Functions\Get-Event.psm1",
        "Functions\Get-Hardware.psm1",
        "Functions\Get-HardwareNoJob.psm1",
        "Functions\Get-CPU.psm1",
        "Functions\Get-MemorySize.psm1",
        "Functions\Get-MemorySlots.psm1",
        "Functions\Get-DiskPhysical.psm1",
        "Functions\Get-DiskLogical.psm1",
        "Functions\Get-DiskPartition.psm1",
        "Functions\Get-IOps.psm1",
        "Functions\Get-Smart.psm1",
        "Functions\Get-NetStat.psm1",
        "Functions\Get-NetIpConfig.psm1",
        "Functions\Get-NetInterfaceStat.psm1",
        "Functions\Get-VideoCard.psm1",
        "Functions\Get-WinUpdate.psm1",
        "Functions\Get-Software.psm1",
        "Functions\Get-Driver.psm1"
    )
    PrivateData       = @{
        PSData = @{
            Tags         = @("Microsoft","Windows","dotNET","API","Web","HTTP","Server","Web-Server","HTTP-Server","API-Server","REST-Server")
            ProjectUri   = "https://github.com/Lifailon/WinAPI"
            LicenseUri   = "https://github.com/Lifailon/WinAPI/blob/rsa/LICENSE"
        }
    }
}