### ©2023 Lifailon
### Source: https://github.com/Lifailon/WinAPI
### REST API and Web server for [Kinozal-Bot](https://github.com/Lifailon/Kinozal-Bot)
<# Client
# Login and password default:
$user = "rest"
$pass = "api"
# Example 1:
$SecureString = ConvertTo-SecureString $pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($user, $SecureString)
Invoke-RestMethod -Credential $Credential -AllowUnencryptedAuthentication -Uri http://192.168.3.99:8443/api/service
# Example 2:
$EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))
$Headers = @{"Authorization" = "Basic ${EncodingCred}"}
Invoke-RestMethod -Headers $Headers -Uri http://192.168.3.99:8443/api/service
### POST Request
$Headers += @{"Status" = "Stop"}
Invoke-RestMethod -Headers $Headers -Method Post -Uri http://192.168.3.99:8443/api/service/winrm
# Example 3 (cURL Client):
user="rest"
pass="api"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service | jq  -r '.[] | {data: "\(.Name) - \(.Status)"} | .data'
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service/win
curl -s -X GET -u $user:$pass -H 'Content-Type: application/json' http://192.168.3.99:8443/api/service/winrm
curl -s -X GET -u $user:$pass -H 'Content-Type: application/html' http://192.168.3.99:8443/api/service/winrm
curl -s -X GET -u $user:$pass -H 'Content-Type: application/xml' http://192.168.3.99:8443/api/service/winrm
curl -s -X GET -u $user:$pass -H 'Content-Type: application/csv' http://192.168.3.99:8443/api/service/winrm
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/process
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/process/torrent
# POST Stop and Start Service
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/service/winrm -H "Status: Stop"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/service/winrm -H "Status: Start"
# POST Stop and Start Process
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Check"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Stop"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/plex_media_server -H "Status: Stop"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/plex_media_server -H "Status: Start" -H "Path: C:\Program Files\Plex\Plex Media Server\Plex Media Server.exe"
# GET Hardware
Get-Hardware -ComputerName 192.168.3.99 -Port 8443 -User rest -Pass api
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/hardware
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/performance
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/cpu
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/memory
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/memory/slots
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/physical
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/logical
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/partition
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/smart
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/iops
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/video
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/network/ipconfig
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/network/stat
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/network/interface/stat/current
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/network/interface/stat/total
# GET OpenHardwareMonitor or LibreHardwareMonitor (https://github.com/Lifailon/PowerShellHardwareMonitor)
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/sensor
# GET Files
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash/4 sezon"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash/4 sezon/The.Flash.S04E23.1080p.rus.LostFilm.TV.mkv"
# POST File-Delete
curl -s -X POST -u $user:$pass -data '' http://192.168.3.99:8443/api/file-delete -H "Path: D:/Movies/The-Flash/4 sezon/The.Flash.S04E23.1080p.rus.LostFilm.TV.mkv"
# Web
http://localhost:8443/service
http://localhost:8443/process
http://localhost:8443/events/list
http://localhost:8443/events/<Event_Name>
#>

#region RunAs Admin
function Get-RunAs {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Get-RunAs)) {
    $arguments = "-NoExit", "-Command", "& {", $myinvocation.mycommand.definition, "}"
    Start-Process pwsh -Verb RunAs -ArgumentList $arguments
    Exit
}
#endregion

#region Config (ini)
###### Creat path and ini file
$GitHub_Tag      = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/WinAPI/releases/latest").tag_name
$Version         = $GitHub_Tag -replace ".+-"
$Version         = "0.4.3"
$winapi_path     = "$(($env:PSModulePath -split ";")[0])\WInAPI\$Version\"
$ini_path        = "$winapi_path\WinAPI.ini"
$Log_Path        = "$winapi_path\WinAPI.log"

###### Read ini and write variables
$ini          = Get-Content $ini_path | ConvertFrom-StringData
$port         = $ini.port
$user         = $ini.user
$pass         = $ini.pass
$Log_Console  = $ini.Log_Console
$Log_File     = $ini.Log_File
$SensorSource = $ini.SensorSource
$cred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))
#endregion

#region HTML Head (ico and title) and Body (style and buttons)
$icoBase64 = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAwhJREFUWIXll09sDFEcx7/fNzNt021US4KGiIOKkjTb+BMODi6aODgQiThJEyTUNg40Dg6Ei0MpjeDAnYs4iqRCQgTdQ/XQRog4UDQcsJ2ZfV+H6tp2d7bt7JaD72nevN+b7+e9efN+vwH+d3GuA64Mqs7PZDYZ12mmsIgArTAGZEcytuZZ9wZ+qziAJF5Oh7ssdIjAdpJVReOgkMJD0Nx4NOzcub2X2bIBetL+Zke8CiI5G9g8DVE40pn0+ksFmVKdFwf8EwZ4HMMcAFoEPbiUDs5CipxoZEfvy6AHBl0xjAskq5uppNcBUtP7iq7AxQH/RKXMAYCGB3rT4bmifdNv9KT9zQZ4TNCtFMCEZK1le1ebdz//7pQVkERHvFp5cwCgMQZ9157LiwS4nA53xdxws9XqcSe7PxJA5MF5NJ90OZTfyu2BK4OqywbBl6hDpmL2khzPazq6nh+AvBXIBuHG+TYHAJK04fjWyXYOQNSa+Tb/I9NcAEBi0d+yl7S4EMDOPTPGlym8mkip8bVwDruHUs4r7zPMjpQDsLYRWNswu1hL5bxyABlb80xQGBeAALY1AU2J0nGSRBM+KQDo3sBvFB7GBRAAh0T7CqC+9OsYSLUm3hcAAABobsQFwO9EW+MSO1cC1U7xMMJcz29PAXg07NwBMBQb4rcWVhM7VhTmeknvlHBuRQLc3ssshSOQbLkQy+uIbU1TzAXxWKqZ45EAANCZ9PpFni8XAABaGonWyeON7Eu1eXenxxStiFKt7mlBN8sx/xkKWStsWQq0NKh/WatbtMIqXniQSkkdvenwA6iTAEsWr0BuD+LjDyHhAa/GgBejUqKKfftWhRdqWVW0RI9+MKljSe+UtWwHMKtDavSncO8tMPwVaGmAJbi7Y53XWVtb+y5qzIwz62rz7leH7jqIByA8lVRQ2QLA5wxw743kW7z4lMGZOg88vB4/Znp+nF+zpRP53DRPZDUDSmOWGqEJn0weMkEQDJB87brunrl6VES+7x8PguC7pAX/BEBSvaQlM8X9ArroIy6ymf1mAAAAAElFTkSuQmCC"
$icoHead += "<link rel='icon' type='image/x-icon' href='data:image/x-icon;base64,$icoBase64'>"
$icoHead += "<title>WinAPI</title>"
$BodyButtons = "<style>
    body {
        background-color: rgb(55, 55, 65);
        color: white;
    }
    button {
        margin-bottom: 6px;
        display: inline-block;
        background: #2196f3;
        color: #fff;
        font-size: 14px;
        font-family: Tahoma;
        border: none;
        border-radius: 10px;
        padding: 6px;
        line-height: 1;
        cursor: pointer;
    }
    img {
        margin-bottom: -10px;
    }
</style>"
$BodyButtons += "<img src='data:image/png;base64,$icoBase64'> "
$BodyButtons += "<button onclick='location.href=""/service""'>Service</button> "
$BodyButtons += "<button onclick='location.href=""/process""'>Process</button> "
$BodyButtons += "<button onclick='location.href=""/events/list""'>Events</button> "
$BodyButtons += "<button onclick='location.href=""/api/sensor""'>Sensors</button> "
$BodyButtons += "<button onclick='location.href=""/api/hardware""'>Hardware</button> "
$BodyButtons += "<button onclick='location.href=""/api/performance""'>Performance</button> "
$BodyButtons += "<button onclick='location.href=""/api/cpu""'>CPU</button> "
$BodyButtons += "<button onclick='location.href=""/api/memory""'>Memory</button> "
$BodyButtons += "<button onclick='location.href=""/api/disk/physical""'>Physical Disk</button> "
$BodyButtons += "<button onclick='location.href=""/api/disk/logical""'>Logical Disk</button> "
$BodyButtons += "<button onclick='location.href=""/api/disk/partition""'>Disk Partitions</button> "
$BodyButtons += "<button onclick='location.href=""/api/disk/smart""'>SMART</button> "
$BodyButtons += "<button onclick='location.href=""/api/disk/iops""'>IOps</button> "
$BodyButtons += "<button onclick='location.href=""/api/video""'>Video</button> "
$BodyButtons += "<button onclick='location.href=""/api/network/ipconfig""'>IPConfig</button> "
$BodyButtons += "<button onclick='location.href=""/api/network/stat""'>Netstat</button> "
$BodyButtons += "<button onclick='location.href=""/api/network/interface/stat/current""'>Interfaces Stat Current</button> "
$BodyButtons += "<button onclick='location.href=""/api/network/interface/stat/total""'>Interfaces Stat Total</button><br><br>"
#endregion

#region main-functions (log/response/event/service/process/fs)
function Get-Log {
    ### Debug (Get all Request, Headers and Response parameters):
    # $context.Request | Out-Default
    # foreach ($header in $context.Request.Headers) {
    #     Write-Host "$header = $($context.Request.Headers[$header])"
    # }
    # $context.Response | Out-Default
    $remote_host   = $context.Request.RemoteEndPoint
    $client_agent  = $context.Request.UserAgent
    $method        = $context.Request.HttpMethod
    $endpoint      = $context.Request.RawUrl
    $response_code = $context.Response.StatusCode
    ### Output log to console
    if ($Log_Console -eq "True") {
        Write-Host "$remote_host $client_agent" -f Blue -NoNewline
        Write-Host " => " -NoNewline
        Write-Host "$method $endpoint" -f Green -NoNewline
        Write-Host " => " -NoNewline
        Write-Host "$response_code" -f Green
    }
    ### Output log to file
    if ($Log_File -eq "True") {
        $date = Get-Date -Format "dd.MM.yyyy hh:mm:ss"
        "$date $remote_host $client_agent => $method $endpoint => $response_code" | Out-File $Log_Path -Encoding utf8 -Append
    }
}

function Send-Response {
    param (
        $Data,
        [int]$Code,
        [switch]$v2,
        [switch]$Body,
        [switch]$fl,
        [switch]$EncodingWin1251
    )
    ### Data convertion and set response encoding in UTF-8
    if ($v2 -eq $false) {
        if ($Code -eq 200) {
            if (($context.Request.UserAgent -match "Chrome") -or ($context.Request.ContentType -match "html")) {
                if ($Body) {
                    if ($fl) {
                        $Data = $Data | ConvertTo-Html -Head $icoHead -Body $BodyButtons -As List
                    } else {
                        $Data = $Data | ConvertTo-Html -Head $icoHead -Body $BodyButtons
                    }
                }
                else {
                    $Data = $Data | ConvertTo-Html
                }
                $context.Response.ContentType = "text/html; charset=utf-8"
            }
            elseif ($context.Request.ContentType -match "xml") {
                $Data = ($Data | ConvertTo-Xml).OuterXml
                $context.Response.ContentType = "text/xml; charset=utf-8"
            }
            elseif ($context.Request.ContentType -match "csv") {
                $Data = $Data | ConvertTo-Csv
                $context.Response.ContentType = "text/csv; charset=utf-8"
            }
            else {
                $Data = $Data | ConvertTo-Json
                $context.Response.ContentType = "text/json; charset=utf-8"
            }
        }
    }
    $context.Response.StatusCode = $Code
    if ($EncodingWin1251) {
        $buffer = [System.Text.Encoding]::GetEncoding("Windows-1251").GetBytes($Data)
    }
    else {
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($Data)
    }
    Get-Log
    $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
    $context.Response.OutputStream.Flush()
    $context.Response.OutputStream.Close()
}

function Get-Event {
    param (
        [string]$LogName,
        [switch]$List
    )
    if ($List) {
        Get-WinEvent -ListLog * | Where-Object RecordCount -gt 0 | 
        Select-Object RecordCount,
        @{Name="LastWriteTime"; Expression={Get-Date -Date $($_.LastWriteTime) -UFormat "%d.%m.%Y %T"}},
        @{Name="FileSize"; Expression={($_.FileSize / 1024kb).ToString("0.00 Mb")}},
        LogIsolation,
        LogType,
        LogName | Sort-Object LogIsolation
    }
    else {
        Get-WinEvent -LogName $LogName | Select-Object @{Name="TimeCreated"; Expression={Get-Date -Date $($_.TimeCreated) -UFormat "%d.%m.%Y %T"}},
        LevelDisplayName,
        Level,
        Message
    }
}

function Get-ServiceDescription {
    param (
        $ServiceName
    )
    Get-Service -ErrorAction Ignore $ServiceName | Select-Object name,DisplayName, 
    @{Name="Status"; Expression={[string]$_.status}},
    @{Name="StartType"; Expression={[string]$_.StartType}}
}

function Get-ProcessDescription {
    param (
        $ProcessName
    )
    if ($null -eq $ProcessName) {
        $GetProcess = Get-Process -ErrorAction Ignore
    }
    else {
        $GetProcess = Get-Process -Name $ProcessName -ErrorAction Ignore
    }
    if ($null -ne $GetProcess) {
        $GetProcess | Sort-Object -Descending CPU | Select-Object ProcessName,
        @{Name="TotalProcTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},
        @{Name="UserProcTime"; Expression={$_.UserProcessorTime -replace "\.\d+$"}},
        @{Name="PrivilegedProcTime"; Expression={$_.PrivilegedProcessorTime -replace "\.\d+$"}},
        @{Name="WorkingSet"; Expression={[string]([int]($_.WS / 1024kb))+" MB"}},
        @{Name="PeakWorkingSet"; Expression={[string]([int]($_.PeakWorkingSet / 1024kb))+" MB"}},
        @{Name="PageMemory"; Expression={[string]([int]($_.PM / 1024kb))+" MB"}},
        @{Name="VirtualMemory"; Expression={[string]([int]($_.VM / 1024kb))+" MB"}},
        @{Name="PrivateMemory"; Expression={[string]([int]($_.PrivateMemorySize / 1024kb))+" MB"}},
        @{Name="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}},
        @{Name="Threads"; Expression={$_.Threads.Count}},
        Handles,Path
    }
}

function Find-Process {
    param (
        $ProcessName
    )
    $PathSearchArray = @(
        "$env:SystemDrive\Program Files",
        "$env:SystemDrive\Program Files (x86)",
        "$env:HOMEPATH\AppData\Roaming",
        "$env:HOMEPATH\Documents"
    )
    foreach ($PathSearch in $PathSearchArray) {
        $ProcessPath = (Get-ChildItem $PathSearch | Where-Object Name -match $ProcessName).FullName
        if ($null -ne $ProcessPath) {
            break
        }
    }
    $ProcessNameExec = "$($ProcessName).exe"
    (Get-ChildItem $ProcessPath -Recurse | Where-Object Name -eq $ProcessNameExec).FullName
}

# Find-Process OpenHardwareMonitor # C:\Users\lifailon\Documents\OpenHardwareMonitor-0.9.6\OpenHardwareMonitor-0.9.6\OpenHardwareMonitor.exe
# Find-Process qbittorrent # C:\Program Files\qBittorrent\qbittorrent.exe
# Find-Process nmap # C:\Program Files (x86)\Nmap\nmap.exe
# Find-Process telegram # C:\Users\lifailon\AppData\Roaming\Telegram Desktop\Telegram.exe

function Get-Files {
    param (
        [Parameter(Mandatory)][string]$Path
    )
    $files = Get-ChildItem $Path
    $Collection_Files = New-Object System.Collections.Generic.List[System.Object]
    foreach ($file in $files) {
        if ($file.Length -eq 1) {
            $type            = "Directory"
            $ChildItem       = Get-ChildItem -Path $file.FullName -Recurse -ErrorAction Ignore
            $size            = ($ChildItem | Measure-Object -Property Length -Sum).Sum/1gb
            $size            = [string]([double]::Round($size, 3))+" GB"
            $Files_Count     = $ChildItem | Where-Object { $_.PSIsContainer -eq $false }
            $Directory_Count = $ChildItem | Where-Object { $_.PSIsContainer -eq $true }
        } else {
            $type            = "File"
            $size            = $file.Length / 1gb
            $size            = [string]([double]::Round($size, 3))+" GB"
        }
        $Collection_Files.Add([PSCustomObject]@{
            Name           = $file.Name
            FullName       = $file.FullName
            Type           = $type
            Size           = $size
            Files          = $Files_Count.Count
            Directory      = $Directory_Count.Count
            CreationTime   = Get-Date -Date $file.CreationTime -Format "dd/MM/yyyy hh:mm:ss"
            LastAccessTime = Get-Date -Date $file.LastAccessTime -Format "dd/MM/yyyy hh:mm:ss"
            LastWriteTime  = Get-Date -Date $file.LastWriteTime -Format "dd/MM/yyyy hh:mm:ss"
        })
    }
    $Collection_Files
}

# Get-Files -Path "C:/"
# Get-Files -Path "C:/Program Files/"
# Get-Files -Path "D:/"
# Get-Files -Path "D:/Movies/"
#endregion 

#region cim-functions
### Dependency install
Import-Module ThreadJob -ErrorAction Ignore
if (!(Get-Module ThreadJob)) {
   Install-Module ThreadJob -Scope CurrentUser -Force
}

function Get-Hardware {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        # Creat jobs
        Start-ThreadJob -Name SYS -ScriptBlock {Get-CimInstance Win32_ComputerSystem} | Out-Null
        Start-ThreadJob -Name OS -ScriptBlock {Get-CimInstance Win32_OperatingSystem} | Out-Null
        Start-ThreadJob -Name BB -ScriptBlock {Get-CimInstance Win32_BaseBoard} | Out-Null
        Start-ThreadJob -Name CPU -ScriptBlock {Get-CimInstance Win32_Processor} | Out-Null
        Start-ThreadJob -Name CPU_Use -ScriptBlock {Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor} | Out-Null
        Start-ThreadJob -Name GetProcess -ScriptBlock {Get-Process} | Out-Null
        Start-ThreadJob -Name MEM -ScriptBlock {Get-CimInstance Win32_PhysicalMemory} | Out-Null
        Start-ThreadJob -Name PhysicalDisk -ScriptBlock {Get-CimInstance Win32_DiskDrive} | Out-Null
        Start-ThreadJob -Name LogicalDisk -ScriptBlock {Get-CimInstance Win32_logicalDisk} | Out-Null
        Start-ThreadJob -Name IOps -ScriptBlock {Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk} | Out-Null
        Start-ThreadJob -Name VideoCard -ScriptBlock {Get-CimInstance Win32_VideoController} | Out-Null
        Start-ThreadJob -Name NetworkAdapter -ScriptBlock {Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true} | Out-Null
        Start-ThreadJob -Name InterfaceStatCurrent -ScriptBlock {Get-CimInstance -ClassName Win32_PerfFormattedData_Tcpip_NetworkInterface} | Out-Null
        Start-ThreadJob -Name InterfaceStatAll -ScriptBlock {Get-CimInstance -ClassName Win32_PerfRawData_Tcpip_NetworkInterface} | Out-Null
        # Get data from jobs
        Start-Sleep -Milliseconds 100
        while ($(Get-Job).State -contains "Running") {
            Start-Sleep -Milliseconds 100
        }
        $SYS = Get-Job -Name SYS | Receive-Job
        $OS = Get-Job -Name OS | Receive-Job
        $BB = Get-Job -Name BB | Receive-Job
        $CPU = Get-Job -Name CPU | Receive-Job
        $CPU_Use = Get-Job -Name CPU_Use | Receive-Job
        $GetProcess = Get-Job -Name GetProcess | Receive-Job
        $MEM = Get-Job -Name MEM | Receive-Job
        $PhysicalDisk = Get-Job -Name PhysicalDisk | Receive-Job
        $LogicalDisk = Get-Job -Name LogicalDisk | Receive-Job
        $IOps = Get-Job -Name IOps | Receive-Job
        $VideoCard = Get-Job -Name VideoCard | Receive-Job
        $NetworkAdapter = Get-Job -Name NetworkAdapter | Receive-Job
        $InterfaceStatCurrent = Get-Job -Name InterfaceStatCurrent | Receive-Job
        $InterfaceStatAll = Get-Job -Name InterfaceStatAll | Receive-Job
        Get-Job | Remove-Job -Force
        # Select data
        $Uptime = ([string]($OS.LocalDateTime - $OS.LastBootUpTime) -split ":")[0,1] -join ":"
        $BootDate = Get-Date -Date $($OS).LastBootUpTime -Format "dd/MM/yyyy hh:mm:ss"
        $BBv = $BB.Manufacturer+" "+$BB.Product+" "+$BB.Version
        $CPU = $CPU | Select-Object Name,
            @{Label="Core"; Expression={$_.NumberOfCores}},
            @{Label="Thread"; Expression={$_.NumberOfLogicalProcessors}}
        $CPU_Use_Proc = [string](($CPU_Use | Where-Object name -eq "_Total").PercentProcessorTime)+" %"
        $Process_Count = $GetProcess.Count
        $Threads_Count = $GetProcess.Threads.Count
        $Handles_Count = ($GetProcess.Handles | Measure-Object -Sum).Sum
        $ws = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
        $pm = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
        $MemUse = $OS.TotalVisibleMemorySize - $OS.FreePhysicalMemory
        $MemUserProc = ($MemUse / $OS.TotalVisibleMemorySize) * 100
        $MEM = $MEM | Select-Object Manufacturer,PartNumber,ConfiguredClockSpeed,
            @{Label="Memory"; Expression={[string]($_.Capacity/1Mb)}}
        $MEMs = $MEM.Memory | Measure-Object -Sum
        $PhysicalDisk = $PhysicalDisk | Select-Object Model,
            @{Label="Size"; Expression={[int]($_.Size/1Gb)}}
        $PDs = $PhysicalDisk.Size | Measure-Object -Sum
        $LogicalDisk = $LogicalDisk | Where-Object {$null -ne $_.Size} |
            Select-Object @{Label="Value"; Expression={$_.DeviceID}},
            @{Label="AllSize"; Expression={([int]($_.Size/1Gb))}},
            @{Label="FreeSize"; Expression={([int]($_.FreeSpace/1Gb))}},
            @{Label="Free%"; Expression={[string]([int]($_.FreeSpace/$_.Size*100))+" %"}}
        $LDs = $LogicalDisk.AllSize | Measure-Object -Sum
        $IOps = $IOps | Where-Object { $_.Name -eq "_Total" } | Select-Object Name,
            @{name="TotalTime";expression={"$($_.PercentDiskTime) %"}},
            @{name="IOps";expression={$_.DiskTransfersPersec}},
            @{name="ReadBytesPersec";expression={$($_.DiskReadBytesPersec/1mb).ToString("0.000 MByte/Sec")}},
            @{name="WriteBytesPersec";expression={$($_.DiskWriteBytesPersec/1mb).ToString("0.000 MByte/Sec")}}
        $VideoCard = $VideoCard | Select-Object @{Label="VideoCard"; Expression={$_.Name}},
            @{Label="Display"; Expression={[string]$_.CurrentHorizontalResolution+"x"+[string]$_.CurrentVerticalResolution}}, 
            @{Label="vRAM"; Expression={([int]$($_.AdapterRAM/1Gb))}}
        $VCs = $VideoCard.vRAM | Measure-Object -Sum
        $NAs = $NetworkAdapter | Measure-Object
        $InterfaceStatCurrent = $InterfaceStatCurrent | Select-Object Name,
            @{name="Total";expression={$($_.BytesTotalPersec/1mb).ToString("0.000 MByte/Sec")}},
            @{name="Received";expression={$($_.BytesReceivedPersec/1mb).ToString("0.000 MByte/Sec")}},
            @{name="Sent";expression={$($_.BytesSentPersec/1mb).ToString("0.000 MByte/Sec")}}
        $InterfaceStatAll = $InterfaceStatAll | Select-Object Name,
            @{name="Total";expression={$($_.BytesTotalPersec/1gb).ToString("0.00 GByte")}},
            @{name="Received";expression={$($_.BytesReceivedPersec/1gb).ToString("0.00 GByte")}},
            @{name="Sent";expression={$($_.BytesSentPersec/1gb).ToString("0.00 GByte")}}
        $PortListenCount = $(Get-NetTCPConnection -State Listen).Count
        $PortEstablishedCount = $(Get-NetTCPConnection -State Established).Count
        $Collection = New-Object System.Collections.Generic.List[System.Object]
        $Collection.Add([PSCustomObject]@{
            Host                      = $SYS.Name
            Uptime                    = $uptime
            BootDate                  = $BootDate
            Owner                     = $SYS.PrimaryOwnerName
            OS                        = $OS.Caption
            Motherboard               = $BBv
            Processor                 = $CPU[0].Name
            Core                      = $CPU[0].Core
            Thread                    = $CPU[0].Thread
            CPU                       = $CPU_Use_Proc
            ProcessCount              = $Process_Count
            ThreadsCount              = $Threads_Count
            HandlesCount              = [int]$Handles_Count
            MemoryAll                 = [string]$($MEMs.Sum/1Kb)+" GB"
            MemoryUse                 = ($MemUse/1mb).ToString("0.00 GB")
            MemoryUseProc             = [string]([int]$MemUserProc)+" %"
            WorkingSet                = $ws
            PageMemory                = $pm
            MemorySlots               = $MEMs.Count
            PhysicalDiskCount         = $PDs.Count
            PhysicalDiskAllSize       = [string]$PDs.Sum+" Gb"
            LogicalDiskCount          = $LDs.Count
            LogicalDiskAllSize        = [string]$LDs.Sum+" Gb"
            DiskTotalTime             = $IOps.TotalTime
            DiskTotalIOps             = $IOps.IOps
            DiskTotalRead             = $IOps.ReadBytesPersec
            DiskTotalWrite            = $IOps.WriteBytesPersec
            VideoCardCount            = $VCs.Count
            VideoCardAllSize          = [string]$VCs.Sum+" Gb"
            NetworkAdapterEnableCount = $NAs.Count
            NetworkReceivedCurrent    = $InterfaceStatCurrent.Received
            NetworkSentCurrent        = $InterfaceStatCurrent.Sent
            NetworkReceivedTotal      = $InterfaceStatAll.Received
            NetworkSentTotal          = $InterfaceStatAll.Sent
            PortListenCount           = $PortListenCount
            PortEstablishedCount      = $PortEstablishedCount
        })
        $Collection
    }
    else {
        $url = "http://$ComputerName"+":$Port/api/hardware"
        $EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${User}:${Pass}"))
        $Headers = @{"Authorization" = "Basic ${EncodingCred}"}
        try {
            Invoke-RestMethod -Headers $Headers -Uri $url
        }
        catch {
            Write-Error "Error connection"
        }
    }
}

function Get-Performance {
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

function Get-CPU {
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

function Get-MemorySize {
    $Memory           = Get-CimInstance Win32_OperatingSystem
    $MemUse           = $Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory
    $MemUserProc      = ($MemUse / $Memory.TotalVisibleMemorySize) * 100
    $PageSize         = $Memory.TotalVirtualMemorySize - $Memory.TotalVisibleMemorySize
    $PageFree         = $Memory.FreeVirtualMemory - $Memory.FreePhysicalMemory
    $PageUse          = $PageSize - $PageFree
    $PageUseProc      = ($PageUse / $PageSize) * 100
    $PageFile         = Get-CimInstance Win32_PageFileUsage
    $PagePath         = [string]$($PageFile).Description
    $MemVirtUse       = $Memory.TotalVirtualMemorySize - $Memory.FreeVirtualMemory
    $MemVirtUseProc   = ($MemVirtUse / $Memory.TotalVirtualMemorySize) * 100
    $GetProcess       = Get-Process
    $ws               = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $pm               = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $CollectionMemory = New-Object System.Collections.Generic.List[System.Object]
    $CollectionMemory.Add([PSCustomObject]@{
        MemoryAll         = ($memory.TotalVisibleMemorySize/1mb).ToString("0.00 GB")
        MemoryUse         = ($MemUse/1mb).ToString("0.00 GB")
        MemoryUseProc     = [string]([int]$MemUserProc)+" %"
        PageSize          = ($PageSize/1mb).ToString("0.00 GB")
        PageUse           = ($PageUse/1mb).ToString("0.00 GB")
        PageUseProc       = [string]([int]$PageUseProc)+" %"
        PagePath          = $PagePath
        MemoryVirtAll     = ($memory.TotalVirtualMemorySize/1mb).ToString("0.00 GB")
        MemoryVirtUse     = ($MemVirtUse/1mb).ToString("0.00 GB")
        MemoryVirtUseProc = [string]([int]$MemVirtUseProc)+" %"
        ProcWorkingSet    = $ws
        ProcPageMemory    = $pm
    })
    $CollectionMemory
}

function Get-MemorySlots {
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

function Get-DiskPhysical {
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

function Get-DiskLogical {
    $LogicalDisk = Get-CimInstance Win32_logicalDisk | Where-Object {$null -ne $_.Size} |
    Select-Object @{Label="Value"; Expression={$_.DeviceID}},
    @{Label="AllSize"; Expression={([int]($_.Size/1Gb))}},
    @{Label="FreeSize"; Expression={([int]($_.FreeSpace/1Gb))}},
    @{Label="Free%"; Expression={
    [string]([int]($_.FreeSpace/$_.Size*100))+" %"}},
    FileSystem,
    VolumeName
    $CollectionLD = New-Object System.Collections.Generic.List[System.Object]
    $LogicalDisk | ForEach-Object {
        $CollectionLD.Add([PSCustomObject]@{
            Logical_Disk = $_.Value
            FileSystem = $_.FileSystem
            VolumeName = $_.VolumeName
            AllSize    = [string]$_.AllSize+" Gb"
            FreeSize   = [string]$_.FreeSize+" Gb"
            Free       = $_."Free%"
        })
    }
    $CollectionLD
}

function Get-DiskPartition {
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

function Get-Smart {
    $PhysicalDisk = Get-CimInstance -Namespace root/Microsoft/Windows/Storage -ClassName MSFT_PhysicalDisk
    $DiskSensor = $PhysicalDisk | Get-StorageReliabilityCounter
    $DiskSensor | Select-Object @{Label="DiskName"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty FriendlyName}},
    Temperature,
    @{Label="HealthStatus"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty HealthStatus}},
    @{Label="OperationalStatus"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty OperationalStatus}},
    @{Label="MediaType"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty MediaType}},
    @{Label="BusType"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty BusType}},
    PowerOnHours, # Количество часов, в течение которых жесткий диск был во включенном состоянии
    StartStopCycleCount # Количество циклов включения и выключения жесткого диска (каждый цикл выключения и последующего включения считается за один раз)
    # FlushLatencyMax, # Максимальное время задержки (латентность) для операций очистки кэша на диске (сброса кеша на диск).
    # LoadUnloadCycleCount, #  Количество циклов загрузки/выгрузки механизма парковки головок на жёстких дисках с перемещающимися головками (не относится к SSD)
    # ReadErrorsTotal, # Общее количество ошибок чтения данных с диска
    # ReadErrorsCorrected, # Количество ошибок чтения, которые были исправлены системой коррекции ошибок
    # ReadErrorsUncorrected, # Количество ошибок чтения, которые не удалось исправить
    # ReadLatencyMax, # Максимальная задержка (латентность) при чтении данных с диска
    # WriteErrorsTotal,
    # WriteErrorsCorrected,
    # WriteErrorsUncorrected,
    # WriteLatencyMax
}

function Get-IOps {
    Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk | Select-Object Name,
    @{name="ReadWriteTime";expression={"$($_.PercentDiskTime) %"}}, # Процент времени, в течение которого физический диск занят обработкой запросов ввода-вывода
    @{name="ReadTime";expression={"$($_.PercentDiskReadTime) %"}}, # Процент времени, в течение которого физический диск занят чтением данных
    @{name="WriteTime";expression={"$($_.PercentDiskWriteTime) %"}}, # Процент времени, в течение которого физический диск занят записью данных
    @{name="IdleTime";expression={"$($_.PercentIdleTime) %"}}, #  Процент времени, в течение которого физический диск не занят (находится в режиме простоя)
    @{name="QueueLength";expression={$_.CurrentDiskQueueLength}}, # Текущая длина очереди диска (количество запросов, которые ожидают обработки диском)
    @{name="BytesPersec";expression={$($_.DiskBytesPersec/1mb).ToString("0.000 MByte/Sec")}}, # Скорость передачи данных через диск в байтах в секунду (объединенное значение для чтения и записи)
    @{name="ReadBytesPersec";expression={$($_.DiskReadBytesPersec/1mb).ToString("0.000 MByte/Sec")}}, # Скорость чтения данных с диска в байтах в секунду
    @{name="WriteBytesPersec";expression={$($_.DiskWriteBytesPersec/1mb).ToString("0.000 MByte/Sec")}}, # Скорость записи данных на диск в байтах в секунду
    @{name="IOps";expression={$_.DiskTransfersPersec}}, # Общее количество операций ввода-вывода (чтение и запись) с диска в секунду
    @{name="ReadsIOps";expression={$_.DiskReadsPersec}}, # Количество операций чтения с диска в секунду
    @{name="WriteIOps";expression={$_.DiskWritesPersec}} # Количество операций записи на диск в секунду
}

function Get-VideoCard {
    $VideoCard = Get-CimInstance Win32_VideoController | Select-Object @{
    Label="VideoCard"; Expression={$_.Name}}, @{Label="Display"; Expression={
    [string]$_.CurrentHorizontalResolution+"x"+[string]$_.CurrentVerticalResolution}}, 
    @{Label="vRAM"; Expression={($_.AdapterRAM/1Gb)}}
    $CollectionVC = New-Object System.Collections.Generic.List[System.Object]
    $VideoCard | ForEach-Object {
        $CollectionVC.Add([PSCustomObject]@{
            Model    = $_.VideoCard
            Display  = $_.Display
            VideoRAM = [string]$([int]$($_.vRAM))+" Gb"
        })
    }
    $CollectionVC
}

function Get-NetIpConfig {
    Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true |
    Select-Object Description,
    @{Label="IPAddress"; Expression={[string]($_.IPAddress)}},
    @{Label="GatewayDefault"; Expression={[string]($_.DefaultIPGateway)}},
    @{Label="Subnet"; Expression={[string]($_.IPSubnet)}},
    @{Label="DNSServer"; Expression={[string]($_.DNSServerSearchOrder)}},
    MACAddress,
    DHCPEnabled,
    DHCPServer,
    DHCPLeaseObtained,
    DHCPLeaseExpires
}

function Get-NetInterfaceStat {
    param (
        [switch]$Current
    )
    if ($Current) {
        Get-CimInstance -ClassName Win32_PerfFormattedData_Tcpip_NetworkInterface |
        Select-Object Name,
        @{name="Total";expression={$($_.BytesTotalPersec/1mb).ToString("0.000 MByte/Sec")}}, # Сумма полученных и отправленных байт за секунду
        @{name="Received";expression={$($_.BytesReceivedPersec/1mb).ToString("0.000 MByte/Sec")}}, # Количество байт, полученных за секунду
        @{name="Sent";expression={$($_.BytesSentPersec/1mb).ToString("0.000 MByte/Sec")}}, # Количество байт, отправленных за секунду
        PacketsPersec, # Общее количество пакетов в секунду (включает все виды пакетов)
        PacketsReceivedPersec, # Количество пакетов, полученных за секунду
        PacketsReceivedUnicastPersec, # Количество уникальных (unicast) пакетов, полученных за секунду, включает в себя широковещательные (broadcast) и групповые (multicast) пакеты
        PacketsReceivedNonUnicastPersec, # Количество не уникальных (non-unicast) пакетов, полученных за секунду
        PacketsReceivedDiscarded, # Количество отброшенных пакетов при получении
        PacketsReceivedErrors, # Количество пакетов с ошибками при получении
        PacketsSentPersec, # Количество пакетов, отправленных за секунду
        PacketsSentUnicastPersec, # Количество уникальных (unicast) пакетов, отправленных за секунду
        PacketsSentNonUnicastPersec # Количество не уникальных (non-unicast) пакетов, отправленных за секунду
    }
    else {
        Get-CimInstance -ClassName Win32_PerfRawData_Tcpip_NetworkInterface |
        Select-Object Name,
        @{name="Total";expression={$($_.BytesTotalPersec/1gb).ToString("0.00 GByte")}},
        @{name="Received";expression={$($_.BytesReceivedPersec/1gb).ToString("0.00 GByte")}},
        @{name="Sent";expression={$($_.BytesSentPersec/1gb).ToString("0.00 GByte")}}, 
        PacketsPersec,
        PacketsReceivedPersec,
        PacketsReceivedUnicastPersec,
        PacketsReceivedNonUnicastPersec,
        PacketsReceivedDiscarded,
        PacketsReceivedErrors,
        PacketsSentPersec,
        PacketsSentUnicastPersec,
        PacketsSentNonUnicastPersec
    }
}

# Get-NetInterfaceStat -Current
# Get-NetInterfaceStat

function Get-NetStat {
    Get-NetTCPConnection -State Established,Listen | Sort-Object -Descending State |
    Select-Object @{name="ProcessName";expression={(Get-Process -Id $_.OwningProcess).ProcessName}},
    LocalAddress,
    LocalPort,
    RemotePort,
    @{name="RemoteHostName";expression={((nslookup $_.RemoteAddress)[3]) -replace ".+:\s+"}},
    RemoteAddress,
    State,
    CreationTime,
    @{Name="RunTime"; Expression={((Get-Date) - $_.CreationTime) -replace "\.\d+$"}},
    @{name="ProcessPath";expression={(Get-Process -Id $_.OwningProcess).Path}}
}
#endregion

#region software-functions
# Source: https://github.com/Lifailon/PowerShellHardwareMonitor
function Get-Sensor {
    param (
        [switch]$Libre,
        [switch]$Library,
        $Server,
        [int]$Port = 8085,
        $Path
    )
    if ($Libre) {
        if ($null -eq $path) {
            $path = "$home\Documents\LibreHardwareMonitor"
        }
    }
    else {
        if ($null -eq $path) {
            $path = "$home\Documents\OpenHardwareMonitor\OpenHardwareMonitor"
        }
    }
    ### OpenHardwareMonitor and LibreHardwareMonitor REST API
    if ($null -ne $Server) {
        $Data = Invoke-RestMethod "http://$($Server):$($Port)/data.json"
        $Collections = New-Object System.Collections.Generic.List[System.Object]
        foreach ($Hardware in $($Data.Children.Children)) {
            $HardwareName = $Hardware.Text
            foreach ($Sensor in $($Hardware.Children)) {
                $SensorName = $Sensor.Text
                foreach ($SensorChildren in $($Sensor.Children)) {
                    $Collections.Add([PSCustomObject]@{
                        HardwareName = $HardwareName
                        SensorName = $SensorName
                        SensorType = $SensorChildren.Text
                        Value = $SensorChildren.Value
                        Min = $SensorChildren.Min
                        Max = $SensorChildren.Max
                    })
                }
            }
        }
        $Collections
    }
    ### LibreHardwareMonitor via .NET Library
    elseif (($Libre -eq $True) -and ($Library -eq $True)) {
        Add-Type -Path "$path\LibreHardwareMonitorLib.dll"
        $Computer = New-Object -TypeName LibreHardwareMonitor.Hardware.Computer
        $Computer.IsCpuEnabled         = $true
        $Computer.IsGpuEnabled         = $true
        $Computer.IsMemoryEnabled      = $true
        $Computer.IsMotherboardEnabled = $true
        $Computer.IsNetworkEnabled     = $true
        $Computer.IsPsuEnabled         = $true
        $Computer.IsStorageEnabled     = $true
        $Computer.IsControllerEnabled  = $true
        $Computer.IsBatteryEnabled     = $true
        $Computer.Open()
        $Sensors  = $computer.Hardware.Sensors | Select-Object @{
            name = "HardwareName"
            expression = {
                $_.Hardware.Sensors[0].Hardware.Name
            }
        },
        @{name = "SensorName";expression = { $_.Name }},
        @{name = "SensorType";expression = { "$($_.SensorType) $($_.Index)" }},
        @{name = "Value";expression = { [int]$_.Value }},
        @{name = "Min";expression = { [int]$_.Min }},
        @{name = "Max";expression = { [int]$_.Max }}
        $Sensors | Sort-Object HardwareName,SensorType,SensorName
    }
    ### OpenHardwareMonitor and LibreHardwareMonitor via CIM
    else {
        if ($Libre -eq $True) {
            $ProcessName = "LibreHardwareMonitor"
            $NameSpace   = "root/LibreHardwareMonitor"
        }
        else {
            $ProcessName = "OpenHardwareMonitor"
            $NameSpace   = "root/OpenHardwareMonitor"
        }
        $Process_Used = Get-Process $ProcessName -ErrorAction Ignore
        if ($null -eq $Process_Used) {
            Start-Process "$path\$($ProcessName).exe" -WindowStyle Hidden # -NoNewWindow
        }
        $Hardware = Get-CimInstance -Namespace $NameSpace -ClassName Hardware | Select-Object Name,
        HardwareType,
        @{name = "Identifier";expression = {$_.Identifier -replace "\\|\?"}} # <<< Libre has a different parent ID compared to OpenHardwareMonitor
        $Sensors = Get-CimInstance -Namespace $NameSpace -ClassName Sensor 
        $Sensors = $Sensors | Select-Object @{
            name = "HardwareName"
            expression = {
                $Parent = $_.Parent -replace "\\|\?"
                $Hardware | Where-Object Identifier -match $Parent | Select-Object -ExpandProperty Name
            }
        },
        @{name = "SensorName";expression = { $_.Name }},
        @{name = "SensorType";expression = { "$($_.SensorType) $($_.Index)" }},
        @{name = "Value";expression = { [int]$_.Value }},
        @{name = "Min";expression = { [int]$_.Min }},
        @{name = "Max";expression = { [int]$_.Max }}
        $Sensors | Sort-Object HardwareName,SensorType,SensorName
    }
}
#endregion

#region JavaScript-functions
function Get-FilterTable {
    param (
        $columnIndex
    )
    "
    function filterTable() {
        var input, filter, table, tr, td, i, txtValue;
        input = document.getElementById('messageText');
        filter = input.value.toUpperCase();
        table = document.getElementById('eventTable');
        tr = table.getElementsByTagName('tr');
        for (i = 0; i < tr.length; i++) {
            td = tr[i].getElementsByTagName('td')[$columnIndex]; // Filtering by 3 column (Message)
            if (td) {
                txtValue = td.textContent || td.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = '';
                } else {
                    tr[i].style.display = 'none';
                }
            }
        }
    }
    "
}

function Get-FormInput {
    param (
        $placeholder
    )
    "
    <form>
        <input
            type='text'
            name='messageText'
            id='messageText'
            onkeyup='filterTable()'
            placeholder='$placeholder'
            style='
                width: 300px;
                font-size: 14px;
                border: 2px solid #efefef;
                border-radius: 10px;
                padding: 6px;
            '
        >
    </form>
    "
}
#endregion

#region function start-socket
function Start-Socket {
    Add-Type -AssemblyName System.Net.Http
    $http = New-Object System.Net.HttpListener
    $http.Prefixes.Add("http://+:$port/")
    ### Use Basic Authentication
    $http.AuthenticationSchemes = [System.Net.AuthenticationSchemes]::Basic
    ### Start socket
    $http.Start()
    try {
        while ($http.IsListening) {
            $contextTask = $http.GetContextAsync()
            while (-not $contextTask.AsyncWaitHandle.WaitOne(200)) { }
            $context = $contextTask.GetAwaiter().GetResult()
            ### Authorization
            $CredRequest = $context.Request.Headers["Authorization"]
            ### Debug (read decoded credentials)
            # Write-Host $CredRequest
            $CredRequest = $CredRequest -replace "Basic\s"
            if ( $CredRequest -ne $cred ) {
                $Data = "Unauthorized (login or password is invalid)"
                ### Response on not authorization (code 401)
                Send-Response -Data $Data -Code 401
            }
            else {
                ### GET /
                if ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/") {
                    $data = @("
                        Version = 4.3
                        Source = https://github.com/Lifailon/WinAPI
                    ") | ConvertFrom-StringData
                    Send-Response -Data $Data -Code 200 -Body -fl
                }
                ### GET /events/list
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/events/list") {
                    $Events = Get-Event -List | Sort-Object {[DateTime]::ParseExact($_.LastWriteTime, 'dd.MM.yyyy HH:mm:ss', $null)} -Descending
                    $GetEvent = "<html><head>"
                    $GetEvent += "<script>"
                    ### Function for filtering the content of messages by 6 (5) column
                    $GetEvent += Get-FilterTable 5
                    $GetEvent += "</script>"
                    ### Add Head (ico and title)
                    $GetEvent += $icoHead
                    $GetEvent += "</head><body>"
                    ### Add menu button to page
                    $GetEvent += $BodyButtons
                    ### Add form for input filtering text 
                    $GetEvent += Get-FormInput "Enter text to filter name provider events"
                    ### Create table and columns
                    $GetEvent += "<table id='eventTable' border='1'>"
                    $GetEvent += "<tr>"
                    $GetEvent += "<th>Records</th>"
                    $GetEvent += "<th>Last Write</th>"
                    $GetEvent += "<th>File Size</th>"
                    $GetEvent += "<th>Isolation</th>"
                    $GetEvent += "<th>Type</th>"
                    $GetEvent += "<th>Name</th>"
                    $GetEvent += "</tr>"
                    foreach ($Event in $Events) {
                        $GetEvent += "<tr>"
                        $GetEvent += "<td>$($Event.RecordCount)</td>"
                        $GetEvent += "<td>$($Event.LastWriteTime)</td>"
                        $GetEvent += "<td>$($Event.FileSize)</td>"
                        $GetEvent += "<td>$($Event.LogIsolation)</td>"
                        $GetEvent += "<td>$($Event.LogType)</td>"
                        $LogName  = $Event.LogName -replace "/","&" -replace "\s","+"
                        $GetEvent += "<td><button onclick='location.href=""/events/$($LogName)""'>$($Event.LogName)</button></td>"
                        $GetEvent += "</tr>"
                    }
                    $GetEvent += "</table>"
                    $GetEvent += "</body></html>"
                    Send-Response -Data $GetEvent -Code 200 -v2
                }
                ### GET /events/LogName
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -ne "/events/list" -and $context.Request.RawUrl -match "/events/.") {
                    $LogName = ($context.Request.RawUrl) -replace ".+/"
                    $LogName = $LogName -replace "&","/" -replace "\+"," "
                    $Events = Get-Event -LogName $LogName
                    ### If the array is greater than 6000 elements, send the standard table
                    if ($Events.Count -gt 6000) {
                        Send-Response -Data $Events -Code 200 -Body
                    }
                    else {
                        $GetEvent = "<html><head>"
                        $GetEvent += "<script>"
                        ### Function for filtering the content of messages
                        $GetEvent += Get-FilterTable 2
                        $GetEvent += "</script>"
                        ### Add Head (ico and title)
                        $GetEvent += $icoHead
                        $GetEvent += "</head><body>"
                        ### Add menu button to page
                        $GetEvent += $BodyButtons
                        ### Add form for input filtering text 
                        $GetEvent += Get-FormInput "Enter text to filter messages"
                        ### Create table and columns
                        $GetEvent += "<table id='eventTable' border='1'>"
                        $GetEvent += "<tr>"
                        $GetEvent += "<th>Time</th>"
                        $GetEvent += "<th>Level</th>"
                        $GetEvent += "<th>Message</th>"
                        $GetEvent += "</tr>"
                        ### Filling out the table
                        foreach ($Event in $Events) {
                            $Level = $Event.Level
                            if ($Level -eq 2) {
                                $level_color = "<font color='#FF6666'><b>$($Event.LevelDisplayName)</b></font>"
                            }
                            elseif ($Level -eq 3) {
                                $level_color = "<font color='#FFFF99'><b>$($Event.LevelDisplayName)</b></font>"
                            }
                            elseif (($Level -eq 4) -or ($Level -eq 0)) {
                                $level_color = "<font color='#99FF99'><b>$($Event.LevelDisplayName)</b></font>"
                            }
                            else {
                                $level_color = "$($Event.LevelDisplayName)"
                            }
                            $GetEvent += "<tr>"
                            $GetEvent += "<td>$($Event.TimeCreated)</td>"
                            $GetEvent += "<td>$level_color</td>"
                            $GetEvent += "<td>$($Event.Message)</td>"
                            $GetEvent += "</tr>"
                        }
                        $GetEvent += "</table>"
                        $GetEvent += "</body></html>"
                        # When filling HTML document manually, you should use Windows-1251 encoding
                        Send-Response -Data $GetEvent -Code 200 -v2 -EncodingWin1251
                    }
                }
                ### GET /service
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/service") {
                    $Services = Get-ServiceDescription *
                    $GetService = "<html><head>"
                    $GetService += "<script>"
                    $GetService += Get-FilterTable 0
                    $GetService += "</script>"
                    $GetService += $icoHead
                    $GetService += "</head><body>"
                    $GetService += $BodyButtons
                    $GetService += Get-FormInput "Enter service name to filter"
                    $GetService += "<table id='eventTable' border='1'>"
                    $GetService += "<tr><th>Name</th><th>Status</th><th>Action</th><th>Start Type</th></tr>"
                    foreach ($Service in $Services) {
                        $name   = "<b>$($Service.Name)</b>"
                        $status = $Service.Status
                        if ($status -eq "Running") {
                            $status = "<font color='#99FF99'><b>$status</b></font>"
                        } else {
                            $status = "<font color='#FF6666'><b>$status</b></font>"
                        }
                        $StartType  = $Service.StartType
                        $GetService += "<tr><td>$name</td><td>$status</td>"
                        $GetService += "<td><button onclick='startService(""$($Service.Name)"")'>Start</button> "
                        $GetService += "<button onclick='stopService(""$($Service.Name)"")'>Stop</button></td>"
                        $GetService += "<td>$StartType</td></tr>"
                    }
                    $GetService += "</table>"
                    $GetService += '
                    <script>
                        function startService(serviceName) {
                            sendServiceAction("Start", serviceName);
                        }
                        function stopService(serviceName) {
                            sendServiceAction("Stop", serviceName);
                        }
                        function sendServiceAction(action, serviceName) {
                            var request = new XMLHttpRequest();
                            request.open("POST", "/api/service/" + serviceName, true);
                            request.setRequestHeader("Status", action);
                            request.onreadystatechange = function () {
                                if (request.readyState === 4 && request.status === 200) {
                                    console.log("True");
                                    location.reload();
                                }
                            };
                            request.send();
                        }
                    </script>
                    </body></html>
                    '
                    Send-Response -Data $GetService -Code 200 -v2
                }
                ### GET /api/service
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/service") {
                    $GetService = Get-ServiceDescription *
                    Send-Response -Data $GetService -Code 200
                }
                ### GET /api/service/*ServiceName* (windcard format)
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -match "/api/service/.") {
                    $ServiceName = ($context.Request.RawUrl) -replace ".+/"
                    ### 0.3.2: To transfer a service containing spaces
                    $ServiceName = $ServiceName -replace "_"," "
                    $GetService = Get-ServiceDescription *$ServiceName*
                    ### Response on not fount service (code 400)
                    if ($null -eq $GetService) {
                        $Code = 400
                        $GetService = "Bad Request. Service $ServiceName could not be found."
                    }
                    else {
                        $Code = 200                    
                    }
                    Send-Response -Data $GetService -Code $Code
                }
                ### POST /api/service/ServiceName (not windcard format)
                elseif ($context.Request.HttpMethod -eq "POST" -and $context.Request.RawUrl -match "/api/service/.") {
                    ### Get Service Name from endpoint
                    $ServiceName = ($context.Request.RawUrl) -replace ".+/"
                    ### 0.3.2: To transfer a service containing spaces
                    $ServiceName = $ServiceName -replace "_"," "
                    ### Get Status from Headers Request (stop/start/restart)
                    $Status = $context.Request.Headers["Status"]
                    ### Check Service
                    $GetService = Get-Service -ErrorAction Ignore $ServiceName
                    if ($null -eq $GetService) {
                        $Code = 400
                        $GetService = "Bad Request. Service $ServiceName could not be found."
                    }
                    else {
                        $Code = 200
                        if ($status -eq "stop") {
                            $GetService | Stop-Service
                        }
                        elseif ($status -eq "start") {
                            $GetService | Start-Service
                        }
                        elseif ($status -eq "restart") {
                            $GetService | Restart-Service
                        }
                        else {
                            $Code = 400
                            $GetService = "Bad Request. Invalid status in the header. Available: stop, start, restart."
                        }
                    }
                    if ($code -eq 200) {
                        $GetService = Get-ServiceDescription $ServiceName
                    }
                    Send-Response -Data $GetService -Code $Code
                }
                ### GET /process
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/process") {
                    $Process = Get-ProcessDescription
                    $GetProcess = "<html><head>"
                    $GetProcess += "<script>"
                    $GetProcess += Get-FilterTable 0
                    $GetProcess += "</script>"
                    $GetProcess += $icoHead
                    $GetProcess += "</head><body>"
                    $GetProcess += $BodyButtons
                    $GetProcess += "
                        <form action='/api/process/' method='post' onsubmit='return startProcess(this);'>
                            <input
                                type='text'
                                name='messageText'
                                id='messageText'
                                onkeyup='filterTable()'
                                placeholder='Enter name process'
                                style='
                                    width: 300px;
                                    font-size: 14px;
                                    border: 2px solid #efefef;
                                    border-radius: 10px;
                                    padding: 6px;
                                '
                            >
                            <input 
                                type='submit'
                                value='Start'
                                style='
                                    margin-bottom: 6px;
                                    display: inline-block;
                                    background: #2196f3;
                                    color: #fff;
                                    font-size: 18px;
                                    font-family: Tahoma;
                                    border: none;
                                    border-radius: 10px;
                                    padding: 6px;
                                    line-height: 1;
                                    cursor: pointer;
                                '
                            >
                        </form>
                        "
                    $GetProcess += "<table id='eventTable' border='1'>"
                    $GetProcess += "<tr>"
                    $GetProcess += "<th>Name</th><th>Action</th><th>Total Process Time</th>"
                    $GetProcess += "<th>User Process Time</th><th>Privileged Process Time</th>"
                    $GetProcess += "<th>Working Set</th><th>Peak Working Set</th><th>Page Memory</th>"
                    $GetProcess += "<th>Virtual Memory</th><th>Running Time</th>"
                    $GetProcess += "<th>Threads</th><th>Handles</th>"
                    $GetProcess += "</tr>"
                    foreach ($Proces in $Process) {
                        $name               = "<b>$($Proces.ProcessName)</b>"
                        $TotalProcTime      = "<b>$($Proces.TotalProcTime)</b>"
                        $UserProcTime       = "<b>$($Proces.UserProcTime)</b>"
                        $PrivilegedProcTime = "<b>$($Proces.PrivilegedProcTime)</b>"
                        $WorkingSet         = "<b>$($Proces.WorkingSet)</b>"
                        $PeakWorkingSet     = "<b>$($Proces.PeakWorkingSet)</b>"
                        $PageMemory         = "<b>$($Proces.PageMemory)</b>"
                        $VirtualMemory      = "<b>$($Proces.VirtualMemory)</b>"
                        $RunTime            = "<b>$($Proces.RunTime)</b>"
                        $Threads            = "<b>$($Proces.Threads)</b>"
                        $Handles            = "<b>$($Proces.Handles)</b>"
                        $GetProcess         += "<tr>"
                        $GetProcess         += "<td>$name</td>"
                        $GetProcess         += "<td><button onclick='stopProcess(""$($Proces.ProcessName)"")'>Stop</button></td>"
                        $GetProcess         += "<td>$TotalProcTime</td><td>$UserProcTime</td><td>$PrivilegedProcTime</td>"
                        $GetProcess         += "<td>$WorkingSet</td><td>$PeakWorkingSet</td><td>$PageMemory</td>"
                        $GetProcess         += "<td>$VirtualMemory</td><td>$RunTime</td><td>$Threads</td><td>$Handles</td>"
                        $GetProcess         += "</tr>"
                    }
                    $GetProcess += "</table>"
                    $GetProcess += '
                    <script>
                        function startProcess(form) {
                            // Get variable from form by id
                            var processName = form.messageText.value;
                            sendProcessAction("Start", processName);
                        }
                        function stopProcess(processName) {
                            sendProcessAction("Stop", processName);
                        }
                        function sendProcessAction(action, processName) {
                            var request = new XMLHttpRequest();
                            request.open("POST", "/api/process/" + processName, true);
                            request.setRequestHeader("Status", action);
                            request.onreadystatechange = function () {
                                if (request.readyState === 4 && request.status === 200) {
                                    console.log("True");
                                    window.location.replace("/process");
                                }
                            };
                            request.send();
                        }
                    </script>
                    </body></html>
                    '
                    Send-Response -Data $GetProcess -Code 200 -v2
                }
                ### GET /api/process
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/process") {
                    $GetProcess = Get-ProcessDescription
                    Send-Response -Data $GetProcess -Code 200
                }
                ### GET /api/process/*ProcessName* (windcard format)
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -match "/api/process/.") {
                    $ProcessName = ($context.Request.RawUrl) -replace ".+/"
                    ### 0.3.2: To transfer a process containing spaces
                    $ProcessName = $ProcessName -replace "_"," "
                    $GetProcess = Get-ProcessDescription *$ProcessName*
                    ### Response on not fount service (code 400)
                    if ($null -eq $GetProcess) {
                        $Code = 400
                        $GetProcess = "Bad Request. Process $ProcessName could not be found."
                    }
                    else {
                        $Code = 200                    
                    }
                    Send-Response -Data $GetProcess -Code $Code
                }
                ### POST /api/process/ProcessName (not windcard format)
                elseif ($context.Request.HttpMethod -eq "POST" -and $context.Request.RawUrl -match "/api/process/.") {
                    $ProcessName = ($context.Request.RawUrl) -replace ".+/"
                    ### 0.3.2: To transfer a process containing spaces
                    $ProcessName = $ProcessName -replace "_"," "
                    ### Get Status (check/stop/start) and Path from Headers Request
                    $Status      = $context.Request.Headers["Status"]
                    $PathProcess = $context.Request.Headers["Path"]
                    if ($status -eq "check") {
                        $Code = 200
                        $GetProcess = "Number active $ProcessName processes: $((Get-Process -ErrorAction Ignore $ProcessName).Count)"
                    }
                    elseif ($status -eq "start") {
                        if ($null -eq $PathProcess) {
                            ### Find Path Execude for Start Process
                            $PathProcess = Find-Process $ProcessName
                            ### Check Path for Start Process
                            if ($null -eq $PathProcess) {
                                $Code = 400
                                $GetProcess = "Bad Request. Path for start process $ProcessName could not be found. Use header: path."
                            }
                            else {
                                $Code = 200
                                Start-Process "$PathProcess" -WindowStyle Hidden
                                Start-Sleep 1
                                $GetProcess = "Number active $ProcessName processes: $((Get-Process -ErrorAction Ignore $ProcessName).Count)"
                            }
                        }
                        ### Use path from Header for Start Process
                        else {
                            ### Check Path and Extension for Start Process
                            if ($(Test-Path $PathProcess) -and $($PathProcess -match ".exe$")) {
                                $Code = 200
                                Start-Process "$PathProcess" -WindowStyle Hidden
                                Start-Sleep 1
                                $GetProcess = "Number active $ProcessName processes: $((Get-Process -ErrorAction Ignore $ProcessName).Count)"
                            }
                            else {
                                $Code = 400
                                $GetProcess = "Bad Request. Path $PathProcess for start process $ProcessName could not be found."
                            }
                        }
                    }
                    elseif ($status -eq "stop") {
                        ### Check Service
                        $GetProcess = Get-Process -ErrorAction Ignore $ProcessName
                        if ($null -eq $GetProcess) {
                            $Code = 400
                            $GetProcess = "Bad Request. Process $ProcessName could not be found."
                        }
                        else {
                            $Code = 200
                            $GetProcess | Stop-Process
                            Start-Sleep 1
                            $GetProcess = "Number active $ProcessName processes: $((Get-Process -ErrorAction Ignore $ProcessName).Count)"
                        }
                    }
                    else {
                        $Code = 400
                        $GetProcess = "Bad Request. Invalid status in the header. Available: check, stop, start."
                    }
                    Send-Response -Data $GetProcess -Code $Code -v2
                }
                ### GET /api/hardware
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/hardware") {
                    $Data = Get-Hardware
                    Send-Response -Data $Data -Code 200 -Body -fl
                }
                ### GET /api/performance
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/performance") {
                    $Data = Get-Performance
                    Send-Response -Data $Data -Code 200 -Body -fl
                }
                ### GET /api/sensor
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/sensor") {
                    if ($SensorSource -match "Libre") {
                        $Data = Get-Sensor -Libre | Where-Object Value -ne 0
                    }
                    else {
                        $Data = Get-Sensor | Where-Object Value -ne 0
                    }
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/cpu
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/cpu") {
                    $Data = Get-CPU
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/memory
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/memory") {
                    $Data = Get-MemorySize
                    Send-Response -Data $Data -Code 200 -Body -fl
                }
                ### GET /api/memory/slots
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/memory/slots") {
                    $Data = Get-MemorySlots
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/disk/physical
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/disk/physical") {
                    $Data = Get-DiskPhysical
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/disk/logical
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/disk/logical") {
                    $Data = Get-DiskLogical
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/disk/partition
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/disk/partition") {
                    $Data = Get-DiskPartition
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/disk/smart
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/disk/smart") {
                    $Data = Get-Smart
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/disk/iops
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/disk/iops") {
                    $Data = Get-IOps
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/video
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/video") {
                    $Data = Get-VideoCard
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/network/ipconfig
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/network/ipconfig") {
                    $Data = Get-NetIpConfig
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/network/stat
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/network/stat") {
                    $Data = Get-NetStat
                    Send-Response -Data $Data -Code 200 -Body
                }
                ### GET /api/network/interface/stat/total
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/network/interface/stat/total") {
                    $Data = Get-NetInterfaceStat
                    Send-Response -Data $Data -Code 200 -Body -fl
                }
                ### GET /api/network/interface/stat/current
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/network/interface/stat/current") {
                    $Data = Get-NetInterfaceStat -Current
                    Send-Response -Data $Data -Code 200 -Body -fl
                }
                ### GET /api/files
                elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/files") {
                    $PathFiles = $context.Request.Headers["Path"]
                    if ($null -eq $PathFiles) {
                        $Code = 400
                        $Data = "Bad Request. Path header is null."
                    }
                    elseif (!(Test-Path $PathFiles)) {
                        $Code = 400
                        $Data = "Bad Request. Path $Path could not be found."
                    }
                    else {
                        $Code = 200
                        $Data = Get-Files -Path $PathFiles
                    }
                    Send-Response -Data $Data -Code $Code -Body
                }
                ### POST /api/file-delete
                elseif ($context.Request.HttpMethod -eq "POST" -and $context.Request.RawUrl -match "/api/file-delete") {
                    $PathFiles = $context.Request.Headers["Path"]
                    if ($null -eq $PathFiles) {
                        $Code = 400
                        $Data = "Bad Request. Path header is null."
                    }
                    elseif (!(Test-Path $PathFiles)) {
                        $Code = 400
                        $Data = "Bad Request. Path $Path could not be found."
                    }
                    else {
                        $File = Get-Files -Path $PathFiles
                        if ($File.Count -eq 1) {
                            $Type = $File.Type
                            Remove-Item $PathFiles -Force -Recurse
                            if (!(Test-Path $PathFiles)) {
                                $Code = 200
                                $Data = "Deleted successfully: $PathFiles ($Type)."
                            } 
                            else {
                                $Code = 400
                                $Data = "Error. Not deleted: $PathFiles ($Type)."
                            }
                        }
                        else {
                            $Code = 400
                            $Data = "Bad Request. Contains $($File.Count) files in path. Available one file or directory."
                        }
                    }
                    Send-Response -Data $Data -Code $Code -Body -v2
                }
                ### Response to other methods (code 405)
                elseif ($context.Request.HttpMethod -ne "GET") {
                    $Data = "Method not allowed"
                    Send-Response -Data $Data -Code 405
                }
                ### Response to the lack of endpoints (code 404)
                else {
                    $Data = "Not found endpoint"
                    Send-Response -Data $Data -Code 404
                }
            }
        }
    }
    finally {
        $http.Stop()
    }
}
#endregion

#region start-socket
$err = "False"
while ($true) {
    try {
        Write-Host "Running on port $port" -ForegroundColor Green
        if ($Log_File -eq "True" -and $err -eq "False") {
            $date = Get-Date -Format "dd.MM.yyyy hh:mm:ss"
            "$date Start server" | Out-File $Log_Path -Encoding utf8 -Append
        }
        $err = "False"
        Start-Socket
    }
    catch {
        Write-Host "Error and restart server" -ForegroundColor Red
        if ($Log_File -eq "True") {
            $date = Get-Date -Format "dd.MM.yyyy hh:mm:ss"
            "$date Restart server" | Out-File $Log_Path -Encoding utf8 -Append
        }
        $err = "True"
    }
    finally {
        if ($Log_File -eq "True" -and $err -eq "False") {
            $date = Get-Date -Format "dd.MM.yyyy hh:mm:ss"
            "$date Stop server" | Out-File $Log_Path -Encoding utf8 -Append
        }
    }
}
#endregion