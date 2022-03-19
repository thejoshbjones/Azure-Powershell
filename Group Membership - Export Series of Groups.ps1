$searchstring = Read-Host -Prompt 'Enter Group Name With * Wildcard'
$exportpath = Read-Host -Prompt 'Enter File Export Path'

if(-not (Test-Path -path $exportpath)) {mkdir $exportpath} else {write-host This folder already exists.  Files will be added to this existing folder. -ForegroundColor yellow}

$groups = get-adgroup -filter 'name -like $searchstring' -searchbase "OU=Groups,OU=-ProSB,DC=hq,DC=prosb,DC=local"
foreach ($i in $groups){Get-ADGroupMember -identity $i | Select Name | Sort Name | Export-Csv $exportpath\$i.csv -NoTypeInformation}

$sharedmailbox = Get-Mailbox -filter 'name -like $searchstring' -RecipientTypeDetails "sharedmailbox"
foreach ($i in $sharedmailbox) {get-Mailboxpermission -Identity $i.identity | select user | sort user | Where-Object {$_.user -like "*prosb*" -and $_.user -notlike "*cwadmin*"} | Export-Csv $exportpath\$i.csv -NoTypeInformation}

cd $exportpath
Get-ChildItem *.csv | foreach { Rename-Item $_ $_.name.replace("CN=","") }
Get-ChildItem *.csv | foreach { Rename-Item $_ $_.name.replace(",OU=Groups,OU=-ProSB,DC=hq,DC=prosb,DC=local","") }
Get-ChildItem *.csv | foreach { Rename-Item $_ $_.name.replace(".csv",".xls") }

gci  $exportpath | % {
$path = $_.fullname
$file = gc $_
$file[1..($file.length-0)] | % {$_.trimstart()} | out-file $path
}

Explorer $exportpath
