#set default variables
$appToUninstall = "keyword"
$appList = ""
[Int]$numberOfMatches = 0
#prompt for keyword of program to uninstaller if it hasn't been manually changed in the script above
if ($appToUninstall -eq "keyword"){
  $appToUninstall = Read-Host "Enter keyword of program you wish to uninstall"
}
#create an array of apps from the registry that match the keyword
function Search-Apps{
  #path for uninstallers for both 32 and 64 bit programs
  $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
  #create an array of uninstallable objects from the registry that contain the supplied keyword
  $global:appList = Get-ChildItem -Path $RegPath | Get-ItemProperty | Where-Object {$_.DisplayName -match $appToUninstall }
  #number of matching programs
  $global:numberOfMatches = $appList.displayName.count
}

Search-Apps

#if there are no matches ask for another keyword
while($numberOfMatches -eq 0){
  $appToUninstall = Read-Host "There were no programs that matched the entered keyword. Please enter a new keyword"
  Search-Apps
  }
#display the number of matching programs
Write-Output "there are $numberOfMatches installed programs that match"
#display the list of matching prgrams with thier index value
$indexLineValue = 0
Write-Output $appList.displayName | % {“$indexLineValue $_”;$indexLineValue++}
#function that uninstalls the programs that are passed in as an array. Silently if possible
function Uninstall-Program($uninstallList){
  ForEach ($version in $uninstallList) {
    If ($version.QuuietUninstallString) {
        $uninst = $version.QuuietUninstallString
        Start-Process cmd -ArgumentList "/c $uninst"
     }
     If ($version.UninstallString) {
         $uninst = $version.UninstallString
         Start-Process cmd -ArgumentList "/c $uninst /s /q /norestart" -NoNewWindow
     }
   }
}

#confirm uninstallation of all programs
$confirmation = Read-Host "Would you like to uninstall all programs? [y/n]"
if ($confirmation -eq 'y') { #if confirmed silently uninstall all programs
  Uninstall-Program($appList)
  #verify that the app was uninstalled by searching the registry for it
  Search-Apps
  if ($numberOfMatches -eq 0){
    Write-Output "$appList.displayName has been successfully uninstalled or the uninstaller has launched"
  }else{
    Write-Output "An error has occured. Please try again."
  }
}else { #if you do not want to uninstall all the apps in the list offer to install just one of them
  $confirmation = Read-Host "Would you like to a specific program from the list? [y/n]"
    if ($confirmation -eq 'y') {
      $singleAppToDeleteIndex = Read-Host "enter the number at the beggining of the line of the app you would like to uninstall"
      $singleAppToDelete = $appList[$singleAppToDeleteIndex]
      $confirmation = Read-Host "You have selected to uninstall" $singleAppToDelete.displayName". Proceed? [y/n]"
        if ($confirmation -eq 'y') {
          $deleteAppName = $singleAppToDelete.displayName
          Uninstall-Program($singleAppToDelete)
          Search-Apps
            if ($appList | Where-Object ($_.displayName -eq $deleteAppName)){
            Write-Output "An error has occured. Please try again."
          }else{
            Write-Output "$deleteAppName has been successfully uninstalled or the uninstaller has launched"
            }
        }else { #if n was entered in response to the confirmation prompt
          Write-Output "No changes have been made to the system"
        }
      }else { #if n was entered in response to the confirmation prompt
        Write-Output "No changes have been made to the system"
      }
}
