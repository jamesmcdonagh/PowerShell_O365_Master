$Setting = Get-AzureADDirectorySetting | where-object {$_.displayname -eq 'Group.Unified'}
$Setting.Values

$Setting["PrefixSuffixNamingRequirement"] = "GRP [Department] [GroupName] [CountryOrRegion]"
$Setting["CustomBlockedWordsList"]="CEO,Legal,Payroll"
$Setting["EnableMSStandardBlockedWords"]="True"

Set-AzureADDirectorySetting -Id $Setting.id -DirectorySetting $Setting 