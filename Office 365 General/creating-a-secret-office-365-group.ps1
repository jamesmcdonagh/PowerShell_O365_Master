New-UnifiedGroup -DisplayName "Reorg-2021" -Alias "O365Group-Reorg-2021" -EmailAddresses "Reorg-2021@globomantics.org" -AccessType Private -HiddenGroupMembershipEnabled 

Set-UnifiedGroup -Identity "O365Group-Reorg-2021" -HiddenFromAddressListsEnabled $true
