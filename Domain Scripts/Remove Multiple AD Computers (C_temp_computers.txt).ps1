#To use this script, gather a list of all computers you would like to remove.
#Put that list of PC's into a text file named "computers.txt" in "C:\temp" and run this script.

Import-Module ActiveDirectory
 
Get-Content C:\temp\computers.txt | % { Get-ADComputer -Filter { Name -eq $_ } } | Remove-ADObject -Force -Recursive