Get-CsOnlineUser -LdapFilter "Department=Research" | Set-CsUser -AudioVideoDisabled $true 