mkdir "C:\Temp" | Out-null
Import-Module ActiveDirectory
Get-ADUser -Filter * -Property * | Select-Object Enabled,Name,SamAccountName,lastlogondate | Export-CSV C:\temp\ADuserlist.csv -NoTypeInformation -Encoding UTF8