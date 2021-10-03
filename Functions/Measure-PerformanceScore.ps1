Function Measure-PerformanceScore {
    <#
    .SYNOPSIS
    Get a general overview of the score. Lower the better.
    Score system is based out of the best time and how many times slower they are.
    1 is best. A score of 2 means that it takes 2x longer to execute
    .LINK
    Test-Performance
    .EXAMPLE
    Measure-PerformanceScore -Items $test
Name                 TotalScore        LowVolume       HighVolume
----                 ----------        ---------       ----------
Foreach(){}     1,0215493726132 1,03878887070376                1
For(){}        1,97840622084214 1,49695402924259 2,58022146034159
Do{}Until()    1,98433225401799 1,54181016091268 2,53748487039962
While(){}      2,01052642031201 1,62043570953067 2,49813980878869
Do{}While()    2,04909969742399 1,58559036776477 2,62848635949801
|AnonymousFunc 2,77063734486883 3,07140875454571 2,39467308277272
.Foreach({})   2,93146153493939 2,10464060415424 3,96498769842083
|Foreach{}     7,21604431363668 6,97298799694643 7,51986470949948
    .EXAMPLE
    $tests | Measure-PerformanceScore
Name                 TotalScore        LowVolume       HighVolume
----                 ----------        ---------       ----------
Foreach(){}     1,0215493726132 1,03878887070376                1
For(){}        1,97840622084214 1,49695402924259 2,58022146034159
Do{}Until()    1,98433225401799 1,54181016091268 2,53748487039962
While(){}      2,01052642031201 1,62043570953067 2,49813980878869
Do{}While()    2,04909969742399 1,58559036776477 2,62848635949801
|AnonymousFunc 2,77063734486883 3,07140875454571 2,39467308277272
.Foreach({})   2,93146153493939 2,10464060415424 3,96498769842083
|Foreach{}     7,21604431363668 6,97298799694643 7,51986470949948
    #>
    Param([Parameter(ValueFromPipeline)]$Items)
    Begin{$ItemsFromPipe = [System.Collections.ArrayList]@()}
    Process{
        if ( $items.GetType().BaseType.Name -eq 'Array' -or $items.GetType().Name -eq 'ArrayList' ) {
            $ItemsFromPipe.AddRange( $Items )
        }else{
            $Null = $ItemsFromPipe.Add($items)
        }
    }
    End{
        $ItemsFromPipe | Group-Object TimesExec | ForEach-Object {
            $_.Group | Sort-Object Time | Foreach-Object -Begin {
                    $BestTime = $null
                } -Process {
                    if (!$BestTime){$BestTime = $_.Time.Ticks} 
                    ; $_ |Add-Member -NotepropertyName 'Score' -NotePropertyValue ( $_.Time.Ticks / $BestTime ) -Force ;
                }
        }
        $ItemsFromPipe | Group-Object Name | ForEach-Object {
            $high = $_.Group | & { Begin{$int=0}Process{ if ($_.TimesExec -ge 100){$_ ;$int++} } End{if (!$int){1}} }
            $low  = $_.Group | & { Begin{$int=0}Process{ if ($_.TimesExec -lt 100){$_ ;$int++} } End{if (!$int){1}} }
            $Assert = -Not ( $_.Group.Assert -eq $false )

            [PSCustomObject]@{
                PSTypeName = "TestSummary"
                Name = $_.Name
                TotalScore = "{0:P0}" -f ( ( $_.Group.Score | Measure-Object -sum ).Sum / ( $_.Group.Score | Measure-Object ).Count )
                LowVolume  = "{0:P0}" -f ( ( $low.Score     | Measure-Object -sum ).Sum / ( $Low.Score  | Measure-Object ).Count )
                HighVolume = "{0:P0}" -f ( ( $high.Score    | Measure-Object -sum ).Sum / ( $high.Score | Measure-Object ).Count )
                Assert = $Assert
            }
        } | Sort-Object TotalScore
    }
}
Export-ModuleMember -Function Measure-PerformanceScore