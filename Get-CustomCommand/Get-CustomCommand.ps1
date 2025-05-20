function Get-CustomCommand {
    [CmdletBinding()]
    param(
        [string]$Name,
		[string]$PSScriptRoot = "UPDATE-ME"
        [string]$CsvPath = "$PSScriptRoot\Get-CustomCommand\CustomCommands.csv"
      )

    if (-not (Test-Path $CsvPath)) {
        throw "CSV file '$CsvPath' not found."
    }

    # Import catalogue and add a Script property that lazily loads the file contents
    $cmdTable = Import-Csv -Path $CsvPath | ForEach-Object {
        $_ | Add-Member -NotePropertyName Script -NotePropertyValue {
            if (Test-Path $_.FilePath) {
                Get-Content -LiteralPath $_.FilePath -Raw
            } else {
                "[!] File not found: $($_.FilePath)"
            }
        }.Invoke() -PassThru
    }

    if ($Name) {
        # Show the source of one command
        $row = $cmdTable | Where-Object Name -eq $Name
        if ($row) { $row.Script } else { Write-Warning "Command '$Name' not listed in $CsvPath." }
    }
    else {
        # List view
        $cmdTable |
            Select-Object Name, Description, Example |
            Sort-Object Name |
            Format-Table -AutoSize
    }
}