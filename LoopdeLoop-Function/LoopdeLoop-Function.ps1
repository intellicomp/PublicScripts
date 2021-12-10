$filext = '*.dll','*.exe','*.aspx','*.ascx'
$srcparent = 'C:\program files\software', 'C:\inetpub\software'
$destparent = "D:\temp"

Function Copy-File ($filetocopy) {
$Destination = $filetocopy.directory.fullname.replace('C:',$destparent)
    If (!((Test-Path $Destination))) {New-Item -ItemType Directory $Destination}
    Copy-Item $filetocopy.fullname -Destination $Destination

}

foreach ($filetype in $filext) 
    {
    foreach ($src in $srcparent) {
        $filestocopy = Get-ChildItem -Path $src -Filter $filetype -Recurse -Force
            $filestocopy | % {Copy-File $_}
        }
    }
