function Get-GroupPolicy {
    <#
    .SYNOPSIS
    One liner to refresh Group Policy, capture a GPResult report, and open it.

    .DESCRIPTION
    Runs gpupdate.exe /force, then gpresult.exe /h <file>.  
	If you omit –Path, the report is saved under:
		$Env:LOCALAPPDATA\Custom-Functions\Get-GroupPolicy\<timestamp>-GPResult.html

	.PARAMETER Path
	(Optional) Folder *or* full file path.  
	If you pass a folder, the report is written inside that folder.  
	If you omit Path, the default folder is:
	$Env:LOCALAPPDATA\Custom-Functions\Get-GroupPolicy
	
	.PARAMETER Name
	(Optional) File name for the HTML report.  
	If omitted, a time‑stamped name like 2025‑05‑05‑135422‑GPResult.html is used.
	
	.EXAMPLE
	Get-GroupPolicy
	Refreshes policy, saves the report to the default folder, and opens it.
	
	.EXAMPLE
	Get-GroupPolicy -Path 'C:\Temp\'
	Refreshes policy and writes the report to C:\Temp\yyyy-MM-dd-HHmmss-GPresult.html'
	
	.EXAMPLE
	Get-GroupPolicy -Path 'C:\Temp\' -Name 'My-GP.html'
	Refreshes policy and writes the report to C:\Temp\My-GP.html'
	
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path,

        [Parameter(Position = 1)]
        [string]$Name
    )

    # ----- Default locations (always ensured) -------------------------------
    $CustomFunctionDir = Join-Path $Env:LOCALAPPDATA 'Custom-Functions'
    $GroupPolicyDir    = Join-Path $CustomFunctionDir 'Get-GroupPolicy'
    foreach ($dir in @($CustomFunctionDir, $GroupPolicyDir)) {
        if (-not (Test-Path $dir -PathType Container)) {
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
        }
    }
    # ----- Decide folder & file name ----------------------------------------
    if ([string]::IsNullOrWhiteSpace($Path)) {                    # 1. No -Path
        $folder = $GroupPolicyDir
    }
    elseif ([IO.Path]::HasExtension($Path)) {                     # 2. -Path is file
        $folder = Split-Path $Path
        if (-not (Test-Path $folder -PathType Container)) {
            throw "Directory '$folder' does not exist."
        }
        if (-not $Name) { $Name = Split-Path $Path -Leaf }
    }
    else {                                                        # 3. -Path is folder
        if (-not (Test-Path $Path -PathType Container)) {
            throw "Directory '$Path' does not exist."
        }
        $folder = $Path
    }

    # File name—timestamp if user didn’t supply one
    if ([string]::IsNullOrWhiteSpace($Name)) {
        $Name = "{0:yyyy-MM-dd-HHmmss}-GPResult.html" -f (Get-Date)
    }

    # Ensure the name ends in .html
    if (-not $Name.ToLower().EndsWith('.html')) { $Name += '.html' }

    $reportPath = Join-Path $folder $Name

    # ----- Refresh policy & capture report ----------------------------------
    Write-Verbose 'Running gpupdate /force …'
    gpupdate.exe /force | Out-Null

    Write-Verbose "Generating GPResult -> $reportPath"
    gpresult.exe /h $reportPath

    # ----- Open the report ---------------------------------------------------
    Start-Process $reportPath
    Write-Output "GPResult saved to $reportPath"
}