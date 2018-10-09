Import-Module SharePointPnPPowerShellOnline
$cred = Import-CliXML C:\Scripts\pass.xml
Connect-PnPOnline -Url https://office365powershell.sharepoint.com -Credentials $cred
$ProcessedField = Get-PnPField -List "DL Request" | Where {$_.Title -eq "Processed"}
$ProcessedField.SetShowInNewForm($false)
$ProcessedField.Update()
Execute-PnPQuery 