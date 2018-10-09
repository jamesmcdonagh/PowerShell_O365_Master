$Users = Get-AzureADUser | Where {$_.UserType -eq "Member"} 

$E5Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$DynamicsSku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$F1Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$ProjectProSku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$BusinessProSku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

$E5Sku.SkuId = "c7df2760-2c81-4ef7-b578-5b5392b571df"
$DynamicsSku.SkuId = "ea126fc5-a19e-42e2-a731-da9d437bffcf"
$F1Sku.SkuId = "4b585984-651b-448a-9e53-3b10f069cf7f"
$ProjectProSku.SkuId = "53818b1b-4a27-454b-8896-0dba576410e6"
$BusinessProSku.SkuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"

$SalesLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$ManufacturingLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$PMLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$ITLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

$SalesLicenses.AddLicenses = $E5Sku , $DynamicsSku
$ManufacturingLicenses.AddLicenses = $F1Sku
$PMLicenses.AddLicenses = $E5Sku , $ProjectProSku
$ITLicenses.AddLicenses = $E5Sku

$SalesLicenses.RemoveLicenses = $BusinessProSku.SkuId
$ManufacturingLicenses.RemoveLicenses = $BusinessProSku.SkuId
$PMLicenses.RemoveLicenses = $BusinessProSku.SkuId
$ITLicenses.RemoveLicenses = $BusinessProSku.SkuId

Foreach ($user in $users)
{
	if ($user.Department -eq "Sales")
	{
	Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $SalesLicenses
	}
	
	elseif ($user.Department -eq "Project Management")
	{
	Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $PMLicenses
	}
	
	elseif ($user.Department -eq "Manufacturing")
	{
	Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $ManufacturingLicenses
	}
	
	elseif ($user.Department -eq "IT")
	{
	Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $ITLicenses
	}
}

