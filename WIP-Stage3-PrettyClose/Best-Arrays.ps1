$ErrorActionPreference = 'Stop'
$RandomWord = "stuff"
$Sample = 7
$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    $assert = ( [system.Collections.ArrayList]@("$RandomWord`n" * $loop -split "`n") )
    $assert.RemoveAt( $assert.count -1)
    $TheseTests = @()
    Write-Information "---- LOOP $loop ----"
    $TheseTests += Test-Performance -Samples $Sample -Assert $assert -Name 'ArrayListNEW' -ScriptBlock { [System.Collections.ArrayList]::new( @( foreach($null in 1..$loop){"$RandomWord"} ) ) }
    $TheseTests += Test-Performance -Samples $Sample -Assert $assert -Name 'ArrayList'    -ScriptBlock { [System.Collections.ArrayList]@( foreach($null in 1..$loop){"$RandomWord"} ) }
    $TheseTests += Test-Performance -Samples $Sample -Assert $assert -Name 'ArrayListADD' -ScriptBlock { $arr = [System.Collections.ArrayList]@() ;foreach($null in 1..$loop){ $null=$arr.Add("$RandomWord") } ;$arr}
    $TheseTests| & { Process{$_."TimesExec" = $loop ; $_} }
} )
$Measure = Measure-PerformanceScore $Tests

$Name = $( (Split-Path -Leaf $MyInvocation.MyCommand.path) -replace '\.ps\w?1')
$Path = Join-Path (Join-Path (Split-Path $PSScriptRoot -Parent ) "Results") "$Name-$($tests[0].PSVersion.Substring(0,1) ).csv"
Export-PerformanceResults -Items ($Tests|Sort-Object Time) -Path $Path
$Path = Join-Path (Join-Path (Split-Path $PSScriptRoot -Parent ) "Results") "$Name-Results-$($tests[0].PSVersion.Substring(0,1) ).csv"
Export-PerformanceResults -Items ($Measure|Sort-Object TotalScore) -Path $Path
$Measure
