$User = Get-AzureADUser -ObjectId vanessa@office365powershell.ca
Set-AzureADUser -ObjectId $User.ObjectId -UsageLocation CA

$BusinessProSku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$PowerBiSku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

$BusinessProSku.SkuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"
$PowerBiSku.SkuId = "f8a1db68-be16-40ed-86d5-cb42ce701560"

$Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$Licenses.AddLicenses = $BusinessProSku, $PowerBiSku

Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses 