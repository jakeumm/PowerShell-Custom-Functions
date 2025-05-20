Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete



function cd($target)
{
    if($target.EndsWith(".lnk"))
    {
        $sh = new-object -com wscript.shell
        $fullpath = resolve-path $target
        $targetpath = $sh.CreateShortcut($fullpath).TargetPath
        set-location $targetpath
    }
    else {
        set-location $target
    }
}

Register-ArgumentCompleter -CommandName cd -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $word = if ($wordToComplete) { $wordToComplete } else { '*' }
    $items = Get-ChildItem -Path . -Filter "$word*.lnk" -File

    foreach ($item in $items) {
        [System.Management.Automation.CompletionResult]::new(
            $item.Name,
            $item.Name,
            'ParameterValue',
            $item.FullName
        )
    }
}