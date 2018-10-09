$User = Get-AzureADUser -ObjectId john@office365powershell.ca
Set-AzureADUser -ObjectId $User.ObjectId -UsageLocation CA
$Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$Sku.SkuId = "c7df2760-2c81-4ef7-b578-5b5392b571df"
#Get-AzureADSubscribedSku -ObjectId 545c04df-2411-4d58-9378-7ec79e9e6b8e_c7df2760-2c81-4ef7-b578-5b5392b571df | Select-Object -ExpandProperty ServicePlans
$Sku.DisabledPlans = @("7547a3fe-08ee-4ccb-b430-5077c5041653","e212cbc7-0961-4c40-9825-01117710dcb1")
$Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$Licenses.AddLicenses = $Sku
Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses
 