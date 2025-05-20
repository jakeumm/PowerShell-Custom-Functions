function Get-PSHistory {
    <#
    .SYNOPSIS
    Get-PSHistory - V1.0

    .DESCRIPTION
    Retrieves PowerShell command history from the PSReadLine history file and allows filtering by pattern.

    .PARAMETER Pattern
    Search PSHistory for a string, not case sensitive.

    .PARAMETER History
    Set search length, default is 100.

    .PARAMETER Help
    Display help information for the function.

    .EXAMPLE
    Get-PSHistory -Pattern "test" -History 10

    .EXAMPLE
    Get-PSHistory "test"

    .EXAMPLE
    Get-PSHistory
    #>

    param (
        [Parameter(Position = 0)]
        [string]$Pattern = "",
        [int]$History = 100,
        [switch]$Help
    )

    if ($Help) {
        Write-Output @"
-PATTERN    Search PSHistory for a String, not case sensitive
-HISTORY    Set Search Length, default 100

EXAMPLES
    Get-PSHistory -Pattern "test" -History 10
    Get-PSHistory "test"
    Get-PSHistory
"@
        return
    }

    $historyPath = (Get-PSReadLineOption).HistorySavePath
    if (Test-Path $historyPath) {
        $content = Get-Content -Path $historyPath -Tail $History
        if ($Pattern) {
            $content | Select-String -Pattern $Pattern
        } else {
            $content
        }
    } else {
        Write-Host "History file not found at $historyPath"
    }
}