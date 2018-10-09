$SiteCollections = Import-CSV .\RequestedSites.csv
foreach ($Site in $SiteCollections){ 
	$Title = $Site.SiteName
	$Url = $Site.SiteUrl
	$Owner = $Site.Owner
	Write-Host "Creating the $Title Site Collection at $Url with Site Owner $Owner"
	New-SPOSite -Url $Url -Title $Title -Owner $Owner -Template 'STS#0' -StorageQuota 512
}
