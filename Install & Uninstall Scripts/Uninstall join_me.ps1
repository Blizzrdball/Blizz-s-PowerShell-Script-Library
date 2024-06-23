$UID = Get-WmiObject -Class win32_product -Filter "Name like '%join%'"
$UID.Uninstall()