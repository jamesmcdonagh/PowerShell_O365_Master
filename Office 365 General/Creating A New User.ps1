$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "Getin123$"
$PasswordProfile.ForceChangePasswordNextLogin = $true
New-AzureADUser -GivenName "James" -Surname "McDonagh" -DisplayName "James McDonagh" -UserPrincipalName "james.mcdonagh@domain.com" -MailNickName "James" -AccountEnabled $true -PasswordProfile $PasswordProfile -JobTitle "Consultant" -Department "IT"
