Import-Module SharePointPnPPowerShellOnline

$cred = Import-CliXML C:\Scripts\pass.xml

Connect-PnPOnline -Url https://office365powershell.sharepoint.com -Credentials $cred

$Exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $cred -Authentication "Basic" -AllowRedirection 

Import-PSSession $Exchange

$NewDlMembers = Get-PnPListItem -List 'DL Request'

foreach ($Member in $NewDlMembers|Where {$_.FieldValues.Processed -eq $false})
{
$TicketNumber = $Member.FieldValues.Title
$DL = $Member.FieldValues.Distribution_x0020_List
$User = $Member.FieldValues.User.Email
Add-DistributionGroupMember -Identity $DL -Member $User

$RequesterDisplayName = $Member.FieldValues.Author.LookupValue
$Requesteremail = $Member.FieldValues.Author.email

$body = "Hello $RequesterDisplayName , </br> The account $User has been added to the following Distribution List: $DL </br> You can now close ticket number #$TicketNumber "
$Subject = "User added to requested DL for Helpdesk Ticket #$TicketNumber"

Send-MailMessage -To $Requesteremail -from vlad-admin@office365powershell.ca -Subject $Subject -Body $body -BodyAsHtml -smtpserver smtp.office365.com -usessl -Credential $cred -Port 587 

$updatedItem = Set-PnPListItem -List 'DL Request' -Identity $Member.id -Values @{"Processed" = $true}
 