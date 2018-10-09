$User = Get-AzureADUser -ObjectId john@office365powershell.ca
$Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$Licenses.RemoveLicenses = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value "ENTERPRISEPREMIUM" -EQ).SkuID
Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses
