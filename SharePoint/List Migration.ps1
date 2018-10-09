$cred = (Get-Credential james@domain.com)
$sourcePackage = 'F:\Migration\Package_Source'
$targetPackage = 'F:\Migration\Package_Target'
$targetWeb = 'https://globomanticsorg.sharepoint.com/sites/GLobomanticsMigration'
$targetList = '/Lists/NewLargeList'
$adminSite = 'https://globomanticsorg-admin.sharepoint.com'
$azureAccountName = 'globomanticsorg'
$azureAccountKey = 'DdCWckq0ngLAZvepzpGrs6ZsWIeP606IGZqCR2jr5GjIQvU938j7ix6swDp2OZfnDFff6eLCNt6YOi6zt0sAxg=='
$azureQueueName = 'TestMigration'
Connect-SPOService -Url $adminSite -Credential $cred


Export-SPWeb -Identity "http://globomantics.eastus.cloudapp.azure.com" -Path $sourcePackage -ItemUrl "/Lists/LargeList" -NoFileCompression -IncludeUserSecurity -IncludeVersions All -Force

$FinalPackage = ConvertTo-SPOMigrationTargetedPackage -SourceFilesPath $sourcePackage -SourcePackagePath $sourcePackage -OutputPackagePath $targetPackage -TargetWebUrl $targetWeb -TargetListPath $targetList -Credential $cred  -ParallelImport

$UploadJob = Set-SPOMigrationPackageAzureSource -SourceFilesPath $sourcePackage -SourcePackagePath $targetPackage -AzureQueueName $azureQueueName -AccountName $azureAccountName -AccountKey $azureAccountKey

$MigrationJob = Submit-SPOMigrationJob -TargetWebUrl $targetWeb -MigrationPackageAzureLocations $UploadJob -Credentials $cred

$status = Get-SPOMigrationJobProgress -AzureQueueUri $UploadJob.ReportingQueueUri -Credentials $cred
