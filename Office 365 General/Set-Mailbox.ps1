Set-Mailbox -Identity Shared -HiddenFromAddressListsEnabled $true

Set-Mailbox -Identity john.smith -HiddenFromAddressListsEnabled $true -DeliverToMailboxAndForward $false -ForwardingAddress jeff.collins@<Domain>
