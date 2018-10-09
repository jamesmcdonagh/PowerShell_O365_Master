$domain = New-CsEdgeDomainPattern -Domain "Microsoft.com"
$domain2 = New-CsEdgeDomainPattern -Domain "Statera.com"

$AllowedList = New-CSEdgeAllowList –AllowedDomain $domain,$domain2

Set-CsTenantFederationConfiguration -AllowedDomains $AllowedList