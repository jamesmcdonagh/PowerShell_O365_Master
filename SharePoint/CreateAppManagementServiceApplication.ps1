$sa = New-SPAppManagementServiceApplication -Name "App Management Service Application" -DatabaseName "AppManagement" -ApplicationPool "SharePoint Web Services Default" 
New-SPAppManagementServiceApplicationProxy -Name "App Management Service Application" -ServiceApplication $sa -UseDefaultProxyGroup 
