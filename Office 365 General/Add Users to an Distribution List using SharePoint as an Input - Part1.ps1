Import-Module SharePointPnPPowerShellOnline
$cred = Import-CliXML C:\Scripts\pass.xml
Connect-PnPOnline -Url https://office365powershell.sharepoint.com -Credentials $cred

$Exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $cred -Authentication "Basic" -AllowRedirection 

Import-PSSession $Exchange

$DistributionGroups = Get-DistributionGroup | Select  PrimarySmtpAddress -ExpandProperty PrimarySmtpAddress

$DLField = Get-PnPField -List "DL Request" | Where {$_.ID -eq "b06268ba-4779-45f8-8b31-c2d33fd18f9f"}
$DLField.Choices = $DistributionGroups
$DLField.Update()
Execute-PnPQuery
 