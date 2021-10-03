$obj = [PSCustomObject]@{a=2;b=4}
$tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    Test-Performance -Name "SingletsAddMember" -SB { [PSCustomObject]@{a=2} |Add-Member -Force -NotePropertyValue 5 -NotePropertyName "b" } -Repeat $loop
    Test-Performance -Name "SingletsSetProp" -SB { [PSCustomObject]@{a=2}|&{Process{$_.Add("b",2) } } } -Repeat $loop
} )

foreach($tries in 100,100000){
    $objects = for($int=0;$int -lt $tries; $int++){$obj}
    $tests += [PSCustomObject]@{
        Name = "AllAddMember"
        ScriptBlock = { $objects |Add-Member -NotePropertyValue 5 -NotePropertyName "b" -Force }
    },
    [PSCustomObject]@{
        Name = "AllSetProp"
        ScriptBlock = { $objects |ForEach-Object { $_["b"] = 5} }
    } | Test-Performance | Foreach-Object { $_.TimesExec = $Tries ; $_}
}

$tests | Sort-Object Time