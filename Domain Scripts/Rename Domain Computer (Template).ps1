$domain = "DOMAIN"
$password = "PASSWORD" | ConvertTo-SecureString -asPlainText -Force
$user = "$domain\administrator"
$credential = New-Object System.Management.Automation.PSCredential ($user,$password)
Rename-Computer -newname NEWHOSTNAME -domaincredential $credential -force