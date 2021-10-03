$Sample = 7
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    $assert = @( $( foreach($item in 1..$loop){ if ($item % 2) {$item} } ) , $(foreach($item in 1..$loop){ if ($item % 3) {$item} } ) )
    $splat = @{Sample = $Sample ; Assert = $assert}
    # Should be
    # $FirstLoop,$SecondLoop = @( $( foreach($item in 1..$loop){ if ($item % 2) {$item} } ) ,  $(foreach($item in 1..$loop){ if ($item % 3) {$item} } ) )
    $TheseTests = @()
    Write-Information "---- LOOP $loop ----"
    # $PSItem / $_
    $TheseTests += Test-Performance @splat -Name 'Foreach(){}2x'      -ScriptBlock { $( foreach($item in 1..$loop){ if ($item % 2) {$item} } ) , $(foreach($item in 1..$loop){ if ($item % 3) {$item} } ) }
    $TheseTests += Test-Performance @splat -Name 'Foreach(){}Shorter' -ScriptBlock { $a = [system.Collections.ArrayList]@() ; $b = $( foreach($item in 1..$loop){ if ($item % 2) {$item} ; if ($item % 3) {$null=$a.Add($item) } } ) ; return $a,$b }
    # $int
    $TheseTests += Test-Performance @splat -Name 'For(){}2x'        -ScriptBlock { $( for($int=1;$int -le $loop;$int++ ) { if ($int % 2) {$int} } ), $(for($int=1;$int -le $loop;$int++ ) { if ($int % 3) {$int} } )}
    $TheseTests += Test-Performance @splat -Name 'For(){}SHORTER'   -ScriptBlock { $a = [system.Collections.ArrayList]@() ; $b = for($int=1;$int -le $loop;$int++ ) { if ($int % 2) {$int} ; if ($int % 3) {$null=$a.Add($int) }} ;return $a,$b }
    $TheseTests += Test-Performance @splat -Name 'While(){}2x'      -ScriptBlock { $( $int = 1 ; While($int -le $loop){if ($int % 2) {$int};$int++} ) , $($int = 1 ; While($int -le $loop){if ($int % 3) {$int};$int++ } )  }
    $TheseTests += Test-Performance @splat -Name 'Do{}While()2x'    -ScriptBlock { $($int = 1 ; Do{if ($int % 2) {$int};$int++}While($int -le $loop) ),$($int = 1 ; Do{if ($int % 3) {$int};$int++}While($int -le $loop) ) }
    $TheseTests += Test-Performance @splat -Name 'Do{}Until()2x'    -ScriptBlock { $($int = 1 ; Do{if ($int % 2) {$int};$int++}Until($int -gt $loop) ),$($int = 1 ; Do{if ($int % 3) {$int};$int++}Until($int -gt $loop) )}
    # $_
    if ($PSVersionTable.PSVersion.Major -gt 3) {
        $TheseTests += Test-Performance @splat -Name '.Foreach({})2x' -ScriptBlock { $((1..$loop).ForEach({ if ($_ % 2) {$_} } )),$((1..$loop).ForEach( { if ($_ % 3) {$_} } ) ) }
        $TheseTests += Test-Performance @splat -Name '.Where{})2x'    -ScriptBlock { $((1..$loop).Where({ $_ % 2} ) ),$((1..$loop).Where( { $_ % 3 } ) ) }
        #$TheseTests += Test-Performance @splat -Name '.Where{}SPLIT)' -ScriptBlock { $((1..$loop).Where({ $_ % 2 -or $_ % 3} ) ).Where({$_ % 2},"split") } # similar numbers :(
    }
    if ($loop -gt 1) {
        $TheseTests += Test-Performance @splat -Name "|Foreach-Obj{}" -ScriptBlock { 1..$loop|Foreach-Object -Begin{ $First = [System.Collections.ArrayList]@() ; $Second=[System.Collections.ArrayList]@()} -Process{if ($_ % 2) { $null = $First.Add($_) };if ($_ % 3) { $null = $Second.Add($_) } } -End{ @($First),@($Second) } }
        $TheseTests += Test-Performance @splat -Name "|AnonymusPipe"  -ScriptBlock { 1..$loop|& { Begin{$First = [System.Collections.ArrayList]@();$second=[System.Collections.ArrayList]@()} Process{if ($_ % 2) { $null = $First.Add($_) };if ($_ % 3) { $null = $Second.Add($_) } } End{ return @($First),@($Second)} } }
    }else{ # Had to do a workaround to get the same result.
        $TheseTests += Test-Performance @splat -Name "|AnonymusPipe"  -ScriptBlock { 1..$loop|& { Process{if ($_ % 2) { $First = $_ };if ($_ % 3) { $Second = $_ } } End{ $First,$Second} } }
        $TheseTests += Test-Performance @splat -Name "|Foreach-Obj{}" -ScriptBlock { 1..$loop|Foreach-Object -Begin{ } -Process{if ($_ % 2) { $First = $_ };if ($_ % 3) { $Second = $_ } } -End{ $First,$Second } }
    }
    $TheseTests += Test-Performance @splat -Name "|Where-Obj{}"   -ScriptBlock { $(1..$loop|Where-Object { $_ % 2 }),$(1..$loop|Where-Object { $_ % 3 }) }
    $TheseTests| & { Process{$_."TimesExec" = $loop ; $_ } }
} )
$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure
