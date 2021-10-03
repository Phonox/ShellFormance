$tests = @( foreach ( $loop in 1,3,8,13,21,100,1000){
    $hash = @{}
    $assert = 1..$loop
    $array = $assert.PSObject.Copy()

    Test-Performance -Samples 5 -Name "array[int]" -SB {Foreach($key in $array) { $array[$key] }} -Assert $assert | & {Process{ $_.TimesExec = $loop ; $_}}
    Test-Performance -Samples 5 -Name "array.GetEnum" -SB { Foreach($item in $array.GetEnumerator()) { $item.value }} -Assert $assert | & {Process{ $_.TimesExec = $loop ; $_}}
} )
Measure-PerformanceScore $tests

<#
Name                TotalScore        LowVolume       HighVolume
----                ----------        ---------       ----------
Hash[Key]     1,00500074638006 1,00700104493208                1
Hash.Key      1,08399948776354 1,03910234465973 1,19624234552308
Hash.GetEnum  2,21857648230614 2,57713816263491 1,32217228148421
#>