Get-AzureADSubscribedSku | Select-Object  -Property ObjectId, SkuPartNumber, ConsumedUnits -ExpandProperty PrepaidUnits

Get-AzureADSubscribedSku | Select-Object -Property SkuPartNumber  -ExpandProperty ServicePlans | Format-Table -GroupBy SkuPartNumber  