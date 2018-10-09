#Creating the Directory Setting
$SettingTemplate = Get-AzureADDirectorySettingTemplate | where {$_.DisplayName -eq 'Group.Unified'} 
$NewAADSetting = $SettingTemplate.CreateDirectorySetting()
$NewAADSetting = New-AzureADDirectorySetting -DirectorySetting $NewAADSetting

$Setting = Get-AzureADDirectorySetting | where-object {$_.displayname -eq 'Group.Unified'}
$Setting["PrefixSuffixNamingRequirement"] = "GRP [Department] [GroupName] [CountryOrRegion]"
$Setting["CustomBlockedWordsList"]="CEO,Legal,Payroll"
$Setting["EnableMSStandardBlockedWords"]="True"
$Setting["ClassificationList"]="Restricted,Confidential,Secret,Top Secret"
$Setting["DefaultClassification"]="Confidential"
$Setting["ClassificationDescriptions"]="Restricted:Restricted material would cause undesirable effects if publicly available,Confidential:Confidential material would cause damage or be prejudicial to national security if publicly available,Secret:Secret material would cause serious damage to national security if it were publicly available,Top Secret:Top Secret is the highest level of classified information"
$Setting["UsageGuidelinesUrl"]=”https://office365powershell.sharepoint.com/SitePages/Office365GroupsPolicies.aspx”
$Setting["GuestUsageGuidelinesUrl"]="https://office365powershell.ca/guestpolicy"
$Setting["EnableGroupCreation"] = "False"
$Setting["GroupCreationAllowedGroupId"] = $Group.ObjectId
$Setting["AllowGuestsToBeGroupOwner"] = "False"
$Setting["AllowToAddGuests"] = "False"
$Setting["AllowGuestsToAccessGroups"] = "False"
Set-AzureADDirectorySetting -Id $Setting.id -DirectorySetting $Setting
