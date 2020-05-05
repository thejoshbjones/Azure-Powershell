#Microsoft Exchange

#Get credentials from user
$UserCredential = Get-Credential -Message "**Enter Local Domain Admin Credentials**"

#Create Microsoft Exchange Session
$SessionMSE = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://dirsyncserver.domain.local/PowerShell/ -Authentication Kerberos -Credential $UserCredential

#Import Session
Import-PSSession $SessionMSE

#test Function
Get-User username

#End Microsoft Exchange Session
Remove-PSSession $SessionMSE

Pause

#Local AD

$ps1 = "folderlocation\LocalAD.ps1"
&$ps1 -p -script="folderlocation\LocalAD.ps1"


#Azure AD
$o365user = Get-Credential -Message "**Enter Office365 Credentials**"
#Create AzureAD Session
$SessionAAD = New-PSSession -ConfigurationName Microsoft.ExchangeAAD -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $o365user -Authentication Basic -AllowRedirection

#Import Session
Import-PSSession $SessionAAD 

#test Function
Get-ADUser -Filter 'Name -like "Name*"'

Remove-PSSession $SessionAAD

Pause