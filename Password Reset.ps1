Import-Module ActiveDirectory

$user = Read-Host -Prompt 'Enter the Employee Username (Firstname.Lastname)'

$pwexpire = get-aduser -Identity $user -Properties passwordneverexpires | select passwordneverexpires | Format-Wide | findstr.exe "True False"
$setdate = get-aduser -Identity $user -Properties passwordlastset | select passwordlastset | findstr.exe 20 | get-date
write-Host

$today = get-date -Format yyyyMMddHHmmss
$expdate = ($setdate.AddDays(365)).tostring("yyyyMMddHHmmss")

if($today -ge $expdate -and $pwexpire -match "False") {write-host "     Password Is Expired." -ForegroundColor red} else {write-host "     Password Is Current." -ForegroundColor green}

write-host '     Password Last Set:'$setdate -foregroundcolor yellow

if ($pwexpire -match "False") {write-host '     Password Expires:'$setdate.AddDays(365) -foregroundcolor yellow} else {Write-host "     Password Does Not Expire." -ForegroundColor yellow}

$lockedout = get-aduser -Identity $user -Properties lockouttime | select lockouttime | Format-wide | findstr 0
if ($lockedout -le 1) {write-host "     Account Is Not Locked." -foregroundcolor green} else {Write-host "     Account is locked due to too many incorrect password attempts." -ForegroundColor red}

write-Host

$unlock = Read-Host -Prompt 'Unlock User Account? (y or n)'
if ($unlock -eq "y") {Unlock-ADAccount -Identity $user}

$reset = Read-Host -Prompt 'Reset User Password? (y or n)'

if ($reset -eq "y") {$custom = Read-Host -Prompt 'Force User to Customize Password? (y or n)'} else {exit}
Set-ADAccountPassword -Identity $user -reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Changeme123' -Force)
if ($custom -eq "y") {Set-ADUser -Identity $user -ChangePasswordAtLogon $true} else {Set-ADUser -Identity $user -ChangePasswordAtLogon $false}
Unlock-ADAccount -Identity $user

write-Host