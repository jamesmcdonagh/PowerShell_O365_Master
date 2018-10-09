$Site = Get-SPOSite https://office365powershell.sharepoint.com
$Groups = Get-SPOSiteGroup -Site $Site
$Users = import-csv '.\CloneUsers.csv'
foreach ($User in $Users){

 $NewUser = $User.UserName
 $TemplateUser = $User.TemplateUserName

 foreach ($Group in $Groups)
 {
  foreach ($SPOUser in $Group.Users) 
  {
   if ($SPOUser -eq $TemplateUser)
    {
    $GroupName = $Group.LoginName
    Write-Host  "Adding  $NewUser  to  $GroupName"
    Add-SPOUser -Site $Site -LoginName $NewUser -Group $GroupName | out-null
    }
  }
 }
}
