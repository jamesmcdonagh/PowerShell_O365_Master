$Groups = Get-SPOSiteGroup -Site $site
foreach ($Group in $Groups)
    {
        Write-Host $Group.Title -ForegroundColor "Blue"
        Get-SPOSiteGroup -Site $site -Group $Group.Title | Select-Object -ExpandProperty Users
        Write-Host
    }
     