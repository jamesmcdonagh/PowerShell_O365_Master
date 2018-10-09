$Teams = Get-Team
Foreach ($team in $Teams)
{
	try
	{
		Set-TeamFunSettings -GroupId $team.GroupId -AllowGiphy $false -AllowStickersAndMemes $false -AllowCustomMemes $false
	}
	catch
	{
		$ErrorMessage = $_.Exception.Message
		Write-Host $Team.DisplayName " Failed with error " -ForeGroundcolor Yellow
		Write-Host $ErrorMessage -ForeGroundcolor Yellow
	}

}