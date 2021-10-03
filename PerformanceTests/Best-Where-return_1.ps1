$Sample = 7
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    $assert = @(foreach($item in 1..$loop){ if ($item % 2) {$item} } )
    $splat = @{Sample = $Sample ; Assert = $assert}
    $TheseTests = @()
    Write-Information "---- LOOP $loop ----"
    # $PSItem / $_
    $TheseTests += Test-Performance @splat -Name 'Foreach(){}'    -ScriptBlock { foreach($item in 1..$loop){ if ($item % 2) {$item} } }
    # $int
    $TheseTests += Test-Performance @splat -Name 'For(){}'     -ScriptBlock { for($int=1;$int -le $loop;$int++ ) { if ($int % 2) {$int} } }
    $TheseTests += Test-Performance @splat -Name 'While(){}'   -ScriptBlock { $int = 1 ; While($int -le $loop){if ($int % 2) {$int};$int++} }
    $TheseTests += Test-Performance @splat -Name 'Do{}While()' -ScriptBlock { $int = 1 ; Do{if ($int % 2) {$int};$int++}While($int -le $loop) }
    $TheseTests += Test-Performance @splat -Name 'Do{}Until()' -ScriptBlock { $int = 1 ; Do{if ($int % 2) {$int};$int++}Until($int -gt $loop) }
    # $_
    if ($PSVersionTable.PSVersion.Major -gt 3) {
        $TheseTests += Test-Performance @splat -Name '.Foreach({})' -ScriptBlock { (1..$loop).ForEach({ if ($_ % 2) {$_} } ) }
        $TheseTests += Test-Performance @splat -Name '.Where({})'  -ScriptBlock { (1..$loop).Where({ $_ % 2 } ) }
        $TheseTests += Test-Performance @splat -Name '.Where({})'  -ScriptBlock { (1..$loop).Where({ $_ % 2} ) }
    }
    $TheseTests += Test-Performance @splat -Name "|Foreach-Obj{}" -ScriptBlock { 1..$loop|Foreach-Object -Process {if ($_ % 2) {$_}} }
    $TheseTests += Test-Performance @splat -Name "|Where-Obj{}"   -ScriptBlock { 1..$loop|Where-Object { $_ % 2 } }
    $TheseTests += Test-Performance @splat -Name "|AnonymusPipe"  -ScriptBlock { 1..$loop|& {Process{if ($_ % 2) {$_}} } }
    $TheseTests| & { Process{$_."TimesExec" = $loop ; $_ } }
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure
