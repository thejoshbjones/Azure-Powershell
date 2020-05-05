#Setup script variables
$script:x =@()
$ConnectionBroker = "sv-rdcb01.astonmartin.int"
$SessionHostCollection = "AML Applications"

#Imports the modules
Import-Module RemoteDesktop

#Runs the script
SetupForm 

Function SetupForm {
	#Setup the form
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

	$objForm = New-Object System.Windows.Forms.Form 
	$objForm.Text = "Select user(s)"
	$objForm.Size = New-Object System.Drawing.Size(300,320) 
	$objForm.StartPosition = "CenterScreen"

	$LogOffButton = New-Object System.Windows.Forms.Button
	$LogOffButton.Location = New-Object System.Drawing.Size(120,240)
	$LogOffButton.Size = New-Object System.Drawing.Size(75,23)
	$LogOffButton.Text = "Apply"
	$objForm.Controls.Add($LogOffButton)
	
	#When a user clicks the log off button get the details of the logged in users and call the scriptactions function
	$LogOffButton.Add_Click(
	   {
	        foreach ($objItem in $objListbox.SelectedItems)
	           {$script:x += $objItem}
	    	$MessageText = $objMessageTextBox.Text
			$WaitTime = $objWaitforText.Text
			ScriptActions 
			$objForm.Close()
				
		 })

	$CancelButton = New-Object System.Windows.Forms.Button
	$CancelButton.Location = New-Object System.Drawing.Size(200,240)
	$CancelButton.Size = New-Object System.Drawing.Size(75,23)
	$CancelButton.Text = "Cancel"
	$CancelButton.Add_Click({$objForm.Close()})
	$objForm.Controls.Add($CancelButton)

	$objLabel = New-Object System.Windows.Forms.Label
	$objLabel.Location = New-Object System.Drawing.Size(10,20) 
	$objLabel.Size = New-Object System.Drawing.Size(280,20) 
	$objLabel.Text = "Please select user(s):"
	$objForm.Controls.Add($objLabel) 

	$objListBox = New-Object System.Windows.Forms.ListBox 
	$objListBox.Location = New-Object System.Drawing.Size(10,40) 
	$objListBox.Size = New-Object System.Drawing.Size(260,20) 
	$objListBox.Height = 80
	$objListBox.SelectionMode = "MultiExtended"

	$objLabelMessage = New-Object System.Windows.Forms.Label
	$objLabelMessage.Location = New-Object System.Drawing.Size(10,115) 
	$objLabelMessage.Size = New-Object System.Drawing.Size(280,20) 
	$objLabelMessage.Text = "Message to send to user(s):"
	$objForm.Controls.Add($objLabelMessage) 

	$objMessageTextBox = New-Object System.Windows.Forms.TextBox
	$objMessageTextBox.Location = New-Object System.Drawing.Size(10,135) 
	$objMessageTextBox.Size = New-Object System.Drawing.Size(260,20) 
	$objForm.Controls.Add($objMessageTextBox) 
	
	$objLabelTime = New-Object System.Windows.Forms.Label
	$objLabelTime.Location = New-Object System.Drawing.Size(10,160) 
	$objLabelTime.Size = New-Object System.Drawing.Size(280,20) 
	$objLabelTime.Text = "Time in sec before logging user off"
	$objForm.Controls.Add($objLabelTime)

	$objWaitforText = New-Object System.Windows.Forms.TextBox
	$objWaitforText.Location = New-Object System.Drawing.Size(10,180) 
	$objWaitforText.Size = New-Object System.Drawing.Size(70,20) 
	$objForm.Controls.Add($objWaitforText) 

	$objCheckSendMessage = New-Object System.Windows.Forms.CheckBox 
	$objCheckSendMessage.Location = New-Object System.Drawing.Size(10,200) 
	$objCheckSendMessage.Size = New-Object System.Drawing.Size(100,30)
	$objCheckSendMessage.Text = "Send Message"
	$objForm.Controls.Add($objCheckSendMessage) 

	$objCheckLogOff = New-Object System.Windows.Forms.CheckBox 
	$objCheckLogOff.Location = New-Object System.Drawing.Size(120,200) 
	$objCheckLogOff.Size = New-Object System.Drawing.Size(100,30)
	$objCheckLogOff.Text = "Log Off"
	$objForm.Controls.Add($objCheckLogOff) 

#Find logged in users and display them in the form 
	$loggedonusers = Get-RDUserSession -ConnectionBroker "$connectionBroker" -CollectionName "$SessionHostCollection"
	ForEach ($user in $loggedonusers) {
	[void] $objListBox.Items.Add($user.username)
	}
	 
	$objForm.Controls.Add($objListBox) 

	$objForm.Topmost = $True

	$objForm.Add_Shown({$objForm.Activate()})
	[void] $objForm.ShowDialog()
}

Function SendMessage {
#This is the function to send a message to the user - it is called during the script operation depending on user selected options

	ForEach ($x in $objListBox.SelectedItems) {
		$UserSession = Get-RDUserSession -ConnectionBroker "$ConnectionBroker" -CollectionName "$sessionhostcollection" | Where-Object {$_.username -eq $x}
		Send-RDUserMessage -HostServer $UserSession.HostServer -UnifiedSessionID $UserSession.UnifiedSessionID -MessageTitle "Message from IT" -MessageBody "$MessageText"
	}
}

Function LogOff {
#This is the function used to log users off the remote desktop farm - it is called during the script operation depending on user selected options
	ForEach ($x in $objListBox.SelectedItems) {
		$UserSession = Get-RDUserSession -ConnectionBroker "$connectionbroker" -CollectionName "$sessionhostcollection" | Where-Object {$_.username -eq $x}
		Invoke-RDUserLogoff  -HostServer $UserSession.HostServer -UnifiedSessionID $UserSession.UnifiedSessionID -Force
	}
}

Function ScriptActions {
#This function contains the actions to take depending on the selections set by the user

#If the Send Message check box is checked call the SendMessage function
	If($objCheckSendMessage.Checked -eq $true) {
		SendMessage
		}
		
#If the check log off check box is checked call the logoff function		
	If($objCheckLogOff.Checked -eq $true) {
		#Waits for the specified number of seconds defined by the user running the script before calling the logoff function
		Start-Sleep -Seconds $waittime
		LogOff
		}
}