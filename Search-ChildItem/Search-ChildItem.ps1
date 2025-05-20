function Search-ChildItem {
    <#
    .SYNOPSIS
        Like Get-ChildItem –Recurse, but
        * quietly skips “Access denied” paths
        * lets you cap recursion depth
        * returns only LastWriteTime and FullName

    .PARAMETER Pattern   (positional 0)
        One or more wildcard patterns (*.pdf,foo*, etc.).
        Separate multiple patterns with spaces **or** “|”
        (e.g. 'foo*pdf|foo*txt').

    .PARAMETER Path
        Root directory to search.  Defaults to “.” (the current location).

    .PARAMETER Depth
        Stop after traversing this many directory levels below *Path*.
        (Uses native –Depth on PS 7+; on PS 5.1 it’s emulated.)

    .EXAMPLE
        Search-ChildItem  *pdf
    .EXAMPLE
        Search-ChildItem -Path 'C:\Temp' 'foo*'
    .EXAMPLE
        Search-ChildItem -Depth 3 'foo*pdf|foo*txt'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0,
                   ValueFromRemainingArguments = $true)]
        [string[]] $Pattern = '*',

        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]   $Path   = '.',

        [ValidateRange(1, [int]::MaxValue)]
        [int]      $Depth
    )

    # Expand “foo*pdf|foo*txt” into separate patterns
    $Pattern = $Pattern |
               ForEach-Object { $_ -split '\|' } |
               Where-Object   { $_ }

    $resolved = (Resolve-Path -LiteralPath $Path).ProviderPath
    $baseDepth = ($resolved).Split([IO.Path]::DirectorySeparatorChar).Count

    $gciParams = @{
        Path        = $resolved
        File        = $true
        Recurse     = $true
        ErrorAction = 'SilentlyContinue'   # suppress UnauthorizedAccess, etc.
    }
    if ($Depth -and $PSVersionTable.PSVersion.Major -ge 7) {
        $gciParams['Depth'] = $Depth
    }

    Get-ChildItem @gciParams |
        Where-Object {
            # Depth emulation for Windows PowerShell 5.1
            if ($Depth -and $PSVersionTable.PSVersion.Major -lt 7) {
                ($_.FullName).Split([IO.Path]::DirectorySeparatorChar).Count -gt ($baseDepth + $Depth) ?
                    $false : $true
            } else { $true }
        } |
        Where-Object {
            # Pattern match (case‑insensitive, like Get‑ChildItem)
            foreach ($p in $Pattern) {
                if ($_.Name -like $p) { return $true }
            }
            return $false
        } |
        Select-Object LastWriteTime, FullName
}
