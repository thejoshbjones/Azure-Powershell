Write-Host Importing ActiveDirectory Module.
Import-module ActiveDirectory -WarningAction SilentlyContinue | Out-Null

Write-Host Get Credential
$adminUPN="upn@domain.com"
$userCredential = Get-Credential -UserName $adminUPN -Message "Enter Windows password."

Write-Host Connecting to MSOL Service.
connect-msolservice -Credential $userCredential

Write-Host Connecting to SharePoint Module.
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://tenantportal-name.sharepoint.com

Write-Host Connecting to Teams Module.
Import-module MicrosoftTeams
Connect-MicrosoftTeams

cd D:\tools

start D:\Tools\console1.msc

Write-Host Launch Exchange Online Shell
explorer "Local Location\Exchange Online Shell.appref-ms"

clear

Write-Host $host.ui.RawUI.WindowTitle = “AD and Office365 Tools”
$host.ui.RawUI.WindowTitle = “AD and Office365 Tools”



<#

Write-Host Importing Exchange Management Shell.
powershell -file "C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1"
Connect-ExchangeServer -auto -ClientApplication:ManagementShell

Write-Host Importing vSphere Modules.
Import-module VMware.VimAutomation.Core -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VimAutomation.Vds -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VimAutomation.Cloud -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VimAutomation.PCloud -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VimAutomation.Cis.Core -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VimAutomation.Storage -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VimAutomation.HA -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VimAutomation.vROps -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VumAutomation -WarningAction SilentlyContinue | Out-Null
Import-module VMware.VimAutomation.License -WarningAction SilentlyContinue | Out-Null
Connect-VIServer vcenter -WarningAction SilentlyContinue | Out-Null

Write-Host Importing Office365 non-2FA Exchange Module.
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -WarningAction SilentlyContinue | Out-Null

#>


