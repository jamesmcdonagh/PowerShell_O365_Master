Get-UnifiedGroup | 
    select Id,Alias, AccessType, `
    @{Expression={([array](Get-UnifiedGroupLinks -Identity $_.Id -LinkType Members)).Count }; `
    Label='Members'}, `
    @{Expression={([array](Get-UnifiedGroupLinks -Identity $_.Id -LinkType Owners)).Count }; `
    Label='Owners'}, `
    @{Expression={([array](Get-UnifiedGroupLinks -Identity $_.Id -LinkType Subscribers)).Count }; `
    Label='Subscribers'} |
    Format-Table Alias,Members,Owners,Subscribers -AutoSize
     