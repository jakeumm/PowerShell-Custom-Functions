if (Test-Path alias:pwd) { Remove-Item alias:pwd -Force }

function pwd {
    $currentDir = Get-Location
    $PresentDir = $currentDir.Path
    # Copy the quoted directory to the clipboard
    $PresentDir | Set-Clipboard
    # Output the quoted directory to the console
    Write-Output $PresentDir
}