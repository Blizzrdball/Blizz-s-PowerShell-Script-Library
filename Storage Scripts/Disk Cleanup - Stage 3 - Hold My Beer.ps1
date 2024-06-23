function global:Write-Verbose ( [string]$Message ) 
 
# check $VerbosePreference variable, and turns -Verbose on 
{ if ( $VerbosePreference -ne 'SilentlyContinue' ) 
{ Write-Host " $Message" -ForegroundColor 'Yellow' } } 
 
$VerbosePreference = "Continue" 
$DaysToDelete = 1 
$LogDate = get-date -format "MM-d-yy-HH" 
$objShell = New-Object -ComObject Shell.Application  
$objFolder = $objShell.Namespace(0xA) 
$ErrorActionPreference = "silentlycontinue" 
                     
Start-Transcript -Path C:\Windows\Temp\$LogDate.log 
 
## Cleans all code off of the screen. 
Clear-Host 
 
$size = Get-ChildItem C:\Users\* -Recurse -ErrorAction SilentlyContinue |  
Sort Length -Descending |  
Select-Object Name, 
@{Name="Size (GB)";Expression={ "{0:N2}" -f ($_.Length / 1GB) }}, Directory | 
Format-Table -AutoSize | Out-String 
 
$Before = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName, 
@{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } }, 
@{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f( $_.Size / 1gb)}}, 
@{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) } }, 
@{ Name = "PercentFree" ; Expression = {"{0:P1}" -f( $_.FreeSpace / $_.Size ) } } | 
Format-Table -AutoSize | Out-String

## Stopping the windows update service...
Get-Service -Name wuauserv | Stop-Service -Force -Verbose -ErrorAction SilentlyContinue 
## Windows Update Service has been stopped successfully! 

## Clearing IIS Logs...
Get-ChildItem "C:\inetpub\logs\LogFiles\*" -Recurse -Force -ErrorAction SilentlyContinue | remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue 
## IIS Logs have been cleared!

## Clearing C:\temp\...
Get-ChildItem "C:\Temp\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## C:\temp has been cleared!

## Clearing C:\Windows\temp\...
Get-ChildItem "C:\Windows\Temp\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## C:\Windows\temp has been cleared!

## Clearing CBS Logs...
Get-ChildItem "C:\Windows\Logs\CBS\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## CBS Logs have been cleared!

## Clearing SoftwareDistribution folder...
Get-ChildItem "C:\Windows\SoftwareDistribution\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## SoftwareDistribution folder has been cleared!

## Clearing C:\ProgramData\Microsoft\Windows\WER\ReportQueue\...
Get-ChildItem "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## ReportQueue folder has been cleared!

## Clearing temporary user files...
Get-ChildItem "C:\users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | remove-item -force -recurse -ErrorAction SilentlyContinue 
Get-ChildItem "C:\users\*\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## Temporary user files have been cleared!

##Remove Unused Drivers
for /L %%A in (1,1,300) do (
  echo Deleting OEM%%A.INF
  pnputil /d OEM%%A.INF
)
##Unused Drivers Removed!

## Clearing Recycle Bins...
$objFolder.items() | ForEach-Object { Remove-Item $_.path -ErrorAction Ignore -Force -Verbose -Recurse } 
## Recycle Bins have been emptied!

## Starting Windows Update Service...
Get-Service -Name wuauserv | Start-Service -Verbose 
## Windows Update Service has been started!

## Running Windows Disk Cleanup
# cleanmgr.exe /verylowdisk - doesn't run silently
## Windows Disk Cleanup complete!

## Gathering report data...
$After =  Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName, 
@{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } }, 
@{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f( $_.Size / 1gb)}}, 
@{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) } }, 
@{ Name = "PercentFree" ; Expression = {"{0:P1}" -f( $_.FreeSpace / $_.Size ) } } | 
Format-Table -AutoSize | Out-String 

Hostname ; Get-Date | Select-Object DateTime 
Write-Verbose "Before: $Before" 
Write-Verbose "After: $After" 
Write-Verbose $size 
## Here's your beer back. Cleanup completed!