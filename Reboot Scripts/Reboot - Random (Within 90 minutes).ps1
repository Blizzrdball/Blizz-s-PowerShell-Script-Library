$time = Get-Random -Maximum 5400
shutdown -f -r -t $time
Write-Host "This machine will reboot at"(get-date).AddSeconds($time)