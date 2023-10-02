<#
Author: Sky Sparnaaij
1.0 :Retrieves: Processor info,Graphics card description,Ram info,Disk info,Operating system info,IP addresses,Mac address,TPM,User logged in,Bios info
StartDate: 10:19 , 17-7-2023
End: 12:54, 19-7-2023

2.0: Give users list with options on what they can do, Let users retrieve all computers info through entire company & or choose specific departments
Start: 9:32, 20-7-2023
End: 11:27, 24-7-2023

2.1: Outputs computer info into txt file\whatever file.
Start: 11:45, 24-7-2023
End: 12:14, 25-7-2023

3.0: Adds a forced update function, Location finder code, TPM 2.0 checker code, Windows 11 compatible code, Last user on computer code/function, Troll function, and 2 other versions. A server compatible script & NON AD version
Start: 28-9-2023
End:
#>

#Requires -RunAsAdministrator

Set-StrictMode -version latest
#start
Write-Host ""
Write-Host "========== Welcome, This is a general computer script.========== " -ForegroundColor Yellow
Write-Host "Author: Sky" -ForegroundColor Green
Write-Host "Version: 3.0 AD" -ForegroundColor Green
Write-Host "================================================================="-ForegroundColor Yellow
Write-Host
Write-Host ":1: Retrieve specific computer's info."-ForegroundColor Green
Write-Host ":2: Retrieve specific departments all computer info. "-ForegroundColor Green
Write-Host ":3: Retrieve entire company's computer info. Takes Extremely long!" -ForegroundColor Green
Write-Host ":4: Troll a user by sending a fake 'you got hacked' message. " -ForegroundColor Green
Write-Host ":5: Force update and restart a specific computer."-ForegroundColor Green
Write-Host ":6: Windows 11 compatibillity check. (also checks some other stuff)" -ForegroundColor Green
Write-Host ":7: Software deployment on computer."-ForegroundColor Green
Write-Host ":8: Delete security logs."-ForegroundColor Green
Write-Host ":9: MacAdres to IP & ping test."-ForegroundColor Green
Write-Host ":10: Retrieve event logs."-ForegroundColor Green
Write-Host ":11: Uninstall software."-ForegroundColor Green
Write-Host ":12: Windows update at specific time."-ForegroundColor Green
Write-Host ":0: Quit"-ForegroundColor Green
Write-Host ""
Write-Host "================================================================="-ForegroundColor Yellow
Write-Host ""
$List1 = Read-Host "CHOOSE NUMBER ->"

#looks at what you chose at $list1

if ($List1 -eq '1') {

#asks what computer
Write-Host "Which computer's info do you want to retrieve?"
Write-Host "Put in computer name or special host names like they are in Active Directory. "
$computer = Read-Host "COMPUTER NAME HERE->" 
Write-Host ""

#checklists
Write-Host "First Im gonna run some checks to ensure this computer exists and or running yes or no." -ForegroundColor Yellow
Write-Host ""
Write-Host ""
Write-Host "=== Check 1 Running ==" -ForegroundColor Green

#Check1 Exists in AD
try {
$computerAD = Get-ADComputer $computer -ErrorAction Stop | Select-Object cn
Write-Host ""
Write-Host "$computer exists in AD" -ForegroundColor Green
Write-Host ""
Write-Host "=== Check 1 Passed ===" -ForegroundColor Green
Write-Host ""
Write-Host ""
Write-Host "=== Check 2 Running ==" -ForegroundColor Green
} catch {
Write-Host ""
Write-Host "Computer not found in AD!!!!" -ForegroundColor Red
Write-Host ""
Write-Host "=== Check 1 Failed ===" -ForegroundColor Red
Write-Host "Because computer does not exist, script quits!" -ForegroundColor Red
exit
}
Write-Host ""

#check2 Ping test, sees if computer is on or off
$pingtest = Test-Connection -ComputerName $computer -Quiet -ErrorAction SilentlyContinue
if ($pingtest) {
Write-Host ($computer + " is pingable") -ForegroundColor Green
Write-Host ""
Write-Host "=== Check 2 Passed ===" -ForegroundColor Green
Write-Host ""
Write-Host "=== ALL CHECKS PASSED ===" -ForegroundColor Green
} else {
Write-Host ($computer + " is not pingable") -ForegroundColor Red
Write-Host ""
Write-Host "=== Check 2 Failed ===" -ForegroundColor Red
Write-Host
Write-Host "Because computer is not pingable, script quits!" -ForegroundColor Red
exit
}
Write-Host ""
Write-Host ""

#Starts retrieving info from computer
Write-Host ("Retrieving info from " + $computer ) -ForegroundColor Yellow
Write-Host ""
#makes new directory and file for computer info to be stored into
New-Item -Path 'C:\ComputerInfo' -ItemType Directory
New-Item C:\ComputerInfo\ComputerInfo.txt

Write-Host "PROCESSOR&GRAPHICS-CARD:" -ForegroundColor Yellow 
$CPU = Invoke-Command -ComputerName $computer -ScriptBlock {Get-CimInstance -ClassName Win32_Processor}
$Video = Invoke-Command -ComputerName $computer -ScriptBlock {Get-WmiObject win32_VideoController | Format-Table Description}
Write-Host "RAM:" -ForegroundColor Yellow 
$Ram = Invoke-Command -ComputerName $computer -ScriptBlock {Get-WmiObject win32_PhysicalMemory | Format-Table Manufacturer, Model, Tag, FormFactor, Speed}
#Write-Host "DISK:"-ForegroundColor Yellow
$DISK = Invoke-Command -ComputerName $computer -ScriptBlock {Get-CimInstance -ClassName Win32_LogicalDisk}
Write-Host "DISK&OPERATING-SYSTEM-INFO:" -ForegroundColor Yellow 
$OS = Invoke-Command -ComputerName $computer -ScriptBlock {Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property SerialNumber, Version}
Write-Host "IP_ADDRESS&MAC_ADDRESS:" -ForegroundColor Yellow
$ADDRESSES = Invoke-Command -ComputerName $computer -ScriptBlock {Get-WmiObject win32_networkadapterconfiguration | Format-Table description, IPAddress, macaddress}
Write-Host "TPM:" -ForegroundColor Yellow
$TPM = Invoke-Command -ComputerName $computer -ScriptBlock {Get-WmiObject -Namespace root/cimv2/security/microsofttpm -Class Win32_TPM | Format-Table SpecVersion}
Write-Host "USER LOGGED IN:" -ForegroundColor Yellow
$UserLoggedIn = Invoke-Command -ComputerName $computer -ScriptBlock {Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName | Format-table Name, UserName}
Write-Host "BIOS INFO:" -ForegroundColor Yellow
$Bios = Invoke-Command -ComputerName $computer -ScriptBlock {Get-ComputerInfo -Property *BIOS* | Format-Table BiosFirmwareType, BiosManufacturer, BiosName, BiosSeralNumber, BiosVersion}
Write-Host "LOGON" -ForegroundColor Yellow
$logon = Get-ADComputer $computer -Properties * | Format-Table lastlogondate

#puts the output into a txt file
'CPU & Graphics card:' | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$CPU | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$Video | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
'Ram:' | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$Ram | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
'Disk & OS:' | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$DISK | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$OS | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
'Mac & IP addresses:' | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$ADDRESSES | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
'TPM:' | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$TPM | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
'User logged in:' | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$UserLoggedIn | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
'Bios:' | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$Bios | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
'Last Loggon:' | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append
$logon | Out-File -FilePath "C:\ComputerInfo\ComputerInfo.txt" -Append

Write-Host ""
Write-Host "ComputerInfo retrieved" -ForegroundColor Yellow
Write-Host "COMPUTER INFO -> C:\ComputerInfo\" -ForegroundColor Yellow
Write-Host "DONT FORGET DELETING FOLDER AFTER USE!" -ForegroundColor Red
pause
}

if ($List1 -eq '2') {
#2nd menu
Write-Host ""
Write-Host "Which department do you want all of it's computers info?" -ForegroundColor Yellow
Write-Host ""
Write-Host ""
Write-Host "===================="
Write-Host ""
Write-Host ":1: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":2: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":3: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":4: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":5: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":6: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":7: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":8: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":9: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":10: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ":11: FILL IN OWN DEPARTMENTS, LINE 165"
Write-Host ""
Write-Host "===================="
Write-Host ""
$OU = Read-host "CHOOSE NUMBER -> "
Write-Host ""
Write-Host "For each computer I'm going to run 2 checks and then giving you info, then continue to the next computer" -ForegroundColor Yellow

#makes new file
New-Item C:\S1772023K.txt

#many OU for each department
if ($OU -eq '1') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU" | select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '2') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '3') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '4') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '5') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '6') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '7') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '8') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '9') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '10') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "PUT IN OWN OU"| select -expandproperty name | Out-File  "C:\S1772023K.txt"
}
if ($OU -eq '11') {
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES' -or Name -like '*-iops'} -SearchBase "PUT IN OWN OU" | select -expandproperty name | Out-File  "C:\S1772023K.txt" 
}

$computerss = Get-Content -Path C:\S1772023K.txt

Write-Host ""
Write-Host ""
Write-Host ""

#makes a new directory
New-Item -Path C:\ComputerInfo -ItemType Directory

#goes into a loop through all given computers that have been set in the txt file S1772023K
foreach ($Departmentcomputer in $computerss ){

#checklists
Write-Host "=== Check 1 Running ==" -ForegroundColor Green

#Check1
try {
$computerAD = Get-ADComputer $Departmentcomputer -ErrorAction Stop 
Write-Host ""
Write-Host "$Departmentcomputer exists in AD" -ForegroundColor Green
Write-Host ""
Write-Host "=== Check 1 Passed ===" -ForegroundColor Green
Write-Host ""
Write-Host ""
Write-Host "=== Check 2 Running ==" -ForegroundColor Green
} catch {
Write-Host ""
Write-Host "Computer not found in AD!!!!" -ForegroundColor Red
Write-Host ""
Write-Host "=== Check 1 Failed ===" -ForegroundColor Red
Write-Host "Because computer does not exist, script continues with next computer!" -ForegroundColor Red
}
Write-Host ""

#check2
$pingtest = Test-Connection -ComputerName $Departmentcomputer -Quiet -ErrorAction SilentlyContinue
if ($pingtest) {
Write-Host ("Computer is pingable") -ForegroundColor Green
Write-Host ""
Write-Host "=== Check 2 Passed ===" -ForegroundColor Green
Write-Host ""
Write-Host "=== ALL CHECKS PASSED ===" -ForegroundColor Green

#makes for each computer their own file which then their hardware info will be placed into
New-Item -path C:\ComputerInfo\Computer-$Departmentcomputer.txt

#Hardware info
Write-Host "PROCESSOR&GRAPHICS-CARD:" -ForegroundColor Yellow 
$CPU = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-CimInstance -ClassName Win32_Processor}
$Video = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-WmiObject win32_VideoController | Format-Table Description}
Write-Host "RAM:" -ForegroundColor Yellow 
$Ram = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-WmiObject win32_PhysicalMemory | Format-Table Manufacturer, Model, Tag, FormFactor, Speed}
#Write-Host "DISK:"-ForegroundColor Yellow
$DISK = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-CimInstance -ClassName Win32_LogicalDisk}
Write-Host "DISK&OPERATING-SYSTEM-INFO:" -ForegroundColor Yellow 
$OS = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property SerialNumber, Version}
Write-Host "IP_ADDRESS&MAC_ADDRESS:" -ForegroundColor Yellow
$ADDRESSES = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-WmiObject win32_networkadapterconfiguration | Format-Table description, IPAddress, macaddress}
Write-Host "TPM:" -ForegroundColor Yellow
$TPM = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-WmiObject -Namespace root/cimv2/security/microsofttpm -Class Win32_TPM | Format-Table SpecVersion}
Write-Host "USER LOGGED IN:" -ForegroundColor Yellow
$UserLoggedIn = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName | Format-table Name, UserName}
Write-Host "BIOS INFO:" -ForegroundColor Yellow
$Bios = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-ComputerInfo -Property *BIOS* | Format-Table BiosFirmwareType, BiosManufacturer, BiosName, BiosSeralNumber, BiosVersion}
Write-Host "LOGON" -ForegroundColor Yellow
$logon = Get-ADComputer $Departmentcomputer -Properties * | Format-Table lastlogondate

'CPU & Graphics card:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$CPU | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$Video | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Ram:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$Ram | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Disk & OS:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$DISK | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$OS | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Mac & IP addresses:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$ADDRESSES | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'TPM:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$TPM | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'User logged in:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$UserLoggedIn | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Bios:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$Bios | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Last Loggon:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$logon | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append

Write-Host ""
Write-Host "ComputerInfo retrieved" -ForegroundColor Yellow
Write-Host "COMPUTER INFO -> C:\ComputerInfo\" -ForegroundColor Yellow
Write-Host "DONT FORGET DELETING FOLDER AFTER USE!" -ForegroundColor Red

} else {
#Computer not pingable, it will continue with next computer
Write-Host ("Computer is not pingable") -ForegroundColor Red
Write-Host ""
Write-Host "=== Check 2 Failed ===" -ForegroundColor Red
Write-Host
Write-Host "Because computer is not pingable, scriptcontinues with next computer!" -ForegroundColor Red

}
}
#removes txt file which contains all computers it had to go through the loop
Remove-Item C:\S1772023K.txt
}

if ($List1 -eq '3') {
#are you sure?
Write-Host ""
Write-Host ""
Write-Host "Are you sure you want to do this? This wil take a long time. Type y for yes, type n for no." -ForegroundColor Red
Write-Host ""
$YesNo = Read-Host "y or n -> "
Write-Host ""

if ($YesNo -eq 'n') {

Write-Host ""
Write-Host ""
Write-Host "Alrighty then, Script going to stop" -ForegroundColor Yellow
Write-Host ""
pause
exit
}
if ($YesNo -eq 'y') {
#Small warning
Write-Host ""
Write-Host ""
Write-Host "WARNING: THIS WILL TAKE EXTREMELY LONG! 20+ MINUTES." -ForegroundColor Red
Write-Host ""
Write-Host ""

New-Item C:\S1772023KY.txt
#goes to AD to find each and every computer and places them into txt file
Get-ADComputer -Filter {Name -Like 'FILL HERE OWN COMPUTER PRE-FIX NAMES' -or Name -like 'FILL HERE OWN COMPUTER PRE-FIX NAMES'} -SearchBase "FILL IN OWN OU" | select -expandproperty name | Out-File  "C:\S1772023KY.txt"
#goes looking what computers are in that file
$computerss = Get-Content -Path C:\S1772023KY.txt

New-Item -Path C:\ComputerInfo -ItemType Directory
#goes into a loop for each computer in that txt file 
foreach ($Departmentcomputer in $computerss ){

#checklists
Write-Host "=== Check 1 Running ==" -ForegroundColor Green

#Check1 Exists in AD
try {
$computerAD = Get-ADComputer $Departmentcomputer -ErrorAction Stop 
Write-Host ""
Write-Host "$Departmentcomputer exists in AD" -ForegroundColor Green
Write-Host ""
Write-Host "=== Check 1 Passed ===" -ForegroundColor Green
Write-Host ""
Write-Host ""
Write-Host "=== Check 2 Running ==" -ForegroundColor Green
} catch {
Write-Host ""
Write-Host "Computer not found in AD!!!!" -ForegroundColor Red
Write-Host ""
Write-Host "=== Check 1 Failed ===" -ForegroundColor Red
Write-Host "Because computer does not exist, script continues with next computer!" -ForegroundColor Red
}
Write-Host ""

#check2 Ping check
$pingtest = Test-Connection -ComputerName $Departmentcomputer -Quiet -ErrorAction SilentlyContinue
if ($pingtest) {
Write-Host ("Computer is pingable") -ForegroundColor Green
Write-Host ""
Write-Host "=== Check 2 Passed ===" -ForegroundColor Green
Write-Host ""
Write-Host "=== ALL CHECKS PASSED ===" -ForegroundColor Green

New-Item -path C:\ComputerInfo\Computer-$Departmentcomputer.txt

#Hardware info
Write-Host "PROCESSOR&GRAPHICS-CARD:" -ForegroundColor Yellow 
$CPU = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-CimInstance -ClassName Win32_Processor}
$Video = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-WmiObject win32_VideoController | Format-Table Description}
Write-Host "RAM:" -ForegroundColor Yellow 
$Ram = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-WmiObject win32_PhysicalMemory | Format-Table Manufacturer, Model, Tag, FormFactor, Speed}
#Write-Host "DISK:"-ForegroundColor Yellow
$DISK = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-CimInstance -ClassName Win32_LogicalDisk}
Write-Host "DISK&OPERATING-SYSTEM-INFO:" -ForegroundColor Yellow 
$OS = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property SerialNumber, Version}
Write-Host "IP_ADDRESS&MAC_ADDRESS:" -ForegroundColor Yellow
$ADDRESSES = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-WmiObject win32_networkadapterconfiguration | Format-Table description, IPAddress, macaddress}
Write-Host "TPM:" -ForegroundColor Yellow
$TPM = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-WmiObject -Namespace root/cimv2/security/microsofttpm -Class Win32_TPM | Format-Table SpecVersion}
Write-Host "USER LOGGED IN:" -ForegroundColor Yellow
$UserLoggedIn = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName | Format-table Name, UserName}
Write-Host "BIOS INFO:" -ForegroundColor Yellow
$Bios = Invoke-Command -ComputerName $Departmentcomputer -ScriptBlock {Get-ComputerInfo -Property *BIOS* | Format-Table BiosFirmwareType, BiosManufacturer, BiosName, BiosSeralNumber, BiosVersion}
Write-Host "LOGON" -ForegroundColor Yellow
$logon = Get-ADComputer $Departmentcomputer -Properties * | Format-Table lastlogondate

#outputs computer info into txt file
'CPU & Graphics card:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$CPU | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$Video | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Ram:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$Ram | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Disk & OS:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$DISK | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$OS | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Mac & IP addresses:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$ADDRESSES | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'TPM:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$TPM | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'User logged in:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$UserLoggedIn | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Bios:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$Bios | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
'Last Loggon:' | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append
$logon | Out-File -FilePath C:\ComputerInfo\Computer-$Departmentcomputer.txt -Append

Write-Host ""
Write-Host "ComputerInfo retrieved" -ForegroundColor Yellow
Write-Host "COMPUTER INFO -> C:\ComputerInfo\" -ForegroundColor Yellow
Write-Host "DONT FORGET DELETING FOLDER AFTER USE!" -ForegroundColor Red

} else {
#Computer not pingable, it will continue with next computer
Write-Host ("Computer is not pingable") -ForegroundColor Red
Write-Host ""
Write-Host "=== Check 2 Failed ===" -ForegroundColor Red
Write-Host
Write-Host "Because computer is not pingable, script continues with next computer!" -ForegroundColor Red
}
}
}
Remove-Item C:\S1772023KY.txt
}
#Troll script
if ($List1 -eq '4') {
Clear-Host
Write-Host "########################################" -ForegroundColor Red
Write-Host "So you wish to troll someone?" -ForegroundColor Green
Write-Host "########################################" -ForegroundColor Red
$TrollYesOrNo = Read-Host "Type 'Hell yeah' to continue "
Clear-Host
if ($TrollYesOrNo -eq 'Hell yeah') {
$Remotecomputer = Read-Host "What is the IP or computer name? "
Write-Host ""
$TextToWrite = Read-Host "What do you want the text to say? " #This is the text that will be displayed by the user
$Command = " cmd.exe"

# Creates a session to the wanted computer
$session = New-PSSession -ComputerName $Remotecomputer -Credential (Get-Credential)

Invoke-Command -Session $session -ScriptBlock {
param (
$Command,
$TextToWrite
)

Start-Process -FilePath $Command -Wait

Add-Type -AssemblyName System.Windows.Forms
[System.Winodws.Forms.SendKeyts]::SendWait("$TextToWrite{ENTER}")

} -ArgumentList $Command, $TextToWrite
Remove-PSSession $session
}
}

#Forced update function
if ($List1 -eq '5') {
Write-Host ""
$TargetComputer = Read-Host "What is the computers name you want to update? "
$credentials = Get-Credential

$UpdateScript = {
$service = Get-Service -Name "wuauserv" -ErrorAction SilentlyContinue

if ($service -eq $null) {
Write-Host "Im going to check if there are any updates available" -ForegroundColor green
Invoke-Expression "Start-Process -Wait -FilePath 'C:\Windows\System32\wupdmgr.exe' -ArgumentList '/detectnow'"
Write-Host "I checked if there are any updates available and will update"
} else {
Write-Host "There aren't any updates for this pc"
}
}
#invokes the script to the target computer
Invoke-Command -ComputerName $TargetComputer -ScriptBlock {$UpdateScript} -Credential $credentials
#magically restarts computers
Restart-Computer -ComputerName $TargetComputer -Wait -For PowerShell -Timeout 300 -Delay 2
}
#Winodws 11 compatibility check (+ current OS version check(+ uefi check(+ Secure boot(+ TPM))))
if ($List1 -eq '6') {
Write-Host ""
$W11Computer = Read-Host "So we're going to preform a w11 check, what is the computers name? "
Write-Host ""
Write-Host "Alright, let's check if TPM 2.0 is on this computer" -ForegroundColor Green
#TPM Check
$TpmStatus = Invoke-Command -ComputerName $W11Computer -ScriptBlock {Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm}
if ($TpmStatus) {
$tpmManufacturerVersion = [version]$tpmStatus.ManufacturerVersion
if ($tpmManufacturerVersion -ge [version]"2.0") {
Write-Host "YES, We have found an TPM 2.0 chip in here" -ForegroundColor Green
} else {
Write-Host "No TPM 2.0 chip here" -ForegroundColor Red
}
} else {
Write-Host "No TPM information found" -ForegroundColor Red
}
#Secure Boot Check
Write-Host ""
Write-Host "Let's check if Secure Boot is enabled" -ForegroundColor Green
Write-Host ""
$secureBootStatus = Invoke-Command -ComputerName $W11Computer -ScriptBlock {Get-WmiObject -Namespace "Root\StandardCimv2\ms_409" -Class Win32_ComputerSystem}
if ($secureBootStatus) {
if ($secureBootStatus.SecureBootEnabled) {
Write-Host "WE GOT SECURE BOOT ON HERE" -ForegroundColor Green
} else {
Write-Host "Nope, no secure boot" -ForegroundColor Red
}
} else {
Write-Host "No secure boot information" -ForegroundColor Red
}
#UEFI Firmware check
$firmwareType = Invoke-Command -ComputerName $W11Computer -ScriptBlock {(Get-WmiObject -Class Win32_ComputerSystem).FirmwareType}
if ($firmwareType -eq 2) {
Write-Host "We got UEFI on here" -ForegroundColor Green
} else {
Write-Host "This thing still on Legacy mode or something" -ForegroundColor Red
}
#CPU Check
Write-Host ""
Write-Host "Let's see if the CPU can handle Windows 11"
Write-Host ""
$cpuInfo = Invoke-Command -ComputerName $W11Computer -ScriptBlock {Get-WmiObject -Class Win32_Processor}
if ($cpuInfo) {
$cpuFeatures = $cpuInfo.FeatureSet
if ($cpuFeatures -like "*NX*") {
Write-Host "CPU Can run Windows 11"-ForegroundColor Green
} else {
Write-Host "CPU can't run Windows 11"-ForegroundColor Red
}
} else {
Write-Host "No CPU info"-ForegroundColor Red
}
Write-Host ""
Write-Host "So if all 4 checks were good then you're good to go" -ForegroundColor Green
pause
exit
}

#Software Deployment on computer
if ($List1 -eq '7') {
Write-Host ""
$softwareComputers = read-host "On which computer do you want to deploy something?"
Write-Host ""
Write-Host "=================================================================" -ForegroundColor Yellow
Write-Host "WHAT DO YOU WANT TO DEPLOY ON '$softwareComputers'? " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Yellow
Write-Host ":1: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host ":2: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host ":3: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host ":4: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host ":5: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host ":6: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host ":7: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Yellow
$List2 = Read-Host "CHOOSE NUMBER ->"

if ($List2 -eq '1') {
$installerPath = ""
} elseif ($List2 -eq '2') {
$installerPath = ""
} elseif ($List2 -eq '3') {
$installerPath = ""
} elseif ($List2 -eq '4') {
$installerPath = ""
} elseif ($List2 -eq '5') {
$installerPath = ""
} elseif ($List2 -eq '6') {
$installerPath = ""
} elseif ($List2 -eq '7') {
$installerPath = ""
}
$installerArguments = "/qn" 
Invoke-Command -ComputerName $remoteComputer -ScriptBlock {
param (
$installerPath,
$installerArguments
)

# Start the installation process
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $installerPath $installerArguments" -Wait

# Check the exit code of the installation
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
Write-Host "Software installation on $env:COMPUTERNAME completed successfully."
} else {
Write-Host "Software installation failed"
}
} -ArgumentList $installerPath, $installerArguments

}

#Delete security logs
if ($List1 -eq '8') {
# Here you can choose what computer
$EventLogComputer = Read-Host "What is the name of the locked down computer? "
# The name of the event stuff
$logName = "Security"
# Create a PowerShell session to the remote computer
$session = New-PSSession -ComputerName $EventLogComputer -Credential (Get-Credential)
# Use Invoke-Command to clear the specified event log on the remote computer
Invoke-Command -Session $session -ScriptBlock {
param (
$logName
)
# Clears the specified event log
Clear-EventLog -LogName $logName
} -ArgumentList $logName
# Close the PowerShell session
Remove-PSSession $session
}

#Macadres resolver
if ($List1 -eq '9') {
Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "             ADRESS LOOKUP" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ":1: Macadress" -ForegroundColor Green
Write-Host ":2: Ipv4 adress" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
$Adresschoice = Read-Host "Choose number"
    
if ($Adresschoice -eq '1') {
New-Item 'C:\MacAdresses\' -ItemType Directory
New-Item 'C:\MacAdresses\MacAdresses.txt' -ItemType File
Clear-Host
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "First put the adresses in this file:" -ForegroundColor Green
Write-Host "C:\MacAdresses\Adresses.txt" -ForegroundColor Green
Write-Host "Put the adresses under each other" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
Pause
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Now we can start" -ForegroundColor Green 
Write-Host "========================================" -ForegroundColor Yellow
    
#Looks at all adresses (Fill in like 60-e9-aa-dd-50-03)
$MacAdressFile = Get-Content -Path C:\MacAdresses\MacAdresses.txt
#For each adres converts mac to ip and pings to see if exists
foreach ($MacAdres in $MacAdressFile) {
$MacTest = arp -a | select-string "$MacAdres" |% { $_.ToString().Trim().Split(" ")[0] }
if($MacTest) {
Write-Host "$MacAdres exist!" -ForegroundColor Green
} else {
Write-Host "$MacAdres does not exist!" -ForegroundColor Red
}
}
}

elseif ($Adresschoice -eq '2') {
New-Item 'C:\Adresses\' -ItemType Directory
New-Item 'C:\Adresses\Adresses.txt' -ItemType File
Clear-Host
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "First put the adresses in this file:" -ForegroundColor Green
Write-Host "C:\Adresses\Adresses.txt" -ForegroundColor Green
Write-Host "Put the adresses under each other" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
Pause
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Now we can start" -ForegroundColor Green 
Write-Host "========================================" -ForegroundColor Yellow
    
#Does a ping test to see if it lives or if its not alive
$AdressesFile = Get-Content -Path C:\Adresses\Adresses.txt
foreach ($Adresses in $AdressesFile) {
$pingtest = Test-Connection -ComputerName $Adresses -Quiet -ErrorAction SilentlyContinue
    
if($pingtest) {
Write-Host "$Adresses exist!" -ForegroundColor Green
} else {
Write-Host "$Adresses does not exist!" -ForegroundColor Red
}
}  
} 
}


#Warning event log retriever#

if ($List1 -eq '10'){
Write-Host = ""
Write-Host = "==============================" -forgroundcolor yellow
Write-Host = "WHAT LOGS DO YOU WANT?" -forgroundcolor green
Write-Host = "==============================" -forgroundcolor yellow
Write-Host = ":1: Application" -forgroundcolor green 
Write-Host = ":2: System " -forgroundcolor green
Write-Host = ":3: Security" -forgroundcolor green
Write-Host = "==============================" -forgroundcolor yellow
$List3 = Read-Host "CHOOSE NUMBER "
Write-Host = ""
Write-Host = "==============================" -forgroundcolor yellow
Write-Host = "WHAT LEVEL LOGS?" -forgroundcolor green
Write-Host = "==============================" -forgroundcolor yellow
Write-Host = ":1: Warning" -forgroundcolor green 
Write-Host = ":2: Error " -forgroundcolor green
Write-Host = ":3: Critical" -forgroundcolor green
Write-Host = "==============================" -forgroundcolor yellow
$List4 = Read-Host "CHOOSE NUMBER "
#If list with log names
if ($list3 -eq '3') {
# Define the log name (e.g., "Application", "System", "Security", etc.)
$logName = "System"
} elseif ($list3 -eq '2') {
$logName = "System" 
} elseif ($list3 -eq '1') {
$logName = "Application" 
}
#If list with levels of event
if ($List4 -eq '1') {
$warningEvents = Get-WinEvent -LogName $logName -FilterHashtable @{
LogName = $logName
Level = 3  # Warning events have a level of 3
}
} elseif ($List4 -eq '2') {
$warningEvents = Get-WinEvent -LogName $logName -FilterHashtable @{
LogName = $logName
Level = 4  # Warning events have a level of 3
}
} elseif ($List4 -eq '3') {
$warningEvents = Get-WinEvent -LogName $logName -FilterHashtable @{
LogName = $logName
Level = 5  # Warning events have a level of 3
}
} 
# Display the warning events
foreach ($event in $warningEvents) {
$eventTime = $event.TimeCreated
$eventMessage = $event.Message
Write-Host "Event Time: $eventTime" -forgroundcolor green
Write-Host "Event Message: $eventMessage" -forgroundcolor green
Write-Host "==============================" -forgroundcolor yellow
}
}

#Uninstall software#
if ($List1 -eq '11') {
Write-Host = ""
Write-Host = "==============================" -forgroundcolor yellow
# Define the list of remote computer names where you want to uninstall the software
$UninstallSoftComputer = Read-Host = "Which computer? "
Write-Host = ""
Write-Host "=================================================================" -ForegroundColor Yellow
Write-Host "WHAT DO YOU WANT TO UNINSTALL ON '$UninstallSoftComputer'? " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Yellow
Write-Host ":1: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host ":2: PUT IN OWN SOFTWARE "-ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Yellow
# Define the number of the software you want to uninstall
$softwareName = Read-Host "CHOOSE NUMBER ->"
#if list with uninstall path 
if ($softwareName -eq '1') {
$uninstallCommand = ""
} elseif ($softwareName -eq '2') {
$uninstallCommand = ""
}

# Use PowerShell Remoting to uninstall the software
Invoke-Command -ComputerName $UninstallSoftComputer -ScriptBlock {
param (
$softwareName,
$uninstallCommand
)
# Check if the software is installed before attempting to uninstall
if (Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $softwareName }) {
# Start the uninstallation process
Start-Process -FilePath $uninstallCommand -ArgumentList "/S" -Wait

# Check the exit code of the uninstaller
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
write-Host "Software $softwareName uninstalled successfully on $env:COMPUTERNAME."
} else {
Write-Host "Uninstallation of $softwareName on $env:COMPUTERNAME failed with exit code $exitCode."
}
} else {
Write-Host "Software $softwareName is not installed on $env:COMPUTERNAME."
}
} -ArgumentList $softwareName, $uninstallCommand
}


#Windows update at specific time#

if ($List1 -eq '12'){
Write-Host = ""
Write-Host = "==============================" -forgroundcolor yellow
Write-Host = "WHAT TIME UPDATE & REBOOT?" -forgroundcolor green
Write-Host = "==============================" -forgroundcolor yellow
Write-Host = ":1: UPDATE: 14:00 REBOOT: 14:45" -forgroundcolor green
Write-Host = ":2: UPDATE: 15:00 REBOOT: 15:45 " -forgroundcolor green
Write-Host = ":3: UPDATE: 17:00 REBOOT: 17:45" -forgroundcolor green
Write-Host = "==============================" -forgroundcolor yellow
$List5 = Read-Host "CHOOSE NUMBER "
Write-Host = ""
# Define the time at which you want to start the update (24-hour format, e.g., 02:00 PM)
# Define the time at which you want to schedule the reboot (24-hour format, e.g., 02:30 PM)
if ($List5 -eq '1') {
$updateTime = "14:00"
$rebootTime = "14:45"
} elseif ($List5 -eq '2') {
$updateTime = "15:00"
$rebootTime = "15:45"
} elseif ($List5 -eq '3') {
$updateTime = "17:00"
$rebootTime = "17:45"
}
# Calculate the date for today
$today = Get-Date

# Calculate the full update time and reboot time for today
$updateDateTime = $today.Date.Add([TimeSpan]::Parse($updateTime))
$rebootDateTime = $today.Date.Add([TimeSpan]::Parse($rebootTime))

# Calculate the time delay for the reboot (in seconds)
$delayInSeconds = [math]::Round(($rebootDateTime - $updateDateTime).TotalSeconds)

# Create a scheduled task for the update and reboot
$taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "Invoke-WindowsUpdate; Start-Sleep -Seconds $delayInSeconds; Restart-Computer -Force"
$taskTrigger = New-ScheduledTaskTrigger -Once -At $updateDateTime
Register-ScheduledTask -TaskName "UpdateAndReboot" -Action $taskAction -Trigger $taskTrigger

# Output information about the scheduled task
Write-Host "Scheduled task 'UpdateAndReboot' created."
Write-Host "The update will start at $updateTime and the computer will reboot at $rebootTime."
}


#Speaks for its own
if ($List1 -eq '0') {
Write-Host ""
Write-Host "Script wil stop!" -ForegroundColor Red
pause
exit
}
