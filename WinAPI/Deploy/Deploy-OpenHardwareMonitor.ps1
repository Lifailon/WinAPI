$url = "https://openhardwaremonitor.org/files/openhardwaremonitor-v0.9.6.zip"
$path = "$home\Documents\OpenHardwareMonitor"
$zip = "$($path).zip"
Invoke-RestMethod $url -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $path
Remove-Item -Path $zip