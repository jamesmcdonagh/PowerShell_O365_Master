Get-MailboxStatistics -Identity james@domain.com | Select DisplayName, DeletedItemCount, ItemCount, TotalItemSize, LastLogonTime

Get-Mailbox | Get-MailboxStatistics | Where-Object {$_.LastLogonTime -lt "12/15/2017"} | Select DisplayName

Get-Mailbox | Get-MailboxStatistics | Where-Object {$_.ItemCount -gt 20000}
