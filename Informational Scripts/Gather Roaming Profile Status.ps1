Write-Host "Undefined - 0 - The status of the profile is not set.
Temporary - 1 - The profile is a temporary profile and will be deleted after the user logs off.
Roaming - 2 - The profile is set to roaming. If this bit is not set, the profile is set to local.
Mandatory - 4 - The profile is a mandatory profile.
Corrupted - 8 - The profile is corrupted and is not in use. The user or administrator must fix the corruption to use the profile"
Write-Host "------------------------------------"
gwmi win32_userprofile | select localpath,roamingpath,status