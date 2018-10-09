$Setting = Get-AzureADDirectorySetting | where-object {$_.displayname -eq 'Group.Unified'}
$Setting.Values

$Setting["ClassificationList"]="Restricted,Confidential,Secret,Top Secret"
$Setting["DefaultClassification"]="Confidential"
$Setting["ClassificationDescriptions"]="Restricted:Restricted material would cause undesirable effects if publicly available,Confidential:Confidential material would cause damage or be prejudicial to national security if publicly available,Secret:Secret material would cause serious damage to national security if it were publicly available,Top Secret:Top Secret is the highest level of classified information"

Set-AzureADDirectorySetting -Id $Setting.id -DirectorySetting $Setting
