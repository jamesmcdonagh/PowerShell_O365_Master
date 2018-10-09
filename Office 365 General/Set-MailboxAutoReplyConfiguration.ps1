$Body = @"
"Hello </br> </br>
Please Note I am not currently working for Office 365 PowerShell anymore. </br> </br>  
Please contact Jeff Collins <a href="mailto:jeff.collins@office365powershell.ca">jeff.collins@office365powershell.ca</a> for any questions. </br> </br>
Thanks!"
"@

Set-MailboxAutoReplyConfiguration -Identity vlad-admin@office365powershell.ca -ExternalMessage $body -InternalMessage $body
