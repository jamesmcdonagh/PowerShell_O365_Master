$ProcessedField = Get-PnPField -List "AddDistributionList" | Where {$_.Title -eq "Processed"}
$ProcessedField.SetShowInNewForm($false)
$ProcessedField.Update()
Invoke-PnPQuery
