$cred = (Get-Credential james@domain.com)
$sourceFiles = '\\sp2013farm-ad\ProjectDocs\'
$sourcePackage = 'F:\Migration\Package_Source'
$targetPackage = 'F:\Migration\Package_Target'
$targetWeb = 'https://globomanticsorg.sharepoint.com/sites/GLobomanticsMigration'
$targetDocLib = 'ProjectDocs'
$adminSite = 'https://globomanticsorg-admin.sharepoint.com'
$azureAccountName = 'globomanticsorg'
$azureAccountKey = 'DdCWckq0ngLAZvepzpGrs6ZsWIeP606IGZqCR2jr5GjIQvU938j7ix6swDp2OZfnDFff6eLCNt6YOi6zt0sAxg=='
$azureQueueName = 'TestMigration'
Connect-SPOService -Url $adminSite -Credential $cred

$tempPackage = New-SPOMigrationPackage -SourceFilesPath $SourceFiles -OutputPackagePath $sourcePackage -TargetWebUrl $targetWeb -TargetDocumentLibraryPath $targetDocLib

$FinalPackage = ConvertTo-SPOMigrationTargetedPackage -SourceFilesPath $SourceFiles -SourcePackagePath $sourcePackage -OutputPackagePath $targetPackage -TargetWebUrl $targetWeb -TargetDocumentLibraryPath $targetDocLib -Credential $cred -ParallelImport

$UploadJob = Set-SPOMigrationPackageAzureSource -SourceFilesPath $sourceFiles -SourcePackagePath $targetPackage -AzureQueueName $azureQueueName -AccountName $azureAccountName -AccountKey $azureAccountKey

$MigrationJob = Submit-SPOMigrationJob -TargetWebUrl $targetWeb -MigrationPackageAzureLocations $UploadJob -Credentials $cred

$status = Get-SPOMigrationJobProgress -AzureQueueUri $UploadJob.ReportingQueueUri -Credentials $cred
