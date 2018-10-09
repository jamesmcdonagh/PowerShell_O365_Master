Set-OrganizationConfig -FocusedInboxOn $false -LinkPreviewEnabled $false -BookingsEnabled $false

Set-OrganizationConfig -DistributionGroupNameBlockedWordsList Apress,Contoso,CEO

Set-OrganizationConfig -DistributionGroupNamingPolicy  "DL_<GroupName>_<CountryOrRegion>"
