function Copy-Path { 
    <#
    .SYNOPSIS
    Copies a file or directory path to the clipboard.

    .DESCRIPTION
    Copies the full path of a specified file or directory to the clipboard.
    If no path is provided, it copies the current directory path.

    .PARAMETER Path
    The file or directory whose full path will be copied to the clipboard.

    .EXAMPLE
    Copy-Path
    Copies the current directory path.

    .EXAMPLE
    Copy-Path .\file.txt
    Copies the full path of file.txt.
    
    .EXAMPLE
    Copy-Path .\folder\
    Copies the full path of the folder.
    #>

    param (
        [Parameter(Position = 0)]
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        # If no path is provided, use the current location
        $currentPath = Get-Location
        $quotedPath = '"' + $currentPath.Path + '"'
        $quotedPath | Set-Clipboard
        Write-Output $quotedPath
    }
    else {
        if (-not (Test-Path $Path)) {
            Write-Host "No Directory or File can be found with that path" -ForegroundColor Red
            return
        }
        $item = Get-Item -Path $Path
        $quotedPath = '"' + $item.FullName + '"'  # Completed this line
        $quotedPath | Set-Clipboard
        Write-Output $quotedPath
    }
}
