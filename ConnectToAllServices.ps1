Install-Module -Name AzureAD
Install-Module -Name MicrosoftTeams
#Get Connection Credential
$cred = Get-Credential
$EXSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
$SCSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
#Establish Connections
Connect-AzureAD -Credential $cred #if using MFA leave out -credential
Connect-SPOService -Url https://procasemanagement-admin.sharepoint.com -Credential $cred #if using MFA leave out -credential
Connect-MicrosoftTeams -Credential $cred #if using MFA, COnnect-MicrosoftTeams -AccountId <USER>
Import-PSSession $EXSession #Exchange Online Import, if using MFA download the exchange online powershell module from the exchange admin center and use Connect-EXOPSSession
Import-PSSession $SCSession #Security and Compliance Import, if using MFA download the exchange online powershell module from the exchange admin center and use Connect-IPPSSession


#To install Azure AD Public Preview use: Install-Module AzureADPreview

#Sharepoint Online Module: https://www.microsoft.com/en-us/download/details.aspx?id=35588

#To install SharePoint Patterns and Practices PowerShell Cmdlets for SharePoint Online use: Install-Module -Name SharePointPNPPowerShellOnline
#To connect to Sharepoint PNP: Connect-PnPOnline -Url https://yoursite.sharepoint.com -Credentials $cred
#If using MFA Connect-PNPOnline -Url https://yoursite.sharepoint.com -UseWebLogin