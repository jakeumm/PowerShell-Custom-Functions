# So you don't have to Get-FileHash -Algorithm

function md5sum {
    param (
        [string]$Path
    )
    Get-FileHash -Path $Path -Algorithm MD5 | Select-Object Hash, Path
}