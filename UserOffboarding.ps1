#Input
$Username = "<Name>@<Domain>.org"


#Initializing Variables
$User = Get-AzureADUser -ObjectId $Username
$Mailbox = Get-Mailbox | Where {$_.PrimarySmtpAddress -eq $username}
$Manager = Get-AzureADUserManager -ObjectId $user.ObjectId
$OutOfOfficeBody = @"
Hello </br> </br>
Please Note I am not working for <Company> anymore. </br> </br>  
Please contact $($Manager.DisplayName) <a href="mailto:$($Manager.UserPrincipalName)">$($Manager.UserPrincipalName)</a> for any questions. </br> </br>
Thanks!
"@

#Set Sign in Blocked
Set-AzureADUser -ObjectId $user.ObjectId -AccountEnabled $false

#Disconnect Existing Sessions
Revoke-SPOUserSession -User $Username -confirm:$False
Revoke-AzureADUserAllRefreshToken -ObjectId $user.ObjectId

#Forward e-mails to manager
Set-Mailbox $Mailbox.Alias -ForwardingAddress $Manager.UserPrincipalName -DeliverToMailboxAndForward $False -HiddenFromAddressListsEnabled $true

#Set Out Of Office
Set-MailboxAutoReplyConfiguration -Identity $Mailbox.Alias -ExternalMessage $OutOfOfficeBody -InternalMessage $OutOfOfficeBody -AutoReplyState Enabled

#Cancel meetings organized by this user
Remove-CalendarEvents -Identity $Mailbox.Alias -CancelOrganizedMeetings -confirm:$False

#RemoveFromDistributionGroups
$DistributionGroups= Get-DistributionGroup | where { (Get-DistributionGroupMember $_.Name | foreach {$_.PrimarySmtpAddress}) -contains "$Username"}

foreach( $dg in $DistributionGroups)
	{
	Remove-DistributionGroupMember $dg.name -Member $Username -Confirm:$false
	}

#Re-Assign Office 365 Group Ownership
$Office365GroupsOwner = Get-UnifiedGroup | where { (Get-UnifiedGroupLinks $_.Alias -LinkType Owners| foreach {$_.name}) -contains $mailbox.Alias}
$NewManagerGroups = @()
foreach($GRP in $Office365GroupsOwner)
	{
	$Owners = Get-UnifiedGroupLinks $GRP.Alias -LinkType Owners
	if ($Owners.Count -le 1)
		{
		#Our user is the only owner
		Add-UnifiedGroupLinks -Identity $GRP.Alias -LinkType Members -Links $Manager.UserPrincipalName
		Add-UnifiedGroupLinks -Identity $GRP.Alias -LinkType Owners -Links $Manager.UserPrincipalName
		$NewManagerGroups += $GRP
		Remove-UnifiedGroupLinks -Identity $GRP.Alias -LinkType Owners -Links $Username -Confirm:$false
		Remove-UnifiedGroupLinks -Identity $GRP.Alias -LinkType Members -Links $Username -Confirm:$false
		}
	else
		{
		#There Are Other Owners
		Remove-UnifiedGroupLinks -Identity $GRP.Alias -LinkType Owners -Links $Username -Confirm:$false
		}
	}

#Remove from Office 365 Groups
$Office365GroupsMember = Get-UnifiedGroup | where { (Get-UnifiedGroupLinks $_.Alias -LinkType Members | foreach {$_.name}) -contains $mailbox.Alias}
$NewMemberGroups = @()
foreach($GRP in $Office365GroupsMember)
	{
	$Members = Get-UnifiedGroupLinks $GRP.Alias -LinkType Members
	if ($Members.Count -le 1)
		{
		#Our user is the only Member
		Add-UnifiedGroupLinks -Identity $GRP.Alias -LinkType Members -Links $Manager.UserPrincipalName
		$NewMemberGroups += $GRP
		Remove-UnifiedGroupLinks -Identity $GRP.Alias -LinkType Members -Links $Username -Confirm:$false
		}
	else
		{
		#There Are Other Members
		Remove-UnifiedGroupLinks -Identity $GRP.Alias -LinkType Members -Links $Username -Confirm:$false
		}
	}

#Send OneDrive for Business Information to Manager
$OneDriveUrl = Get-PnPUserProfileProperty -Account $username | select PersonalUrl
Set-SPOUser $Manager.UserPrincipalName -Site $OneDriveUrl.PersonalUrl -IsSiteCollectionAdmin:$true

#Send Final E-mail to Manager

#BuildHTMLObjects

If ($DistributionGroups)
{
	$DGHTML = "</br> The user has been removed from the following distribution lists <ul> "
	foreach( $dg in $DistributionGroups)
	{
		$DGHTML += "<li>$($dg.PrimarySmtpAddress) </li>"
	}
	$DGHTML += "</ul> </br>"	
}

If ($Office365GroupsOwner)
{
	$O365OwnerHTML = "</br> The user was an owner, and got removed from the following groups <ul> "
	foreach($GRP in $Office365GroupsOwner)
	{
		$O365OwnerHTML += "<li>$($GRP.PrimarySmtpAddress) </li>"
	}
	$O365OwnerHTML += "</ul> </br>"
}

If ($Office365GroupsMember)
{
	$O365MemberHTML = "</br> The user was a member, and got removed from the following groups <ul> "
	foreach($GRP in $Office365GroupsMember)
	{
		$O365MemberHTML += "<li>$($GRP.PrimarySmtpAddress) </li>"
	}
	$O365MemberHTML += "</ul> </br>"
}

If ($NewManagerGroups)
{
	$NewOwnerAlertHTML = "</br> <b>*Attention Required* </b> </br> The user was the only owner of the following groups. Please verify if there is any content in those groups that is still needed, otherwise, archive the groups as per normal procedure  <ul> "
	foreach($GRP in $NewManagerGroups)
	{
		$NewOwnerAlertHTML += "<li>$($GRP.PrimarySmtpAddress) </li>"
	}
	$NewOwnerAlertHTML += "</ul> </br>"
}

If ($NewMemberGroups)
{
	$NewMemberAlertHTML = "</br> <b>*Attention Required* </b> </br> The user was the only member of the following groups. Please verify if there is any content in those groups that is still needed, otherwise, contact the owner of the groups to be removed, or to archive the group<ul> "
	foreach($GRP in $NewMemberGroups)
	{
		$NewMemberAlertHTML += "<li>$($GRP.PrimarySmtpAddress) </li>"
	}
	$NewMemberAlertHTML += "</ul> </br>"
}


$Subject = "User Offboarding Complete: $($User.UserPrincipalName)"	
$ManagerEmailBody = @"
Hello $($Manager.DisplayName) </br> </br>

This is an automated e-mail from IT to let you know that the account <b> $($User.UserPrincipalName) </b> has been de-activated as per normal standard procedure. All e-mails have been forwarded to you! $DGHTML $O365OwnerHTML $O365MemberHTML $NewOwnerAlertHTML $NewMemberAlertHTML  </br>

You have also been assigned ownership of the OneDrive for Business of the account. Please navigate to the following URL : <a href="$($OneDriveUrl.PersonalUrl)">$($OneDriveUrl.PersonalUrl)</a> and save any important data within 30 days. </br>

If you have any questions, please contact the IT Department. </br> Thank you!

"@

Send-MailMessage -To $Manager.UserPrincipalName -from <User>@<Domain>.org -Subject $Subject -Body ( $ManagerEmailBody | out-string ) -BodyAsHtml -smtpserver smtp.office365.com -usessl -Credential $cred -Port 587