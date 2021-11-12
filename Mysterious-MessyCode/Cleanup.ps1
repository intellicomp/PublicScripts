function Get-ApplicationUninstallCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ApplicationName
    )

    $Paths = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'

    $Uninstallers = (Get-ChildItem -Path $Paths | Where-Object { $_.GetValue('DisplayName') -ilike "*$ApplicationName*"})
    $UninstallInformation = New-Object -TypeName "System.Collections.ArrayList"
    foreach ($U in $Uninstallers) {
        $Object = [PSCustomObject]@{
            DisplayName = $U.GetValue('DisplayName')
            UninstallString = $U.GetValue('UninstallString')
            QuietUninstallString = $U.GetValue('QuietUninstallString')
        }
        $UninstallInformation.Add($Object) | Out-Null
    }
    Return $UninstallInformation
}

function Uninstall-Application {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $QuietUninstallString,
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $UninstallString
    )

    if ($QuietUninstallString) {
        foreach ($US in $QuietUninstallString) {
            if ($PSCmdlet.ShouldProcess($US)) {
                & C:\Windows\System32\cmd.exe /c $US
            }
        }
    } elseif($UninstallString) {
        foreach ($US in $UninstallString) {
            if ($PSCmdlet.ShouldProcess($US)) {
                & C:\Windows\System32\cmd.exe /c $US
            }
        }
    } else {
        Write-Warning -Message 'No uninstall string was provided.'
    }
}


PS C:\Users\Work> Get-ApplicationUninstallCommand -ApplicationName '7-zip' | Uninstall-Application

Confirm
Are you sure you want to perform this action?
Performing the operation "Uninstall-Application" on target ""C:\Program Files\7-Zip-Zstandard\Uninstall.exe"".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
