Get-SPOsitegroup -Site https://prosb.sharepoint.com -Verbose | ? { ($_.title -like 'Corporate*') -or ($_.title -like 'PSB*') -or ($_.title -like 'MARS*') -or ($_.title -like 'User*') } | select title, @{Name='users';Expression={[string]::join(";", ($_.users))}} | export-csv localfolder\SharePoint365Permissions.csv -NoTypeInformation
localfolder\SharePoint365Permissions.csv

