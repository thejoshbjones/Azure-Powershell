$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential
$olddomain = "@olddomain.com"
$newdomain = "@newdomain.com"
$makealias = $true
$userou = 'OU=TestUsers,OU=UsersOU,DC=domain,DC=local'
$server = 'server'
$users = Get-ADUser -Filter * -SearchBase $userou -Properties UserPrincipalName, SamAccountName, givenName, surName, EmailAddress, ProxyAddresses, mailNickName, targetAddress
Foreach ($user in $users) {
    $firstName = $user.givenName.ToLower()
    $lastName = $user.surName.ToLower()
    $oldUPN = "$($user.UserPrincipalName)"
    $newUPN = "$($firstName).$($lastName)$($newdomain)"
    $oldsamaccountname = "$($user.SamAccountName)"
    $newsamaccountname = "$($firstName).$($lastName)"
    $oldemail = "$($user.samaccountname)$($olddomain)"
    $newemail = "$($firstName).$($lastName)$($newdomain)"
    Write-Host "User: $($user.samaccountname)`n------------------------"d

    #Update Mail Attribute    
    If ($user.EmailAddress -ieq $oldemail) {
        Write-Host "Mail Attribute: Old Value Detected Updating..."
        Write-Host "Old Value: $($user.EmailAddress)"
        $user.EmailAddress = $newemail
        Write-Host "New Value: $($newemail)"
    }
    Elseif ($user.EmailAddress -ieq "$newemail") {
        Write-Host "Mail Attribute: New Value Detected Skipping..."
        Write-Host "Value: $($user.EmailAddress)"
    }
    Else {
        Write-Host "Mail Attribute: Unknown Value Detected NOT Updating..."
        Write-Host "Value: $($user.EmailAddress)"
    }

     #Update MailNickname Attribute
     $oldnickname = "$($firstName)-$($lastName)"
     $newnickname = "$($firstName).$($lastName)"  
    If ($user.mailNickName -ieq $oldnickname) {
        Write-Host "MailNickname Attribute: Old Value Detected Updating..."
        Write-Host "Old Value: $($user.mailNickName)"
        $user.mailNickName = $newnickname
        Write-Host "New Value: $($newnickname)"
    }
    Elseif ($user.mailNickName -ieq "$newnickname") {
        Write-Host "MailNickName Attribute: New Value Detected Skipping..."
        Write-Host "Value: $($user.mailNickName)"
    }
    Else {
        Write-Host "MailNickName Attribute: Unknown Value Detected NOT Updating..."
        Write-Host "Value: $($user.mailNickName)"
    }

    #Update targetAddress Attribute"  
    If ($user.targetAddress -ine "$newemail") {
        Write-Host "targetAddress Attribute: Old Value Detected Updating..."
        Write-Host "Old Value: $($user.targetAddress)"
        $user.targetAddress = $newemail
        Write-Host "New Value: $($newemail)"
    }
    Else{
        Write-Host "targetAddress Attribute: New Value Detected Skipping..."
        Write-Host "Value: $($user.targetAddress)"
    }

    #Update ProxyAddresses Attribute
    $blnPrimaryOld = $false
    $blnPrimaryNew = $false
    $blnPrimaryOther = $false
    $blnAliasOld = $false
    $blnAliasNew = $false
    ForEach ($proxy in $user.ProxyAddresses) {
        If ($proxy.StartsWith("SMTP:")) {
            If ($proxy -eq "SMTP:$($oldemail)") {
                $blnPrimaryOld = $true
            }
            Elseif ($proxy -eq "SMTP:$($newemail)") {
                $blnPrimaryNew = $true
            }
            Else {
                $blnPrimaryOther = $true
            }
        }
        ElseIf ($proxy.StartsWith("smtp:")) {
            If ($proxy -eq "smtp:$($oldemail)") {                
                $blnAliasOld = $true
            }
            Elseif ($proxy -eq "smtp:$($newemail)") { 
                $blnAliasNew = $true
            }
        }
    }
    If (($blnPrimaryOld -eq $true) -AND ($blnPrimaryNew -eq $false) -AND ($blnPrimaryOther -eq $false)) {
        Write-Host "Primary Email: Old Value Detected Updating..."
        Write-Host "Removing SMTP:$($oldemail)"
        $user.ProxyAddresses.remove("SMTP:$($oldemail)")
        Write-Host "Adding SMTP:$($newemail)"
        $user.ProxyAddresses.add("SMTP:$($newemail)")
        Write-Host "Make Old Email Alias: $($makealias)"                
        If ($makealias -eq $true) {
            Write-Host "smtp:$($oldemail)"  
            $user.ProxyAddresses.add("smtp:$($oldemail)")
        }
    }
    Elseif (($blnPrimaryNew -eq $true) -AND ($blnPrimaryOld -eq $false) -AND ($blnPrimaryOther -eq $false)) {
        Write-Host "Primary Email: New Value Detected Skipping..."
    }
    Else {
        Write-Host "Primary Email: Unknown Value Detected NOT Updating..."
    }

    #Write Values to User
    Write-Host "Setting Values..."
    $result = Set-ADUser -Instance $user
    Write-Host "`n"

    #Update ADUPN and AzureAD UPN
    If ($user.UserPrincipalName -ieq $oldUPN) {
        Write-Host "UPN: Old Value Detected Updating..."
        Write-Host "Old Value: $($user.UserPrincipalName)"
        Set-ADUser -identity $oldsamaccountname -UserPrincipalName $newUPN -SamAccountName $newsamaccountname
        Set-MsolUserPrincipalName -UserPrincipalName $oldUPN -NewUserPrincipalName $newUPN
        Write-Host "New Value: $($newUPN)"
    }
    Elseif ($user.UserPrincipalName -ieq "$newUPN") {
        Write-Host "UPN: New Value Detected Skipping..."
        Write-Host "Value: $($user.UserPrincipalName)"
    }
    Else {
        Write-Host "UPN: Unknown Value Detected NOT Updating..."
        Write-Host "Value: $($user.UserPrincipalName)"
    }
}

Pause