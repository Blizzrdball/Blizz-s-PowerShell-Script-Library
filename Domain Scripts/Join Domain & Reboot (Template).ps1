$domain = "DOMAIN.LOCAL"
$password = "PASSWORD" | ConvertTo-SecureString -asPlainText -Force
$user = "$domain\Administrator"
$credential = New-Object System.Management.Automation.PSCredential ($user,$password)
Add-Computer -DomainName $domain -NewName NEWHOSTNAME -Credential $credential -Restart