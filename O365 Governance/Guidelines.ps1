$Setting = Get-AzureADDirectorySetting | where-object {$_.displayname -eq 'Group.Unified'}
$Setting.Values

$Setting["UsageGuidelinesUrl"]="https://globomanticsorg.sharepoint.com/SitePages/GroupPolicies.aspx"
$Setting["GuestUsageGuidelinesUrl"]="https://domainname.org/guestpolicy"

Set-AzureADDirectorySetting -Id $Setting.id -DirectorySetting $Setting