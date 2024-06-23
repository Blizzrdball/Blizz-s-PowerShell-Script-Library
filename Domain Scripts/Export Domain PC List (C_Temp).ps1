mkdir "C:\Temp" | Out-null
Import-Module ActiveDirectory
Get-ADComputer -Filter * -Property * | Select-Object Name,OperatingSystem,OperatingSystemVersion,ipv4Address,lastlogondate | Export-CSV C:\temp\ADcomputerslist.csv -NoTypeInformation -Encoding UTF8