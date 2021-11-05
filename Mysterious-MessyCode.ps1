function Delete-Things {

    $app = Read-Host -Prompt "What do you want to nuke?"
    $app = "*" + $app + "*"

    $UninstallPaths = Get-ChildItem -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Get-ItemProperty |
        Where-Object {$_.DisplayName -like $app} |
        Select-Object -Property DisplayName, UninstallString, QuietUninstallString
   
    if ($UninstallPaths.count -eq 0){
        Write-Output "No results found. Try again."
        return
    }

    Write-Host ($UninstallPaths.count.ToString() + " results found.")
   
    ForEach($deleteThis in $UninstallPaths){
        $confirm = Read-Host -Prompt ("Do you want to remove " + $deleteThis.DisplayName + "? (Y/N)")
       
        if ($confirm.ToUpper() -ne "Y") { continue }

        if ($deleteThis.QuietUninstallString.Length -gt 0) {
            $uninstStr = $deleteThis.QuietUninstallString
        }
        elseif ($deleteThis.UninstallString -like "msiexec*") {
            $uninstStr = $deleteThis.UninstallString + " /qn /norestart"
               
        } else {
            $uninstStr = $deleteThis.UninstallString
        }
           
        Write-Host $uninstStr
        & cmd /c $uninstStr
    }
}