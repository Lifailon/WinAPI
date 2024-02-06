function Get-VideoCard {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
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
    else {
        $url = "http://$($ComputerName):$($Port)/api/video"
        $EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${User}:${Pass}"))
        $Headers = @{"Authorization" = "Basic ${EncodingCred}"}
        try {
            Invoke-RestMethod -Headers $Headers -Uri $url
        }
        catch {
            Write-Host "Error connection" -ForegroundColor Red
        }
    }
}