# CIM
# $Service = Get-CimInstance win32_service -Filter 'name="WinAPI"'
# $Service.Delete()

# NSSM
# $path    = "$home\Documents\WinAPI"
# $nssm_exe_path = (Get-ChildItem $path -Recurse | Where-Object name -match nssm.exe | Where-Object FullName -Match win64).FullName
# & $nssm_exe_path remove WinAPI

# Only PowerShell Core
Remove-Service -Name "WinAPI"