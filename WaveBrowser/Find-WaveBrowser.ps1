$ErrorActionPreference = 'SilentlyContinue'
$badprocs=get-process | ?{$_.name -like 'Wave*Browser*'} | select -exp Id;

if ($badprocs){
	Foreach ($badproc in $badprocs){
		echo 'INFECTED'
		exit
	}
}

$stasks = schtasks /query /fo csv /v | convertfrom-csv | ?{$_.TaskName -like 'Wavesor*'} | select -exp TaskName

if ($stasks){
	Foreach ($task in $stasks){
		echo 'INFECTED'
		exit
	}
}

$badDirs = 'C:\Users\*\Wavesor Software',
'C:\Users\*\Downloads\Wave Browser*.exe',
'C:\Users\*\AppData\Local\WaveBrowser',
'C:\Windows\System32\Tasks\Wavesor Software_*',
'C:\WINDOWS\SYSTEM32\TASKS\WAVESORSWUPDATERTASKUSER*CORE',
'C:\WINDOWS\SYSTEM32\TASKS\WAVESORSWUPDATERTASKUSER*UA',
'C:\USERS\*\APPDATA\ROAMING\MICROSOFT\WINDOWS\START MENU\PROGRAMS\WAVEBROWSER.LNK',
'C:\USERS\*\APPDATA\ROAMING\MICROSOFT\INTERNET EXPLORER\QUICK LAUNCH\WAVEBROWSER.LNK',
'C:\USERS\*\APPDATA\ROAMING\MICROSOFT\INTERNET EXPLORER\QUICK LAUNCH\USER PINNED\TASKBAR\WAVEBROWSER.LNK'

start-sleep -s 2;

ForEach ($badDir in $badDirs) {
	$dsfolder = gi -Path $badDir -ea 0| select -exp fullname;
	if ( $dsfolder) {
		echo 'INFECTED'
		exit
	}
}

$checkhandle = gi -Path 'C:\Users\*\AppData\Local\WaveBrowser' -ea 0| select -exp fullname;

if ($checkhandle){
	echo 'INFECTED'
	exit
}

$badreg=
'Registry::HKU\*\Software\WaveBrowser',
'Registry::HKU\*\SOFTWARE\CLIENTS\STARTMENUINTERNET\WaveBrowser.*',
'Registry::HKU\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\APP PATHS\wavebrowser.exe',
'Registry::HKU\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\UNINSTALL\WaveBrowser',
'Registry::HKU\*\Software\Wavesor',
'Registry::HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE\WavesorSWUpdaterTaskUser*UA',
'Registry::HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE\WavesorSWUpdaterTaskUser*Core',
'Registry::HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE\Wavesor Software_*'

Foreach ($reg in $badreg){
	$regoutput= gi -path $reg | select -exp Name
	if ($regoutput){
		echo 'INFECTED'
		exit
	}
	else {}
}

$badreg2=
'Registry::HKU\*\Software\Microsoft\Windows\CurrentVersion\Run',
'Registry::HKU\*\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run'

Foreach ($reg2 in $badreg2){
	$regoutput= gi -path $reg2 -ea silentlycontinue | ? {$_.Property -like 'Wavesor SWUpdater'} | select -exp Property ;
	$regpath = gi -path $reg2 -ea silentlycontinue | ? {$_.Property -like 'Wavesor SWUpdater'} | select -exp Name ;
	Foreach($prop in $regoutput){
		If ($prop -like 'Wavesor SWUpdater'){
			echo 'INFECTED'
			exit
		}
	}
}

echo 'CLEAN'