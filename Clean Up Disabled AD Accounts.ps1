#This script will delete all Users, Computers, and Groups located in the Disabled OU that are older than 30 days.

#Sets dates for today and one month ago.
$Today = get-date
$MonthOld = $Today.AddDays(-30)


#Users
#Puts all Users in the Disabled OU (excluding the sub OU for former employees) into a variable.
$DisabledUsers = get-aduser -filter * -searchbase "OU=Disabled,DC=hq,DC=prosb,DC=local" -Properties Name,description | ? { ($_.distinguishedname -notlike '*Former*') }

#Pulls the disabled date for each user from their account Description and checks to see if it's older than a month.
foreach ($i in $DisabledUsers) {

$DisabledDate = Get-ADUser -Identity $i -Properties description | select description
$DisabledDate -match 'Disabled (\d\d\d\d-\d\d-\d\d)*'

#Deletes the AD user account if it was disabled over a month ago.
if ((Get-Date $matches[1]) -lt $MonthOld) {Remove-ADUser -Identity $i -Confirm:$False}

}


#Computers
#Puts all Computers in the Disabled OU (excluding the sub OU for former employees) into a variable.
$DisabledComputers = get-ADComputer -filter * -searchbase "OU=Disabled,DC=hq,DC=prosb,DC=local" -Properties Name,description | ? { ($_.distinguishedname -notlike '*Former*') }

#Pulls the disabled date for each computer from its account Description and checks to see if it's older than a month.
foreach ($i in $DisabledComputers) {

$DisabledDate = Get-ADComputer -Identity $i -Properties description | select description
$DisabledDate -match 'Disabled (\d\d\d\d-\d\d-\d\d)*'

#Deletes the AD computer account if it was disabled over a month ago.
if ((Get-Date $matches[1]) -lt $MonthOld) {Remove-ADComputer -Identity $i -Confirm:$False}

}


#Groups
#Puts all Groups in the Disabled OU (excluding the sub OU for former employees) into a variable.
$DisabledGroups = get-ADGroup -filter * -searchbase "OU=Disabled,DC=hq,DC=prosb,DC=local" -Properties Name,description | ? { ($_.distinguishedname -notlike '*Former*') }

#Pulls the disabled date for each Group from its account Description and checks to see if it's older than a month.
foreach ($i in $DisabledGroups) {

$DisabledDate = Get-ADGroup -Identity $i -Properties description | select description
$DisabledDate -match 'Disabled (\d\d\d\d-\d\d-\d\d)*'

#Deletes the AD Group account if it was disabled over a month ago.
if ((Get-Date $matches[1]) -lt $MonthOld) {Remove-ADGroup -Identity $i -Confirm:$False}

}