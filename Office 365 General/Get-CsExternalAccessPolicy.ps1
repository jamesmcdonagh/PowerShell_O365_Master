Get-CsExternalAccessPolicy | Select Identity, EnableFederationAccess, EnableXmppAccess, EnablePublicCloudAccess, EnablePublicCloudAudioVideoAccess, EnableOutsideAccess |  Export-csv .\externalacess.csv -NoTypeInformation

Get-CsExternalAccessPolicy | Where-Object {$_.EnableFederationAccess -eq $True -and $_.EnablePublicCloudAccess -eq $False}