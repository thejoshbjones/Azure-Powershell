$TARGETDIR = 'C:\PrintDrivers'
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
    #Driver1 Driver1 Install
        Invoke-WebRequest -Uri "https://bloblocal.blob.core.windows.net/folder/driverfile1.zip" -OutFile "$TargetDir\driverfile1.zip"
        Expand-Archive -LiteralPath $TargetDir\driverfile1.zip -DestinationPath C:\PrintDrivers
        pnputil /add-driver $TargetDir\driverfile1\driverinf1.inf
        Add-PrinterDriver -Name "Print Driver 1 Name Installed" -InfPath "C:\WINDOWS\System32\DriverStore\FileRepository\driverfile1\driverinf1.inf"
        Remove-Item $TargetDir\driverfile1.zip
    #Driver2 Driver2 Install
        Invoke-WebRequest -Uri "https://bloblocal.blob.core.windows.net/folder/driverfile2.zip" -OutFile "$TargetDir\driverfile2.zip"
        Expand-Archive -LiteralPath $TargetDir\driverfile2.zip -DestinationPath C:\PrintDrivers
        pnputil /add-driver $TargetDir\driverfile2\driverinf2.inf
        Add-PrinterDriver -Name "Print Driver 2 Name Installed" -InfPath "C:\WINDOWS\System32\DriverStore\FileRepository\driverfile2\driverinf2.inf"
        Remove-Item $TargetDir\driverfile2.zip
    #Driver3 Driver3 Install
        Invoke-WebRequest -Uri "https://bloblocal.blob.core.windows.net/folder/driverfile3.zip" -OutFile "$TargetDir\driverfile3.zip"
        Expand-Archive -LiteralPath $TargetDir\driverfile3.zip -DestinationPath C:\PrintDrivers
        pnputil /add-driver $TargetDir\driverfile3\driverinf3.inf
        Add-PrinterDriver -Name "Print Driver 3 Name Installed" -InfPath "C:\WINDOWS\System32\DriverStore\FileRepository\driverfile3\driverinf3.inf"
        Remove-Item $TargetDir\driverfile3.zip
}

$PrinterSearch = Get-Printer
$PortSearch = Get-PrinterPort

If ($PrinterSearch.Name -notcontains 'printer1'){
    If($PortSearch.Name -notcontains 'xxx.xxx.xxx.xxx'){
        add-printerport -name "xxx.xxx.xxx.xxx" -printerhostaddress "xxx.xxx.xxx.xxx"
    }
    add-printer -name "printer1" -drivername "Print Driver 1 Name Installed" -port "xxx.xxx.xxx.xxx"
}
If ($PrinterSearch.Name -notcontains 'printer2'){
    If($PortSearch.Name -notcontains 'xxx.xxx.xxx.xxx'){
        add-printerport -name "xxx.xxx.xxx.xxx" -printerhostaddress "xxx.xxx.xxx.xxx"
    }
    add-printer -name "printer2" -drivername "Print Driver 2 Name Installed" -port "xxx.xxx.xxx.xxx"
}
If ($PrinterSearch.Name -notcontains 'printer3'){
    If($PortSearch.Name -notcontains 'xxx.xxx.xxx.xxx'){
        add-printerport -name "xxx.xxx.xxx.xxx" -printerhostaddress "xxx.xxx.xxx.xxx"
    }
    add-printer -name "printer3" -drivername "Print Driver 3 Name Installed" -port "xxx.xxx.xxx.xxx"
}
else{
write-host ""
}