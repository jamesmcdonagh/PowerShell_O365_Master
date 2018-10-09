Set-SPOTenant -BccExternalSharingInvitations $true -BccExternalSharingInvitationsList "james.mcdonagh@statera.com,admin@statera.com" -DefaultSharingLinkType Internal -DisplayStartASiteOption $false -OrphanedPersonalSitesRetentionPeriod 3650 -RequireAcceptingAccountMatchInvitedAccount $true -SharingCapability ExternalUserSharingOnly

Set-SPOTenantSyncClientRestriction -Enable -DomainGuids "508C857F-B879-4413-AB1E-AC33FA7D4477" -BlockMacSync:$true
Set-SPOTenantSyncClientRestriction -ExcludedFileExtensions "js"  

