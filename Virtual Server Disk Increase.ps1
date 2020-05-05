write-host
$vmname = Read-Host -Prompt 'Enter VM Name'
Get-HardDisk -vm $vmname
write-host
$Disk = Read-Host -Prompt 'Enter Disk #'
$newhdcap = Read-Host -Prompt 'Enter new HD Size in GB'
write-host
Get-HardDisk -vm $vmname | where {$_.Name -eq "Hard Disk $Disk"} | Set-HardDisk -CapacityGB $newhdcap -ResizeGuestPartition -Confirm:$false  -ErrorAction SilentlyContinue  | out-null
Get-HardDisk -vm $vmname