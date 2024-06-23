$action = New-ScheduledTaskAction -Execute 'sfc' -Argument '/scannow'
$trigger = New-ScheduledTaskTrigger -DaysInterval 30 -At 10PM
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Monthly SFC Scan" -Description "Runs sfc /scannow every 30 days"