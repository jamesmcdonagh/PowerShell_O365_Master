$Contacts = Get-MailContact
foreach ($contact in $contacts)
{
	Set-MailContact -Identity $contact.Name -DisplayName "$contact [External]"
}

Set-MailContact -Identity "401K Questions" -MailTip "Do not send confidential information to this mailbox!"
