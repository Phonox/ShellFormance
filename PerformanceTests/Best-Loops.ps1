# Difference between most loops, what is best, is there a difference?
$RandomWord = "stuff"
$Sample = 7
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"
$an = {Process{"$RandomWord"} }
$tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    $assert = ( [system.Collections.ArrayList]@("$RandomWord`n" * $loop -split "`n") )
    $assert.RemoveAt( $assert.count -1)
    $splat = @{Sample = $Sample ; Assert = $assert}
    $TheseTests = @()
    Write-Information "---- LOOP $loop ----"
    if ($PSVersionTable.PSVersion.Major -gt 3) {
        $TheseTests += Test-Performance -Samples $Sample -Assert $assert -Name '.Foreach({})' -ScriptBlock { (1..$loop).ForEach({"$RandomWord"}) }
    }
    $TheseTests += Test-Performance @splat -Name 'Foreach(){}'      -ScriptBlock { foreach($null in 1..$loop){"$RandomWord"} }
    $TheseTests += Test-Performance @splat -Name 'For(){}'          -ScriptBlock { for($int=0;$int -lt $loop;$int++ ) { "$RandomWord" } }
    $TheseTests += Test-Performance @splat -Name 'While(){}'        -ScriptBlock { $int = 0 ; While($int -lt $loop){"$RandomWord";$int++} }
    $TheseTests += Test-Performance @splat -Name 'Do{}While()'      -ScriptBlock { $int = 0 ; Do{"$RandomWord";$int++}While($int -lt $loop) }
    $TheseTests += Test-Performance @splat -Name 'Do{}Until()'      -ScriptBlock { $int = 0 ; Do{"$RandomWord";$int++}Until($int -ge $loop) }
    $TheseTests += Test-Performance @splat -Name "|Foreach{}"       -ScriptBlock { 1..$loop|Foreach-Object -Process {"$RandomWord"} }
    $TheseTests += Test-Performance @splat -Name "|AnonymusPipe"    -ScriptBlock { 1..$loop|& {Process{"$RandomWord"} } }
    $TheseTests += Test-Performance @splat -Name "|AnonymusPipeVar" -ScriptBlock { 1..$loop|& $an }
    $TheseTests| Foreach-Object { $_."TimesExec" = $loop ; $_ }
} )
$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure
