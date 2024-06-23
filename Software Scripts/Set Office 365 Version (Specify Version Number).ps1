#Rollback Office 365 Version

#Setting Directory
Write-Host "Changing directories..."
cd "C:\Program Files\Common Files\Microsoft Shared\ClickToRun"

#Setting Update Channel
Write-Host "Setting update channel to deferred..."
.\OfficeC2RClient.exe /changesetting Channel=Deferred
Write-Host "Update channel has been set to deferred updates!"

#Rolling Back Updates
Write-Host "Rolling back Office 365..."
.\officec2rclient.exe /update user updatetoversion=16.0.11328.20492
Write-Host "Office 365 successfully rolled back to 16.0.11328.20492!"