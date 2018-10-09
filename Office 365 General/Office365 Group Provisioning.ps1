Import-Module SharePointPnPPowerShellOnline
$cred = Import-CliXML C:\Scripts\pass.xml
Connect-PnPOnline -Url https://office365powershell.sharepoint.com -Credentials $cred
$Exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $cred -Authentication "Basic" -AllowRedirection 

Import-PSSession $Exchange

$GroupRequests = Get-PnPListItem -List 'Office 365 Group Request'
foreach ($Group in $GroupRequests|Where {$_.FieldValues.Processed -eq $false})
{
$GroupTitle = $Group.FieldValues.Title
$Description = $Group.FieldValues.Business_x0020_Justification -replace "<.*?>" 

$Classification = $Group.FieldValues.Classification
$Language = $Group.FieldValues.Language
$AccessType = $Group.FieldValues.Access_x0020_Type
$Members = $Group.FieldValues.Members.Email
$Owners = $Group.FieldValues.Owners.Email

$GroupAlias = "O365Group-$GroupTitle"  -replace '\s',''
switch ($Language) 
    { 
        "English" {$LanguageCode = "en-US"} 
        "French" {$LanguageCode = "fr-FR"}  
        "Spanish" {$LanguageCode = "es-ES"}  
        default {throw "Language not valid"}
    }

If ($AccessType -eq "Secret"){
New-UnifiedGroup -DisplayName $GroupTitle -Alias $GroupAlias -EmailAddresses "$GroupAlias@<Domain>" -AccessType Private -HiddenGroupMembershipEnabled -Classification $Classification -Language $LanguageCode  -Notes $Description

Set-UnifiedGroup -Identity $GroupAlias -HiddenFromAddressListsEnabled $true
} Else
	{
New-UnifiedGroup -DisplayName $GroupTitle -Alias $GroupAlias -EmailAddresses "$GroupAlias@<Domain>" -AccessType $AccessType -Classification $Classification -Language $LanguageCode -Notes $Description
	}

If ($Members)
	{
Add-UnifiedGroupLinks -Identity $GroupAlias -LinkType "Members" -Links $Members
	}

If ($Owners)
	{
Add-UnifiedGroupLinks -Identity $GroupAlias -LinkType "Members" -Links $Owners
Add-UnifiedGroupLinks -Identity $GroupAlias -LinkType "Owners" -Links $Owners
	}
	
$updatedItem = Set-PnPListItem -List 'Office 365 Group Request' -Identity $Group.id -Values @{"Processed" = $true}
}
