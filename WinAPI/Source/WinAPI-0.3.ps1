### ©2023 Lifailon
### Source: https://github.com/Lifailon/WinAPI
### REST API and simple web server for Kinozal-Bot (https://github.com/Lifailon/Kinozal-Bot)
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
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start" -H "Path: C:\Program Files\qBittorrent\qbittorrent.exe"
# GET Hardware
Get-Hardware -ComputerName 192.168.3.99 -Port 8443 -User rest -Pass api
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/hardware
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/performance
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/cpu
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/memory
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/memory/slots
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/physical
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/logical
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/iops
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/video
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/network
# GET Files
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash/4 sezon"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash/4 sezon/The.Flash.S04E23.1080p.rus.LostFilm.TV.mkv"
# POST File-Delete
curl -s -X POST -u $user:$pass -data '' http://192.168.3.99:8443/api/file-delete -H "Path: D:/Movies/The-Flash/4 sezon/The.Flash.S04E23.1080p.rus.LostFilm.TV.mkv"
#>

###### Creat path and ini file
$winapi_path = "$home\Documents\winapi"
$ini_path    = "$winapi_path\winapi.ini"
if (!(Test-Path $winapi_path)) {
    New-Item -ItemType Directory -Path $winapi_path
}
if (!(Test-Path $ini_path)) {
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Lifailon/WinAPI/rsa/WinAPI/Bin/winapi.ini" -OutFile $ini_path
}

###### Read ini and write variables
$ini         = Get-Content $ini_path | ConvertFrom-StringData
$port        = $ini.port
$user        = $ini.user
$pass        = $ini.pass
$Log_Console = $ini.Log_Console
$Log_File    = $ini.Log_File
$Log_Path    = $ini.Log_Path
$cred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))

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
        [switch]$fl
    )
    ### Data convertion and set response encoding in UTF-8
    if ($v2 -eq $false) {
        if ($Code -eq 200) {
            if (($context.Request.UserAgent -match "Chrome") -or ($context.Request.ContentType -match "html")) {
                if ($Body) {
                    if ($fl) {
                        $Data = $Data | ConvertTo-Html -Body $BodyButtons -As List
                    } else {
                        $Data = $Data | ConvertTo-Html -Body $BodyButtons
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
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($Data)
    #$context.Response.ContentLength64 = $buffer.Length
    Get-Log
    $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
    $context.Response.OutputStream.Flush()
    $context.Response.OutputStream.Close()
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
    $ProcessPath = (Get-ChildItem "C:\Program Files" | Where-Object Name -match $ProcessName).FullName
    if ($null -eq $ProcessPath) {
        $ProcessPath = (Get-ChildItem "C:\Program Files (x86)" | Where-Object Name -match $ProcessName).FullName
    }
    if ($null -eq $ProcessPath) {
        $ProcessPath = (Get-ChildItem "C:\Users\lifailon\AppData\Roaming" | Where-Object Name -match $ProcessName).FullName
    }
    $ProcessNameExec = "$ProcessName"+".exe"
    (Get-ChildItem $ProcessPath -Recurse | Where-Object Name -eq $ProcessNameExec).FullName
}

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

###### Hardware
$BodyButtons  = "<button onclick='location.href=""/service""'>Service</button> "
$BodyButtons += "<button onclick='location.href=""/process""'>Process</button> "
$BodyButtons += "<button onclick='location.href=""/api/hardware""'>Hardware</button> "
$BodyButtons += "<button onclick='location.href=""/api/performance""'>Performance</button> "
$BodyButtons += "<button onclick='location.href=""/api/cpu""'>CPU</button> "
$BodyButtons += "<button onclick='location.href=""/api/memory""'>Memory</button> "
$BodyButtons += "<button onclick='location.href=""/api/disk/physical""'>Physical Disk</button> "
$BodyButtons += "<button onclick='location.href=""/api/disk/logical""'>Logical Disk</button> "
$BodyButtons += "<button onclick='location.href=""/api/disk/iops""'>IOps</button> "
$BodyButtons += "<button onclick='location.href=""/api/video""'>Video</button> "
$BodyButtons += "<button onclick='location.href=""/api/network""'>Network</button><br><br>"
function Get-Hardware {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        $Collection = New-Object System.Collections.Generic.List[System.Object]
        $SYS = Get-CimInstance Win32_ComputerSystem
        $BootTime = Get-CimInstance -ComputerName $srv Win32_OperatingSystem | Select-Object LocalDateTime,LastBootUpTime
        $Uptime = ([string]($BootTime.LocalDateTime - $BootTime.LastBootUpTime) -split ":")[0,1] -join ":"
        $BootDate = Get-Date -Date $BootTime.LastBootUpTime -Format "dd/MM/yyyy hh:mm:ss"
        $OS = Get-CimInstance Win32_OperatingSystem
        $BB = Get-CimInstance Win32_BaseBoard
        $BBv = $BB.Manufacturer+" "+$BB.Product+" "+$BB.Version
        $CPU = Get-CimInstance Win32_Processor | Select-Object Name,
        @{Label="Core"; Expression={$_.NumberOfCores}},
        @{Label="Thread"; Expression={$_.NumberOfLogicalProcessors}}
        $CPU_Use_Proc = [string]((Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -ErrorAction Ignore | 
        Where-Object name -eq "_Total").PercentProcessorTime)+" %"
        $GetProcess = Get-Process
        $Process_Count = $GetProcess.Count
        $Threads_Count = $GetProcess.Threads.Count
        $Handles_Count = ($GetProcess.Handles | Measure-Object -Sum).Sum
        $ws = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
        $pm = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
        $Memory = Get-CimInstance Win32_OperatingSystem
        $MemUse = $Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory
        $MemUserProc = ($MemUse / $Memory.TotalVisibleMemorySize) * 100
        $MEM = Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer,PartNumber,
        ConfiguredClockSpeed,@{Label="Memory"; Expression={[string]($_.Capacity/1Mb)}}
        $MEMs = $MEM.Memory | Measure-Object -Sum
        $PhysicalDisk = Get-CimInstance Win32_DiskDrive | Select-Object Model,
        @{Label="Size"; Expression={[int]($_.Size/1Gb)}}
        $PDs = $PhysicalDisk.Size | Measure-Object -Sum
        $LogicalDisk = Get-CimInstance Win32_logicalDisk | Where-Object {$null -ne $_.Size} | Select-Object @{
        Label="Value"; Expression={$_.DeviceID}}, @{Label="AllSize"; Expression={
        ([int]($_.Size/1Gb))}},@{Label="FreeSize"; Expression={
        ([int]($_.FreeSpace/1Gb))}}, @{Label="Free%"; Expression={
        [string]([int]($_.FreeSpace/$_.Size*100))+" %"}}
        $LDs = $LogicalDisk.AllSize | Measure-Object -Sum
        $IOps = Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk -ErrorAction Ignore | 
        Where-Object { $_.Name -eq "_Total" } | Select-Object Name,PercentDiskTime,PercentIdleTime,
        PercentDiskWriteTime,PercentDiskReadTime,CurrentDiskQueueLength,DiskBytesPersec,DiskReadBytesPersec,
        DiskReadsPersec,DiskTransfersPersec,DiskWriteBytesPersec,DiskWritesPersec
        $VideoCard = Get-CimInstance Win32_VideoController | Select-Object @{
        Label="VideoCard"; Expression={$_.Name}}, @{Label="Display"; Expression={
        [string]$_.CurrentHorizontalResolution+"x"+[string]$_.CurrentVerticalResolution}}, 
        @{Label="vRAM"; Expression={($_.AdapterRAM/1Gb)}}
        $VCs = $VideoCard.vRAM | Measure-Object -Sum
        $NetworkAdapter = Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true
        $NAs = $NetworkAdapter | Measure-Object
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
            DiskTotalTime             = [string]$IOps.PercentDiskTime+" %"
            VideoCardCount            = $VCs.Count
            VideoCardAllSize          = [string]$VCs.Sum+" Gb"
            NetworkAdapterEnableCount = $NAs.Count
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

function Get-CPUse {
    $CPU_Use_Proc = [string]((Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -ErrorAction Ignore | 
    Where-Object name -eq "_Total").PercentProcessorTime)+" %"
    $CollectionCPU = New-Object System.Collections.Generic.List[System.Object]
    $CollectionCPU.Add([PSCustomObject]@{
        CPU = $CPU_Use_Proc
    })
    $CollectionCPU
}

function Get-MemorySize {
    $Memory           = Get-CimInstance Win32_OperatingSystem
    $MemUse           = $Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory
    $MemUserProc      = ($MemUse / $Memory.TotalVisibleMemorySize) * 100
    $GetProcess       = Get-Process
    $ws               = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $pm               = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $CollectionMemory = New-Object System.Collections.Generic.List[System.Object]
    $CollectionMemory.Add([PSCustomObject]@{
        MemoryAll     = ($memory.TotalVisibleMemorySize/1mb).ToString("0.00 GB")
        MemoryUse     = ($MemUse/1mb).ToString("0.00 GB")
        MemoryUseProc = [string]([int]$MemUserProc)+" %"
        WorkingSet    = $ws
        PageMemory    = $pm
    })
    $CollectionMemory
}

function Get-MemorySlots {
    $Memory = Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer,PartNumber,
    ConfiguredClockSpeed,@{Label="Memory"; Expression={[string]($_.Capacity/1Mb)}},
    Tag,DeviceLocator,BankLabel
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

function Get-PD {
    $PhysicalDisk = Get-CimInstance Win32_DiskDrive | Select-Object Model,
    @{Label="Size"; Expression={[int]($_.Size/1Gb)}},Partitions,InterfaceType
    $CollectionPD = New-Object System.Collections.Generic.List[System.Object]
    $PhysicalDisk | ForEach-Object {
        $CollectionPD.Add([PSCustomObject]@{
            Model          = $_.Model
            Size           = [string]$_.Size+" Gb"
            PartitionCount = $_.Partitions
            Interface      = $_.InterfaceType
        })
    }
    $CollectionPD
}

function Get-LD {
    $LogicalDisk = Get-CimInstance Win32_logicalDisk | Where-Object {$null -ne $_.Size} | Select-Object @{
    Label="Value"; Expression={$_.DeviceID}}, @{Label="AllSize"; Expression={
    ([int]($_.Size/1Gb))}},@{Label="FreeSize"; Expression={
    ([int]($_.FreeSpace/1Gb))}}, @{Label="Free%"; Expression={
    [string]([int]($_.FreeSpace/$_.Size*100))+" %"}},FileSystem,VolumeName
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

function Get-IOps {
    Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk -ErrorAction Ignore | 
    Where-Object { $_.Name -ne "_Total" } | Select-Object Name,PercentDiskTime,PercentIdleTime,
    PercentDiskWriteTime,PercentDiskReadTime,CurrentDiskQueueLength,DiskBytesPersec,DiskReadBytesPersec,
    DiskReadsPersec,DiskTransfersPersec,DiskWriteBytesPersec,DiskWritesPersec
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
            VideoRAM = [string]$_.vRAM+" Gb"
        })
    }
    $CollectionVC
}

function Get-NetAdapter {
    Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true | Select-Object Description,
    DHCPEnabled,DHCPLeaseObtained,DHCPLeaseExpires,DHCPServer,
    @{Label="IPAddress"; Expression={[string]($_.IPAddress)}},
    @{Label="DefaultIPGateway"; Expression={[string]($_.DefaultIPGateway)}},
    @{Label="IPSubnet"; Expression={[string]($_.IPSubnet)}},
    MACAddress
}
###### End Hardware

### Creat socket
Add-Type -AssemblyName System.Net.Http
$http = New-Object System.Net.HttpListener
$http.Prefixes.Add("http://+:$port/")
### Use Basic Authentication
$http.AuthenticationSchemes = [System.Net.AuthenticationSchemes]::Basic
### Start socket
$http.Start()
Write-Host "Running on port $port" -ForegroundColor Green
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
                $html = "
                <style>
                    .navButton {
                        display: block;
                        margin-bottom: 10px;
                    }
                </style>
                <html>
                <head>
                    <title>WinAPI</title>
                </head>
                <body>
                    <button class='navButton' onclick='location.href=""/service""'>Service</button>
                    <button class='navButton' onclick='location.href=""/process""'>Process</button>
                    <button class='navButton' onclick='location.href=""/api/hardware""'>Hardware</button>
                    <button class='navButton' onclick='location.href=""/api/performance""'>Performance</button>
                    <button class='navButton' onclick='location.href=""/api/cpu""'>CPU</button>
                    <button class='navButton' onclick='location.href=""/api/memory""'>Memory</button>
                    <button class='navButton' onclick='location.href=""/api/disk/physical""'>Physical Disk</button>
                    <button class='navButton' onclick='location.href=""/api/disk/logical""'>Logical Disk</button>
                    <button class='navButton' onclick='location.href=""/api/disk/iops""'>IOps</button>
                    <button class='navButton' onclick='location.href=""/api/video""'>Video</button>
                    <button class='navButton' onclick='location.href=""/api/network""'>Network</button>
                </body>
                </html>
                "
                Send-Response -Data $html -Code 200 -v2
            }
            ### GET /service
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/service") {
                $Services = Get-ServiceDescription *
                $GetService = "<html><head><title>Service</title></head><body>"
                ### Add button to process page
                $GetService += $BodyButtons
                $GetService += "<table border='1'>"
                $GetService += "<tr><th>Name</th><th>Status</th><th>Action</th><th>Start Type</th></tr>"
                foreach ($Service in $Services) {
                    $name   = "<b>$($Service.Name)</b>"
                    $status = $Service.Status
                    if ($status -eq "Running") {
                        $status = "<font color='green'><b>$status</b></font>"
                    } else {
                        $status = "<font color='red'><b>$status</b></font>"
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
                $GetProcess = "<html><head><title>Process</title></head><body>"
                ### Add button to service page 
                $GetProcess += $BodyButtons
                ### Add form input text
                $GetProcess += "
                <form action='/api/process/' method='post' onsubmit='return startProcess(this);'>
                    <input type='text' name='processName' id='processName'>
                    <input type='submit' value='Start'>
                </form>
                "
                $GetProcess += "<table border='1'>"
                $GetProcess += "<tr>"
                $GetProcess += "<th>Name</th><th>Action</th><th>Total Process Time</th>"
                $GetProcess += "<th>User Process Time</th><th>Privileged Process Time</th>"
                $GetProcess += "<th>Working Set</th><th>Peak Working Set</th><th>Page Memory</th>"
                $GetProcess += "<th>Virtual Memory</th><th>Private Memory</th><th>Running Time</th>"
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
                    $PrivateMemory      = "<b>$($Proces.PrivateMemory)</b>"
                    $RunTime            = "<b>$($Proces.RunTime)</b>"
                    $Threads            = "<b>$($Proces.Threads)</b>"
                    $Handles            = "<b>$($Proces.Handles)</b>"
                    $GetProcess         += "<tr>"
                    $GetProcess         += "<td>$name</td>"
                    $GetProcess         += "<td><button onclick='stopProcess(""$($Proces.ProcessName)"")'>Stop</button></td>"
                    $GetProcess         += "<td>$TotalProcTime</td><td>$UserProcTime</td><td>$PrivilegedProcTime</td>"
                    $GetProcess         += "<td>$WorkingSet</td><td>$PeakWorkingSet</td><td>$PageMemory</td>"
                    $GetProcess         += "<td>$VirtualMemory</td><td>$PrivateMemory</td><td>$RunTime</td>"
                    $GetProcess         += "<td>$Threads</td><td>$Handles</td>"
                    $GetProcess         += "</tr>"
                }
                $GetProcess += "</table>"
                $GetProcess += '
                <script>
                    function startProcess(form) {
                        // Get variable from form by id
                        var processName = form.processName.value;
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
                                location.reload();
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
            ### GET /api/cpu
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/cpu") {
                $Data = Get-CPUse
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
                $Data = Get-PD
                Send-Response -Data $Data -Code 200 -Body
            }
            ### GET /api/disk/logical
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/disk/logical") {
                $Data = Get-LD
                Send-Response -Data $Data -Code 200 -Body
            }
            ### GET /api/disk/iops
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/disk/iops") {
                $Data = Get-IOps
                Send-Response -Data $Data -Code 200 -Body -fl
            }
            ### GET /api/video
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/video") {
                $Data = Get-VideoCard
                Send-Response -Data $Data -Code 200 -Body
            }
            ### GET /api/network
            elseif ($context.Request.HttpMethod -eq "GET" -and $context.Request.RawUrl -eq "/api/network") {
                $Data = Get-NetAdapter
                Send-Response -Data $Data -Code 200 -Body
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