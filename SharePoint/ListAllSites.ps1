$Sites = Get-SPSite -Limit All
$Report = @()
Foreach ($site in $Sites)
{
    foreach ($web in $site.AllWebs)
    {

        $Report += Get-SPWeb -Identity $web.Url | Select Url, Title,@{Name = "Template" ; Expression = { $web.WebTemplate + $web.WebTemplateId }},LastItemModifiedDate, @{Name = "Owner" ; Expression = { $site.Owner.UserLogin}}
 
    }
}
$Report | Export-Csv -Path report.csv -NoTypeInformation
