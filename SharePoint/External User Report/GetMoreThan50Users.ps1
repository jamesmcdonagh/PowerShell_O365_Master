try 
{
    for ($i=0;;$i+=50)
	{
        $ExternalUsers += Get-SPOExternalUser -PageSize 50 -Position $i -SiteUrl https://vnextsolutionsinc.sharepoint.com/sites/ExternalUsersTest -ea Stop
    }
}
catch 
{

}
$ExternalUsers.Count
