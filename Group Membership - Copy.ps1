$SourceUsername = Read-Host -Prompt 'Enter Source Username'
$TargetUsername = Read-Host -Prompt 'Enter Target Username'

$remove = Read-Host -Prompt 'Remove Target User From All Current Groups First? (y or n)'

$SourceADUser = Get-ADUser -identity $SourceUsername -Properties memberOf
$TargetADUser = Get-ADUser -identity $TargetUsername -Properties memberOf

if ($remove -eq "y") {ForEach ($SourceDN In $TargetADUser.memberOf) {Remove-ADGroupMember -Identity $SourceDN -Members $TargetADUser -confirm:$false}}
ForEach ($SourceDN In $SourceADUser.memberOf) {Add-ADGroupMember -Identity $SourceDN -Members $TargetADUser}