$Users = Get-AzureADUser | Where {$_.UserType -eq "Member"}

foreach ($user in $users) 
{

    if ($user.DirSyncEnabled) 
    {
        Write-Host $User.UserPrincipalName "is synced from an On-Premises AD. Ignored in current script" -ForegroundColor Yellow
    }
    else 
    {
        $NewDisplayName = $User.GivenName + " " + $User.SurName
        
        Write-Host $User.UserPrincipalName "Current Display name is" $User.DisplayName  "and will be changed to $NewDisplayName" -ForegroundColor Green

        Set-AzureADUser -ObjectId $user.ObjectId -DisplayName $NewDisplayName 
    }
}
