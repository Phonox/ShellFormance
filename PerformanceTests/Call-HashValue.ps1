$Sample = 5
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    Write-Information "---- LOOP $loop ----"
    $hash = @{}
    $assert = 1..$loop
    $splat = @{Sample = $Sample ; Assert = $assert}
    # Add boolean splat
    Foreach($item in 1..$loop) {
        $hash[$item] = $item
    }
    Test-Performance @splat -Name "Hash.Key"           -SB {Foreach($key in $hash.Keys) { $Hash.$key } } | & {Process{ $_.TimesExec = $loop ; $_}}
    Test-Performance @splat -Name "Hash[Key]"          -SB {Foreach($key in $hash.Keys) { $Hash[$key] } } | & {Process{ $_.TimesExec = $loop ; $_}}
    Test-Performance        -Name "Hash.ContainsKey()" -SB {Foreach($key in $hash.Keys) { $Hash.ContainsKey($key) }} | & {Process{ $_.TimesExec = $loop ; $_}} -Samples $Sample
    Test-Performance @splat -Name "Hash.GetEnum"       -SB { Foreach($item in $hash.GetEnumerator()) { $item.value }} | & {Process{ $_.TimesExec = $loop ; $_}}
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure
