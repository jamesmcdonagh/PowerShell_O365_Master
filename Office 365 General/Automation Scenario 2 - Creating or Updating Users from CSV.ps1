$InputFile = Import-CSV Users.csv 

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "Apress2017"
$PasswordProfile.ForceChangePasswordNextLogin = $true

$Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$Sku.SkuId = "c7df2760-2c81-4ef7-b578-5b5392b571df"
$Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$Licenses.AddLicenses = $Sku
	
foreach ($User in $InputFile)
{
$EMail = $User.Email
$FirstName = $User.FirstName
$LastName = $User.LastName
$Title = $User.Title
$Department = $User.Department
$Manager = Get-AzureADUser -ObjectId $User.Manager
$OfficePhone = $User.OfficePhone
$CellPhone = $User.MobilePhone
$City = $User.City
$State = $User.State
$Zip = $User.ZIP
$Country = $User.CountryCode

	if ($user.Action -eq "NEW")
	{
	$NewUser = New-AzureADUser -GivenName $FirstName -Surname $LastName -DisplayName "$FirstName $LastName" -UserPrincipalName $EMail -MailNickName "FirstName.$LastName" -AccountEnabled $true -PasswordProfile $PasswordProfile -JobTitle $Title -Department $Department -UsageLocation $Country -PostalCode $ZIP -Mobile $CellPhone -TelephoneNumber $OfficePhone -State $State -City $City
	Set-AzureADUserManager -ObjectId $EMail -RefObjectId $Manager.ObjectId
	Set-AzureADUserLicense -ObjectId $NewUser.ObjectId -AssignedLicenses $Licenses

	}
	elseif ($user.Action -eq "UPDATE")
	{
	if ($FirstName)
		{
		Set-AzureADUser -ObjectId $EMail -GivenName $FirstName
		}
	if ($LastName)
		{
		Set-AzureADUser -ObjectId $EMail -Surname $LastName
		}
	if ($Title)
		{
		Set-AzureADUser -ObjectId $EMail -JobTitle $Title
		}
	if ($Department)
		{
		Set-AzureADUser -ObjectId $EMail -Department $Department
		}
	if ($Manager)
		{
		Set-AzureADUserManager -ObjectId $EMail -RefObjectId $Manager.ObjectId
		}
	if ($OfficePhone)
		{
		Set-AzureADUser -ObjectId $EMail -TelephoneNumber $OfficePhone
		}
	if ($CellPhone)
		{
		Set-AzureADUser -ObjectId $EMail -Mobile $CellPhone
		}
	if ($City)
		{
		Set-AzureADUser -ObjectId $EMail -City $City
		}
	if ($State)
		{
		Set-AzureADUser -ObjectId $EMail -State $State
		}
	if ($Zip)
		{
		Set-AzureADUser -ObjectId $EMail -PostalCode $Zip
		}
	if ($Country)
		{
		Set-AzureADUser -ObjectId $EMail -Country $Country -UsageLocation $Country
		}
		
	}
	else
	{
	Throw "Action not supported"
	}

}