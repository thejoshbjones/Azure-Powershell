$adminUPN="user@domain.com"
$orgName="orgtenantname"
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."
Import-Module -Name "C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync"
Connect-SPOService -Url https://orgtenantname-admin.sharepoint.com -Credential $userCredential

cmd.exe /c pause