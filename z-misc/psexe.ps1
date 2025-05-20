function psexe {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )
    $PSExecPath = "ENTER-PSEXEPATH"
    & $PSExecPath @Arguments
}