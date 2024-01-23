$path = "$home\Documents\WinAPI"
$proc_id = $(Start-Process pwsh -ArgumentList "-File $path\winapi.ps1" -Verb RunAs -WindowStyle Hidden -PassThru).id
$proc_id > "$path\process_id.txt"