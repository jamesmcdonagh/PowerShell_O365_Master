﻿try {
    for ($i=0;;$i+=50) {
        $ExternalUsers += Get-SPOExternalUser -PageSize 50 -Position $i -ShowOnlyUsersWithAcceptingAccountNotMatchInvitedAccount $true -ea Stop 
    }}
catch {}
$ExternalUsers
