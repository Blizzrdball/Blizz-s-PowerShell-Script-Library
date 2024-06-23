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
                     
Start-Transcript -Path $env:SystemDrive:\Windows\Temp\$LogDate.log 
 
## Cleans all code off of the screen. 
Clear-Host 
 
$size = Get-ChildItem $env:SystemDrive:\Users\* -Recurse -ErrorAction SilentlyContinue |  
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

## Clearing driver setup folders...
Get-ChildItem "$env:SystemDrive\swtools\*" -Recurse -Force -ErrorAction SilentlyContinue |
remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue 

Get-ChildItem "$env:SystemDrive\drivers\*" -Recurse -Force -ErrorAction SilentlyContinue |
remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue 

Get-ChildItem "$env:SystemDrive\swsetup\*" -Recurse -Force -ErrorAction SilentlyContinue |
remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue 
## Unnecessary drivers have been cleared!

## Clearing C:\temp\...
Get-ChildItem "$env:SystemDrive:\Temp\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## $env:SystemDrive:\temp has been cleared!

## Clearing C\Windows\temp\...
Get-ChildItem "$env:SystemDrive:\Windows\Temp\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## $env:SystemDrive:\Windows\temp has been cleared!

## Clearing temporary user files...
Get-ChildItem "$env:SystemDrive:\users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
Where-Object {($_.CreationTime -le $(Get-Date).AddDays(-$DaysToDelete))} |
remove-item -force -recurse -ErrorAction SilentlyContinue

Get-ChildItem "$env:SystemDrive:\users\*\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue |
remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
## Temporary user files have been cleared!

## Clearing Recycle Bins...
$objFolder.items() | ForEach-Object { Remove-Item $_.path -ErrorAction Ignore -Force -Verbose -Recurse } 
## Recycle Bins have been emptied!

## Starting Windows Update Service...
Get-Service -Name wuauserv | Start-Service -Verbose 
## Windows Update Service has been started!

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