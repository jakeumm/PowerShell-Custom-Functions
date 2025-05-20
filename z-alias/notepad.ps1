function notepad {
    param (
        [string]$file = ""
    )
	$notepadInstall = "C:\Program Files\Notepad++\notepad++.exe"
	if (!(Test-Path $notepadInstall)) {$notepadInstall = "notepad.exe"}
	
    Start-Process $notepadInstall -ArgumentList $file
}