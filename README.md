# WinAPI

![GitHub release (with filter)](https://img.shields.io/github/v/release/lifailon/WinAPI?color=<green>)
![GitHub top language](https://img.shields.io/github/languages/top/lifailon/WinAPI)
![GitHub last commit (by committer)](https://img.shields.io/github/last-commit/lifailon/WinAPI)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/lifailon/WinAPI)
![GitHub License](https://img.shields.io/github/license/lifailon/WinAPI?color=<green>)

[Readme test](https://github.com/Lifailon/WinAPI/Test/blob/rsa/README.md)

Simple REST API and Web server **based on .NET HttpListener**. Using WinAPI, you can quickly set up remote communication with Windows OS without the need to configure WinRM or OpenSSH using APIs and get control from any platform and any REST client, including 🐧 Linux. The goal of the project is to demonstrate the capabilities of PowerShell language and implementation of the functionality in **[Kinozal-Bot](https://github.com/Lifailon/Kinozal-Bot)** due to the lack of a suitable ready-made solution on the market. This implementation is cross-platform, you can try other work for cross-platform managing systemd services in Linux, example **[dotNET-Systemd-API](https://github.com/Lifailon/dotNET-Systemd-API)**.

### 📚 Implemented endpoints:

All GET requests can be output in one of the following formats: **JSON (default), HTML, XML, CSV**. When using a browser for GET requests, by default the response is processed in table format using HTML markup.

- **GET**

`/api/service` - Get list **all services** \
`/apt/service/service_name` - Get list service by the specified name passed in URL (using **wildcard** format) \
`/apt/process` - Get a list **all running processes** in an easy-to-read format \
`/apt/process/process_name` - Get list running processes by the specified name passed in URL (using **wildcard** format) \
`/api/hardware` - Output of summary statistics of metrics close to Task Manager from **CIM** \
`/api/performance` - Output metrics from **Counter** \
`/api/cpu` - CPU use to procent \
`/api/memory` - Memory use to GB and procent \
`/api/memory/slots` - Number of memory slots and their frequency \
`/api/disk/physical` - List of all physical disks, their model and siz \
`/api/disk/logical` - List of all logical disks, their model and siz \
`/api/disk/iops` - Input and Output operations per second for all physical disks \
`/api/video` - List of all video adapters, video memory size and resolution \
`/api/network` - List of all network adapters and their settings \
`/api/files` - Get a list of files and directories at the specified path in the **Path header** with the size, number of child files and directories, date of creation, access and modification

- **Web**

Simple HTTP server with the ability to stop and start services and process using buttons (using JavaScript functions). **Only for Web Browser**.

`/service` \
`/process`

- **POST**

`/apt/service/service_name` - Stop, start and restart services by name (only one at a time, not wildcard format), status is transmitted in the request header (**Status: <Stop/Start/Restart>**). Upon execution, the service status is returned in the format of a GET request. \
`/apt/process/process_name` - Check the number of running processes (**Status: Check**), stop a process by name (**Status: Stop**) and start a process (**Status: Start**). To start a process, you can use the function to search for an executable file in the file system by its name, but you can also pass the path to the executable file through the request header (e.g. **Path: C:\Program Files\qBittorrent\qbittorrent.exe**). \
`/api/file-delete` - Deleting the file or directory specified in the header **Path** one at a time

### 🚀 Install

Use in **PowerShell Core**. No dependencies.

When the server first starts up, a default **configuration file (winapi.ini)** is created at the path: `$home/Documents/WinAPI/winapi.ini`. Configure it yourself.

The following variables to configure **port, login and password** for connect to the server:

```PowerShell
port        = 8443
user        = rest
pass        = api
```

If you want output to **log** requests to a console and/or write file, enable and set the path.

```PowerShell
Log_Console = True
Log_File    = True
Log_Path    = C:/Users/lifailon/Documents/WinAPI/winapi.log
```

And open a port on your firewall:

```PowerShell
New-NetFirewallRule -DisplayName "WinAPI" -Profile Any -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8443
```

- 1st option

💡 **Administrator rights are required to run**

To install the server part as a **service (used NSSM)**, download scripts to **automatically [deployument](https://github.com/Lifailon/WinAPI/tree/rsa/WinAPI/Service), start, stop and remove**.

- 2nd option

There are two options for launching using an **[executable file](https://github.com/Lifailon/WinAPI/tree/rsa/WinAPI/Bin)**.

💡 **PowerShell 5.1 acts as the default handler (limitations of the ps2exe module)**, which prevents all endpoints from working correctly

**winapi-console.exe** - process startup in a window with logging output of connections to the server

**winapi-process.exe** - background process startup

To stop the background process, use the command: `Get-Process *winapi* | Stop-Process`

### 🔒 Authorization

Base authorization has been implemented (based on Base64).

Default login and password:
```PowerShell
$user = "rest"
$pass = "api"
```
- Example 1.

```PowerShell
$SecureString = ConvertTo-SecureString $pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($user, $SecureString)
Invoke-RestMethod -Credential $Credential -AllowUnencryptedAuthentication -Uri http://192.168.3.99:8443/api/service
```
- Example 2.

```PowerShell
$EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))
$Headers = @{"Authorization" = "Basic ${EncodingCred}"}
Invoke-RestMethod -Headers $Headers -Uri http://192.168.3.99:8443/api/service
```
- Example 3. cURL client. Receiving data in different formats.

```Bash
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
```

### 📢 Response code

**200. Request completed successfully.**

**400. Bad Request.** Invalid header and service or process could not be found.

**401. Unauthorized.** Login or password is invalid.

**404. Not found endpoint.** Response to the lack of endpoints.

**405. Method not allowed.** Response to other methods.

### 🐧 Examples POST request from Linux client

- Stop and start service **WinRM**:

First find the service to pass its full name to the to url for POST request (example, using part of the name in GET request).

```Bash
user="rest"
pass="api"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service/win | jq -r .[].Name
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/service/winrm -H "Status: Stop"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/service/winrm -H "Status: Start"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service/winrm | jq -r .Status
```

- Stop and start process **qbittorrent**:

First find the process by its name in wilcard format using a GET request. Using **Check** in the **Status** header, we display the number of running processes. To stop the process, use header **Status: Stop**. To run the process, two examples are given using the name to find the executable and the second option, specify the full path to the executable.

```Bash
user="rest"
pass="api"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/process/torrent
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Check"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Stop"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start"
curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start" -H "Path: C:\Program Files\qBittorrent\qbittorrent.exe"
```

- Delete file

First, we look through the parent directories and look for the required file. In the **Path header we pass the FullName** of the desired file (or directory).

```Bash
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash/4 sezon"
curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash/4 sezon/The.Flash.S04E23.1080p.rus.LostFilm.TV.mkv"
curl -s -X POST -u $user:$pass -data '' http://192.168.3.99:8443/api/file-delete -H "Path: D:/Movies/The-Flash/4 sezon/The.Flash.S04E23.1080p.rus.LostFilm.TV.mkv"
```

### 🔌 Windows client

```PowerShell
$user = "rest"
$pass = "api"
$EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}"))
```

- Stop service **WinRM**:

```PowerShell
$Headers = @{"Authorization" = "Basic ${EncodingCred}"}
$Headers += @{"Status" = "Stop"}
Invoke-RestMethod -Headers $Headers -Uri http://192.168.3.99:8443/api/service/winrm
Invoke-RestMethod -Headers $Headers -Method Post -Uri http://192.168.3.99:8443/api/service/winrm
```
- Start service **WinRM**:

```PowerShell
$Headers = @{"Authorization" = "Basic ${EncodingCred}"}
$Headers += @{"Status" = "Start"}
Invoke-RestMethod -Headers $Headers -Method Post -Uri http://192.168.3.99:8443/api/service/winrm
```

- Module **Get-Hardware**

For an example, import the **[Get-Hardware](https://github.com/Lifailon/WinAPI/blob/rsa/WinAPI/Modules/Get-Hardware)** module (or copy it to your modules directory). For local retrieval of information, use the command without parameters, for remote launch via API, use the parameter **-ComputerName**.

```PowerShell
Import-Modules .\Get-Hardware.psm1
Get-Hardware
Get-Hardware -ComputerName 192.168.3.99 -Port 8443 -User rest -Pass api
```

You can add endpoints to the module yourself for fast remote communication via API.

### 🎉 Simple web server

There are buttons for switching between all web pages.

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Example.gif)

- Process management:

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Process.jpg)

- Service management:

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Service.jpg)

- Hardware statistics from CIM (Common Information Model):

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Hardware.jpg)

- Metrics performance, memory, physical and logical disk:

![Image alt](https://github.com/Lifailon/WinAPI/blob/rsa/Screen/Web-Metrics.jpg)

### 📊 GET data examples

```Bash
lifailon@hv-devops-01:~$ user="rest"
lifailon@hv-devops-01:~$ pass="api"
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/service/win
[
  {
    "Name": "WinDefend",
    "DisplayName": "Служба антивирусной программы Microsoft Defender",
    "Status": "Running",
    "StartType": "Automatic"
  },
  {
    "Name": "WinHttpAutoProxySvc",
    "DisplayName": "Служба автоматического обнаружения веб-прокси WinHTTP",
    "Status": "Running",
    "StartType": "Manual"
  },
  {
    "Name": "Winmgmt",
    "DisplayName": "Инструментарий управления Windows",
    "Status": "Running",
    "StartType": "Automatic"
  },
  {
    "Name": "WinRM",
    "DisplayName": "Служба удаленного управления Windows (WS-Management)",
    "Status": "Stopped",
    "StartType": "Manual"
  }
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass -H 'Content-Type: application/json' http://192.168.3.99:8443/api/service/winrm
{
  "Name": "WinRM",
  "DisplayName": "Служба удаленного управления Windows (WS-Management)",
  "Status": "Stopped",
  "StartType": "Manual"
}
lifailon@hv-devops-01:~$ curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/service/winrm -H "Status: Start"
{
  "Name": "winrm",
  "DisplayName": "Служба удаленного управления Windows (WS-Management)",
  "Status": "Running",
  "StartType": "Manual"
}
lifailon@hv-devops-01:~$ curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Check"
Number active qbittorrent processes: 0
lifailon@hv-devops-01:~$ curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Start"
Number active qbittorrent processes: 1
lifailon@hv-devops-01:~$ curl -s -X POST -u $user:$pass --data '' http://192.168.3.99:8443/api/process/qbittorrent -H "Status: Stop"
Number active qbittorrent processes: 0
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/hardware
{
  "Host": "HUAWEI-BOOK",
  "Uptime": "6.08:37",
  "BootDate": "12.12.2023 04:16:35",
  "Owner": "lifailon",
  "OS": "Майкрософт Windows 10 Pro",
  "Motherboard": "HUAWEI MRGF-XX-PCB M1010",
  "Processor": "12th Gen Intel(R) Core(TM) i7-1260P",
  "Core": 12,
  "Thread": 16,
  "CPU": "13 %",
  "ProcessCount": 286,
  "ThreadsCount": 3842,
  "HandlesCount": 131846,
  "MemoryAll": "16 GB",
  "MemoryUse": "10,49 GB",
  "MemoryUseProc": "67 %",
  "WorkingSet": "9,54 GB",
  "PageMemory": "10,49 GB",
  "MemorySlots": 8,
  "PhysicalDiskCount": 1,
  "PhysicalDiskAllSize": "954 Gb",
  "LogicalDiskCount": 3,
  "LogicalDiskAllSize": "1053 Gb",
  "DiskTotalTime": "0 %",
  "VideoCardCount": 3,
  "VideoCardAllSize": "1 Gb",
  "NetworkAdapterEnableCount": 3
}
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/performance
{
  "CPUTotalTime": "2 %",
  "MemoryUse": "46 %",
  "DiskTotalTime": "4 %",
  "AdapterName": "intel[r] wi-fi 6e ax211 160mhz",
  "AdapterSpeed": "0,339 MByte/Sec"
}
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/cpu
{
  "CPU": "13 %"
}
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/memory
{
  "MemoryAll": "15,73 GB",
  "MemoryUse": "10,62 GB",
  "MemoryUseProc": "67 %",
  "WorkingSet": "9,81 GB",
  "PageMemory": "10,44 GB"
}
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/memory/slots
[
  {
    "Tag": "Physical Memory 0",
    "Model": "5200 Mhz  ",
    "Size": "2048 Mb",
    "Device": "Controller0-ChannelA",
    "Bank": "BANK 0"
  },
  {
    "Tag": "Physical Memory 1",
    "Model": "5200 Mhz  ",
    "Size": "2048 Mb",
    "Device": "Controller0-ChannelB",
    "Bank": "BANK 1"
  },
  {
    "Tag": "Physical Memory 2",
    "Model": "5200 Mhz  ",
    "Size": "2048 Mb",
    "Device": "Controller0-ChannelC",
    "Bank": "BANK 2"
  },
  {
    "Tag": "Physical Memory 3",
    "Model": "5200 Mhz  ",
    "Size": "2048 Mb",
    "Device": "Controller0-ChannelD",
    "Bank": "BANK 3"
  },
  {
    "Tag": "Physical Memory 4",
    "Model": "5200 Mhz  ",
    "Size": "2048 Mb",
    "Device": "Controller1-ChannelA",
    "Bank": "BANK 0"
  },
  {
    "Tag": "Physical Memory 5",
    "Model": "5200 Mhz  ",
    "Size": "2048 Mb",
    "Device": "Controller1-ChannelB",
    "Bank": "BANK 1"
  },
  {
    "Tag": "Physical Memory 6",
    "Model": "5200 Mhz  ",
    "Size": "2048 Mb",
    "Device": "Controller1-ChannelC",
    "Bank": "BANK 2"
  },
  {
    "Tag": "Physical Memory 7",
    "Model": "5200 Mhz  ",
    "Size": "2048 Mb",
    "Device": "Controller1-ChannelD",
    "Bank": "BANK 3"
  }
]
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/physical
{
  "Model": "WD PC SN740 SDDPNQD-1T00-1027",
  "Size": "954 Gb",
  "PartitionCount": 4,
  "Interface": "SCSI"
}
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/logical
[
  {
    "Logical_Disk": "C:",
    "FileSystem": "NTFS",
    "VolumeName": "",
    "AllSize": "153 Gb",
    "FreeSize": "66 Gb",
    "Free": "43 %"
  },
  {
    "Logical_Disk": "D:",
    "FileSystem": "NTFS",
    "VolumeName": "",
    "AllSize": "800 Gb",
    "FreeSize": "452 Gb",
    "Free": "57 %"
  },
  {
    "Logical_Disk": "G:",
    "FileSystem": "FAT32",
    "VolumeName": "Google Drive",
    "AllSize": "100 Gb",
    "FreeSize": "49 Gb",
    "Free": "49 %"
  }
]
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/disk/iops
{
  "Name": "0 D: C:",
  "PercentDiskTime": 1,
  "PercentIdleTime": 95,
  "PercentDiskWriteTime": 1,
  "PercentDiskReadTime": 0,
  "CurrentDiskQueueLength": 0,
  "DiskBytesPersec": 1237822,
  "DiskReadBytesPersec": 32151,
  "DiskReadsPersec": 3,
  "DiskTransfersPersec": 149,
  "DiskWriteBytesPersec": 1205670,
  "DiskWritesPersec": 145
}
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/video
[
  {
    "Model": "Intel(R) Iris(R) Xe Graphics",
    "Display": "3120x2080",
    "VideoRAM": "1 Gb"
  },
  {
    "Model": "Virtual Display Device",
    "Display": "3840x2560",
    "VideoRAM": "0 Gb"
  },
  {
    "Model": "Citrix Indirect Display Adapter",
    "Display": "x",
    "VideoRAM": "0 Gb"
  }
]
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies"
[
  {
    "Name": "Adventure-Time",
    "FullName": "D:\\Movies\\Adventure-Time",
    "Type": "Directory",
    "Size": "61.73 GB",
    "Files": 292,
    "Directory": 11,
    "CreationTime": "04.05.2023 10:05:23",
    "LastAccessTime": "19.12.2023 12:12:24",
    "LastWriteTime": "04.05.2023 10:06:22"
  },
  {
    "Name": "Lupin-S03-1080",
    "FullName": "D:\\Movies\\Lupin-S03-1080",
    "Type": "Directory",
    "Size": "13.401 GB",
    "Files": 7,
    "Directory": 0,
    "CreationTime": "25.10.2023 03:51:41",
    "LastAccessTime": "19.12.2023 12:12:24",
    "LastWriteTime": "25.10.2023 03:57:34"
  },
  {
    "Name": "Shaman-King",
    "FullName": "D:\\Movies\\Shaman-King",
    "Type": "Directory",
    "Size": "15.123 GB",
    "Files": 64,
    "Directory": 0,
    "CreationTime": "10.07.2023 10:03:10",
    "LastAccessTime": "19.12.2023 12:12:24",
    "LastWriteTime": "10.07.2023 10:07:01"
  },
  {
    "Name": "The-Cleaner-S02",
    "FullName": "D:\\Movies\\The-Cleaner-S02",
    "Type": "Directory",
    "Size": "7.829 GB",
    "Files": 6,
    "Directory": 0,
    "CreationTime": "25.10.2023 03:47:32",
    "LastAccessTime": "19.12.2023 12:12:24",
    "LastWriteTime": "25.10.2023 03:51:10"
  },
  {
    "Name": "The-Flash",
    "FullName": "D:\\Movies\\The-Flash",
    "Type": "Directory",
    "Size": "76.569 GB",
    "Files": 43,
    "Directory": 2,
    "CreationTime": "30.07.2023 01:13:20",
    "LastAccessTime": "19.12.2023 12:12:24",
    "LastWriteTime": "30.07.2023 03:22:09"
  }
]
lifailon@hv-devops-01:~$ curl -s -X GET -u $user:$pass http://192.168.3.99:8443/api/files -H "Path: D:/Movies/The-Flash"
[
  {
    "Name": "3 sezon",
    "FullName": "D:\\Movies\\The-Flash\\3 sezon",
    "Type": "Directory",
    "Size": "41.01 GB",
    "Files": 23,
    "Directory": 0,
    "CreationTime": "30.07.2023 01:13:20",
    "LastAccessTime": "19.12.2023 12:12:24",
    "LastWriteTime": "30.07.2023 01:14:37"
  },
  {
    "Name": "4 sezon",
    "FullName": "D:\\Movies\\The-Flash\\4 sezon",
    "Type": "Directory",
    "Size": "35.559 GB",
    "Files": 22,
    "Directory": 0,
    "CreationTime": "30.07.2023 01:22:15",
    "LastAccessTime": "19.12.2023 12:12:24",
    "LastWriteTime": "18.12.2023 12:00:37"
  }
]
```
### 📑 Server log

Example of logging different clients (Google chrome, powershell and curl).

```PowerShell
PS C:\Users\lifailon\Documents\Git\WinAPI> . 'C:\Users\lifailon\Documents\Git\WinAPI\WinAPI\WinAPI-0.3.ps1'
Running on port 8443
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/service => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/process => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET / => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /service => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => POST /api/service/WinRM => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /service => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => POST /api/service/WinRM => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /service => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /process => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => POST /api/process/qbittorrent => 200
192.168.3.99:49829 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => POST /api/process/ => 405
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /process => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => POST /api/process/qbittorrent => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /process => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/hardware => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/performance => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/performance => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/cpu => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/cpu => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/cpu => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/cpu => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/cpu => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/memory => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/memory => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/memory => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/memory => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/disk/physical => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/disk/logical => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/disk/iops => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/disk/iops => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/disk/iops => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/disk/iops => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/disk/iops => 200
192.168.3.99:49843 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 => GET /api/video => 200
192.168.3.100:55137 Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; ru-RU) PowerShell/7.3.7 => GET /api/service => 200
192.168.3.100:55147 Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; ru-RU) PowerShell/7.3.7 => POST /api/service/winrm => 200
192.168.3.100:55152 Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; ru-RU) PowerShell/7.3.7 => POST /api/service/winrm => 200
192.168.3.100:55175 Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; ru-RU) PowerShell/7.3.7 => GET /api/service => 200
192.168.3.100:55181 Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; ru-RU) PowerShell/7.3.7 => POST /api/service/winrm => 200
192.168.3.101:44112 curl/7.81.0 => GET /api/service/win => 200
192.168.3.101:44120 curl/7.81.0 => GET /api/service/winrm => 200
192.168.3.101:39642 curl/7.81.0 => POST /api/process/qbittorrent => 200
192.168.3.101:46296 curl/7.81.0 => POST /api/process/qbittorrent => 200
```