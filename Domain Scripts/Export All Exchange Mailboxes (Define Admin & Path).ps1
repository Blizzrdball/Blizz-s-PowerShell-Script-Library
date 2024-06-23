##Import Exchange Powershell SnapIn
	Write-Host "Importing Exchange Powershell SnapIn..."
	$loadexchangesnapin = Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010;
	If ($loadexchangesnapin -eq $null) {
		Write-Host "Exchange Powershell SnapIn has been loaded!"
		Write-Host " "
	} else {
		Write-Host "Exchange Powershell SnapIn was not able to load, exiting..."
		exit
	}
	
##Mailbox Variable Definition
	Write-Host "Defining variables..."
	$AllMailboxes = Get-Mailbox;
	$Mailbox = $AllMailboxes.SamAccountName;
	$exportcomplete = Get-MailboxExportRequest -Status InProgress
	$exportcheck = {
	  if ($exportcomplete -eq $null) {
	     Write-Host "Mailbox exports have completed!"
	     Write-Host " "
		 Write-Host "Outputting results list:"
		 Get-MailboxExportRequest
		 Write-Host " "
	     Write-Host "Clearing completed requests from queue..."
	     Get-MailboxExportRequest -Status Completed | Remove-MailboxExportRequest
	     Write-Host "Completed requests have been completed!"
	     Write-Host " "
	     exit
	  } else {
	     Write-Host "Mailbox exports are still in progress! Checking again in 5 minutes..."
	     Start-Sleep -Seconds 300
	     & $exportcheck
	  }
	}
	$setpermissions = New-ManagementRoleAssignment -Role "Mailbox Import Export" -User "ncdfadmin"
	Write-Host "Variables have been set!"
	Write-Host " "

##Set Import/Export Permissions
	Write-Host = "Setting Exchange Import/Export permissions..."
	If (-not $setpermissions) {
		Write-Host "Unable to set proper permissions, check logs and resolve issues..."
		exit
	} else {
		Write-Host "Export permissions have been set!"
		Write-Host " "
	}

##Set Mailbox Export For All Entries
	Write-Host = "Setting Mailbox Export Requests..."
	foreach ($Mailbox in $AllMailboxes) { New-MailboxExportRequest -name "export $Mailbox" -Mailbox $Mailbox -FilePath "D:\ExchangeBackups\Archive Test\$($Mailbox).pst"}
	Write-Host = "Mailbox Export Requests have been set and are running!"
	Start-Sleep -Seconds 10
	& $exportcheck