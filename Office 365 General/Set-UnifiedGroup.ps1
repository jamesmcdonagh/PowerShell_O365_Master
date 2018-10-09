Set-UnifiedGroup -Identity SecretReorg -HiddenFromAddressListsEnabled:$true

Set-UnifiedGroup -Identity HRPublic -MailTip "This community is public to all company, please do not share any private information"
