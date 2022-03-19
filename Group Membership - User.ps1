Write-Host
$user = Read-Host -Prompt 'Username'
$dn = (Get-ADUser $user).DistinguishedName

echo ' '
# Write-Host 'Direct Membership' -ForegroundColor Green
'Direct Membership'
Get-ADUser -Identity $user –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties Name | Select-Object Name | sort Name

echo ' '
echo ' '
Write-Host 'Recursive Membership' -ForegroundColor Green
# 'Recursive Membership'
echo ' '
echo Name
echo '----'
Get-ADGroup -LDAPFilter ("(member:1.2.840.113556.1.4.1941:={0})" -f $dn) | select Name | sort Name

