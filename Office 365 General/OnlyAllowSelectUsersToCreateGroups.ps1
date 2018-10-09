$Setting = Get-AzureADDirectorySetting | where-object {$_.displayname -eq 'Group.Unified'}
$Setting.Values

$SettingTemplate = Get-AzureADDirectorySettingTemplate | where {$_.DisplayName -eq 'Group.Unified'} 
$NewAADSetting = $SettingTemplate.CreateDirectorySetting()
$NewAADSetting = New-AzureADDirectorySetting -DirectorySetting $NewAADSetting


$Setting = Get-AzureADDirectorySetting | where-object {$_.displayname -eq 'Group.Unified'}
$Setting["EnableGroupCreation"] = "False"


$Group = Get-AzureADGroup -SearchString "Office 365 Group Creators"

$Setting["GroupCreationAllowedGroupId"] = $Group.ObjectId
Set-AzureADDirectorySetting -Id $Setting.id -DirectorySetting $Setting
