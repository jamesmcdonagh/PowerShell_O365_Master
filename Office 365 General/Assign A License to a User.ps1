$User = Get-AzureADUser -ObjectId jonathan@office365powershell.ca 
Set-AzureADUser -ObjectId $User.ObjectId -UsageLocation CA

$Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

$Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

$Sku.SkuId = "c7df2760-2c81-4ef7-b578-5b5392b571df"
$Licenses.AddLicenses = $Sku

Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses 