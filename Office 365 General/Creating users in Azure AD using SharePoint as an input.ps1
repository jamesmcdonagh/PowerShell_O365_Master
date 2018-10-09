Import-Module SharePointPnPPowerShellOnline
Import-Module AzureAD

$cred = Import-CliXML C:\Scripts\pass.xml
Connect-PnPOnline -Url https://office365powershell.sharepoint.com -credential $cred
Connect-AzureAD -Credential $cred

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile

$PasswordProfile.Password = "Getin123$"

$PasswordProfile.ForceChangePasswordNextLogin = $true
$Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

$Sku.SkuId = "c7df2760-2c81-4ef7-b578-5b5392b571df"

$Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

$Licenses.AddLicenses = $Sku

$users = Get-PnPListItem -List 'New Users'

foreach ($user in $users|Where {$_.FieldValues.Processed -eq $false})
{
$EmployeeID = $user.FieldValues.Title
$FirstName = $user.FieldValues.First_x0020_Name
$LastName = $user.FieldValues.Last_x0020_Name
$JobTitle = $user.FieldValues.JobTitle
$Dept = $user.FieldValues.Department
$ManagerEmail = $user.FieldValues.Manager.Email
$OfficePhone = $user.FieldValues.OfficePhone
$Cell = $user.FieldValues.MobilePhone
$City = $user.FieldValues.City
$State = $user.FieldValues.State
$Country = $user.FieldValues.Country
$Email = "$FirstName.$LastName@office365powershell.ca"
switch ($Country) 
    { 
        "Canada" {$UsageLocation = "CA"} 
        "United States" {$UsageLocation = "US"} 
        "Mexico" {$UsageLocation = "MX"}  
        "France" {$UsageLocation = "FR"}  
        default {throw "User Location not valid"}
    }

$NewUser = New-AzureADUser -GivenName $FirstName -Surname $LastName -DisplayName "$FirstName $LastName" -UserPrincipalName $EMail -MailNickName "$FirstName.$LastName" -AccountEnabled $true -PasswordProfile $PasswordProfile -JobTitle $JobTitle -Department $Dept -UsageLocation $UsageLocation -Country $Country -Mobile $Cell -TelephoneNumber $OfficePhone -State $State -City $City

$Manager = Get-AzureADUser -ObjectId $ManagerEmail

Set-AzureADUserManager -ObjectId $NewUser.ObjectId -RefObjectId $Manager.ObjectId

Set-AzureADUserLicense -ObjectId $NewUser.ObjectId -AssignedLicenses $Licenses

$RequesterDisplayName = $user.FieldValues.Author.LookupValue

$Requesteremail = $user.FieldValues.Author.email

$body = "Hello $RequesterDisplayName , </br> The account for Employee ID $EmployeeID has been created with the following details: </br> <b>Username:</b> $Email </br> <b>Password:</b> Apress2017 </br> For any questions, don't hesitate to open a Helpdesk Ticket."

$Subject = "Account Created for New Employee $EmployeeID"

Send-MailMessage -To $Requesteremail -from james.mcdonagh@domain.com -Subject $Subject -Body $body -BodyAsHtml -smtpserver smtp.office365.com -usessl -Credential $cred -Port 587 

$updatedItem = Set-PnPListItem -List 'New Users' -Identity $user.id -Values @{"Processed" = $true}
}
