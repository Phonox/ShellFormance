$ray = 10,50,100,500,1000,10000,100000
$First = @()
$Second = @()
$RandomWord = "stuff"

# loops will be empty
foreach ($tries in $ray) {
    $pre = 1..$tries
    $TheseTests = @()
    $assert = ( [system.Collections.ArrayList]@("$RandomWord`n" * $tries -split "`n") )
    $assert.RemoveAt( $assert.count -1)
    $TheseTests += Test-Performance "PreRenderForeach(){}" { foreach($b in $pre) { "$RandomWord" } } -Assert $assert -Samples 5
    $TheseTests += Test-Performance "PreRenderForeach{}" { $pre.Foreach{ "$RandomWord" } } -Assert $assert -Samples 5
    $TheseTests += Test-Performance "PreRender|Foreach" {  $pre | Foreach-Object { "$RandomWord" } } -Assert $assert -Samples 5
    $TheseTests | Add-Member -Force -NotePropertyName "TimesExec" -NotePropertyValue $tries
    $first += @($TheseTests)
}

foreach ($tries in $ray) {
    $assert = ( [system.Collections.ArrayList]@("$RandomWord`n" * $tries -split "`n") )
    $assert.RemoveAt( $assert.count -1)
    $Second += Test-Performance "NoNeedOfArrayList" -RunInDifferentLoops { "$RandomWord" } -repeat $tries -Assert $assert -Samples 5
}
if (!$first.assert) {"Assertion failed - First"}
if (!$Second.assert) {"Assertion failed - Second"}
$First,$second|Foreach-Object{$_ |Foreach-Object{$_} }| Sort-Object Time | Select-Object Time,TimesExec,PSVersion,Loop,Name |Format-Table -AutoSize
$First,$second|Foreach-Object{$_ |Foreach-Object{$_} }| Sort-Object Time | Measure-PerformanceScore
<#------------------------------
When creating tests.. prerender all objects might save a bit of time, but might as well be missguiding as it has to be rendered somewhere in the code.

$First,$second|Foreach-Object{$_ |Foreach-Object{$_} }| Sort-Object Time | Measure-PerformanceScore

Name                                TotalScore
----                                ----------
PreRenderForeach(){}          7,73344903331471
Foreach(){}_NoNeedOfArrayList 9,36007594816745
DoWhile_NoNeedOfArrayList     12,8666007743562
DoUntil_NoNeedOfArrayList     13,6349126420486
While_NoNeedOfArrayList       13,8420248021911
For_NoNeedOfArrayList         13,9419646812219
PreRenderForeach{}            18,9487543417904
.Foreach{}_NoNeedOfArrayList  20,9241714970843
PreRender|Foreach             30,4128183666737
|Foreach_NoNeedOfArrayList    33,4326153613323
Best potential Score          7

Time             TimesExec PSVersion      Loop        Name                 Assert
----             --------- ---------      ----        ----                 ------
00:00:00.0001212        10 5.1.19041.1151             PreRenderForeach(){}   True
00:00:00.0002395        10 5.1.19041.1151             PreRenderForeach{}     True
00:00:00.0003305        50 5.1.19041.1151             PreRenderForeach(){}   True
00:00:00.0005062        10 5.1.19041.1151 Foreach(){} NoNeedOfArrayList      True
00:00:00.0005162        10 5.1.19041.1151 For         NoNeedOfArrayList      True
00:00:00.0005589        10 5.1.19041.1151 DoWhile     NoNeedOfArrayList      True
00:00:00.0005645        10 5.1.19041.1151 While       NoNeedOfArrayList      True
00:00:00.0005651        10 5.1.19041.1151 DoUntil     NoNeedOfArrayList      True
00:00:00.0005962        10 5.1.19041.1151             PreRender|Foreach      True
00:00:00.0006089        10 5.1.19041.1151 .Foreach{}  NoNeedOfArrayList      True
00:00:00.0006883       100 5.1.19041.1151             PreRenderForeach(){}   True
00:00:00.0006950        50 5.1.19041.1151             PreRenderForeach{}     True
00:00:00.0008555        50 5.1.19041.1151 Foreach(){} NoNeedOfArrayList      True
00:00:00.0010641        10 5.1.19041.1151 |Foreach    NoNeedOfArrayList      True
00:00:00.0011040        50 5.1.19041.1151 For         NoNeedOfArrayList      True
00:00:00.0011217        50 5.1.19041.1151 DoWhile     NoNeedOfArrayList      True
00:00:00.0011306        50 5.1.19041.1151 DoUntil     NoNeedOfArrayList      True
00:00:00.0013969       100 5.1.19041.1151 Foreach(){} NoNeedOfArrayList      True
00:00:00.0015603        50 5.1.19041.1151 While       NoNeedOfArrayList      True
00:00:00.0018146       100 5.1.19041.1151 While       NoNeedOfArrayList      True
00:00:00.0018157       100 5.1.19041.1151 DoWhile     NoNeedOfArrayList      True
00:00:00.0018180       100 5.1.19041.1151             PreRenderForeach{}     True
00:00:00.0018496       100 5.1.19041.1151 For         NoNeedOfArrayList      True
00:00:00.0018617       100 5.1.19041.1151 DoUntil     NoNeedOfArrayList      True
00:00:00.0018767        50 5.1.19041.1151             PreRender|Foreach      True
00:00:00.0025299        50 5.1.19041.1151 |Foreach    NoNeedOfArrayList      True
00:00:00.0030150        50 5.1.19041.1151 .Foreach{}  NoNeedOfArrayList      True
00:00:00.0032049       100 5.1.19041.1151 .Foreach{}  NoNeedOfArrayList      True
00:00:00.0033761       500 5.1.19041.1151             PreRenderForeach(){}   True
00:00:00.0034549       100 5.1.19041.1151             PreRender|Foreach      True
00:00:00.0045306       100 5.1.19041.1151 |Foreach    NoNeedOfArrayList      True
00:00:00.0045983       500 5.1.19041.1151 Foreach(){} NoNeedOfArrayList      True
00:00:00.0057869      1000 5.1.19041.1151             PreRenderForeach(){}   True
00:00:00.0063454       500 5.1.19041.1151 For         NoNeedOfArrayList      True
00:00:00.0064727       500 5.1.19041.1151 DoWhile     NoNeedOfArrayList      True
00:00:00.0066329       500 5.1.19041.1151 While       NoNeedOfArrayList      True
00:00:00.0070870       500 5.1.19041.1151 DoUntil     NoNeedOfArrayList      True
00:00:00.0081186      1000 5.1.19041.1151 Foreach(){} NoNeedOfArrayList      True
00:00:00.0081709       500 5.1.19041.1151             PreRenderForeach{}     True
00:00:00.0086285       500 5.1.19041.1151 .Foreach{}  NoNeedOfArrayList      True
00:00:00.0113283      1000 5.1.19041.1151 For         NoNeedOfArrayList      True
00:00:00.0115993      1000 5.1.19041.1151 While       NoNeedOfArrayList      True
00:00:00.0119630      1000 5.1.19041.1151 DoWhile     NoNeedOfArrayList      True
00:00:00.0127021      1000 5.1.19041.1151 DoUntil     NoNeedOfArrayList      True
00:00:00.0128163       500 5.1.19041.1151             PreRender|Foreach      True
00:00:00.0167658       500 5.1.19041.1151 |Foreach    NoNeedOfArrayList      True
00:00:00.0176717      1000 5.1.19041.1151             PreRenderForeach{}     True
00:00:00.0273112      1000 5.1.19041.1151 |Foreach    NoNeedOfArrayList      True
00:00:00.0318355      1000 5.1.19041.1151 .Foreach{}  NoNeedOfArrayList      True
00:00:00.0390957      1000 5.1.19041.1151             PreRender|Foreach      True
00:00:00.0660333     10000 5.1.19041.1151 Foreach(){} NoNeedOfArrayList      True
00:00:00.0739441     10000 5.1.19041.1151             PreRenderForeach(){}   True
00:00:00.1135546     10000 5.1.19041.1151 DoWhile     NoNeedOfArrayList      True
00:00:00.1142522     10000 5.1.19041.1151 For         NoNeedOfArrayList      True
00:00:00.1173858     10000 5.1.19041.1151 DoUntil     NoNeedOfArrayList      True
00:00:00.1198845     10000 5.1.19041.1151 While       NoNeedOfArrayList      True
00:00:00.1512216     10000 5.1.19041.1151             PreRenderForeach{}     True
00:00:00.1725721     10000 5.1.19041.1151 .Foreach{}  NoNeedOfArrayList      True
00:00:00.3291163     10000 5.1.19041.1151             PreRender|Foreach      True
00:00:00.3329286     10000 5.1.19041.1151 |Foreach    NoNeedOfArrayList      True
00:00:00.6660632    100000 5.1.19041.1151             PreRenderForeach(){}   True
00:00:00.7407796    100000 5.1.19041.1151 Foreach(){} NoNeedOfArrayList      True
00:00:01.1315614    100000 5.1.19041.1151 While       NoNeedOfArrayList      True
00:00:01.1649977    100000 5.1.19041.1151 DoWhile     NoNeedOfArrayList      True
00:00:01.1737754    100000 5.1.19041.1151 For         NoNeedOfArrayList      True
00:00:01.1753339    100000 5.1.19041.1151 DoUntil     NoNeedOfArrayList      True
00:00:01.8857416    100000 5.1.19041.1151             PreRenderForeach{}     True
00:00:01.9833530    100000 5.1.19041.1151 .Foreach{}  NoNeedOfArrayList      True
00:00:03.2018894    100000 5.1.19041.1151 |Foreach    NoNeedOfArrayList      True
00:00:04.1460153    100000 5.1.19041.1151             PreRender|Foreach      True


---------------------------------#>
<# OLD
TL;DR
Always USE Foreach(){}


These tests also include the time to generate all the objects which makes it a golden for-loop in some cases
At low volumes
Use: Foreach(){}, DoWhile,While, .Foreach({}) are OK
Skip: for and |foreach

At High volumes
Use: Foreach(){}, DoWhile, DoUntil, While, For
Skip .Foreach({}), |Foreach

PreRendered/PreGenerated lists
Did not improve the result, Could be an issue with the handling of scriptblocks

beats them all with or without creation of Arraylist and Add item to the list each time
But at high volumes it is in short equal to For,While,DoWhile,DoUntil


Low volumes
$first | where-object TimesExec -eq 50 | Sort-Object Time
00:00:00.0003948 50        7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.0005909 50        7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:00.0047291 50        7.1.3     Mac   CoreCLR   PreRender|Foreach

$Second | where-object TimesExec -eq 50 | Sort-Object Time
00:00:00.0001056 50        7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList                                                                                                           00:00:00.0001560 50        7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList               
00:00:00.0002130 50        7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:00.0002755 50        7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.0004089 50        7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:00.0009092 50        7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList
00:00:00.0011823 50        7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList




High volumes
$first | where-object TimesExec -eq 100000 | Sort-Object Time
00:00:00.3363819 100000    7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.3680189 100000    7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:01.6665286 100000    7.1.3     Mac   CoreCLR   PreRender|Foreach

$Second | where-object TimesExec -eq 100000 | Sort-Object Time
00:00:00.0953286 100000    7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList
00:00:00.1954575 100000    7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:00.1978848 100000    7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList
00:00:00.1987406 100000    7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.2193616 100000    7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList
00:00:00.4507881 100000    7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:01.9002763 100000    7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList

Complete result
Time             TimesExec PSVersion OS    CLR       Name
----             --------- --------- --    ---       ----
00:00:00.0002467 50        7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.0002799 100       7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.0003330 100       7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:00.0005446 10        7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.0005909 50        7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:00.0012502 10        7.1.3     Mac   CoreCLR   PreRender|Foreach
00:00:00.0014691 500       7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.0019211 100       7.1.3     Mac   CoreCLR   PreRender|Foreach
00:00:00.0019959 1000      7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.0029653 500       7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:00.0033412 1000      7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:00.0055635 50        7.1.3     Mac   CoreCLR   PreRender|Foreach
00:00:00.0079497 10        7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:00.0152064 500       7.1.3     Mac   CoreCLR   PreRender|Foreach
00:00:00.0321651 10000     7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.0346427 1000      7.1.3     Mac   CoreCLR   PreRender|Foreach
00:00:00.0668387 10000     7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:00.1686109 10000     7.1.3     Mac   CoreCLR   PreRender|Foreach
00:00:00.2094818 100000    7.1.3     Mac   CoreCLR   PreRenderForeach(){}CreateArrayAndAdd
00:00:00.3680189 100000    7.1.3     Mac   CoreCLR   PreRenderForeach{}
00:00:01.6665286 100000    7.1.3     Mac   CoreCLR   PreRender|Foreach

# Second
Time             TimesExec PSVersion OS    CLR       Loop        Name
----             --------- --------- --    ---       ----        ----
00:00:00.0004168 10        7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList
00:00:00.0004881 10        7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:00.0005245 50        7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList
00:00:00.0005605 10        7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList
00:00:00.0005902 10        7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList
00:00:00.0006602 50        7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:00.0006876 100       7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList
00:00:00.0006876 50        7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.0007060 10        7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.0007398 50        7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:00.0007651 10        7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList
00:00:00.0009940 100       7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList
00:00:00.0010962 50        7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList
00:00:00.0013863 100       7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList
00:00:00.0014961 1000      7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList
00:00:00.0015669 100       7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:00.0015886 500       7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList
00:00:00.0017963 10        7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:00.0019510 500       7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.0021731 100       7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:00.0023382 500       7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList
00:00:00.0024827 50        7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList
00:00:00.0027635 500       7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:00.0027651 500       7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList
00:00:00.0030165 500       7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:00.0040588 100       7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList
00:00:00.0043219 1000      7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:00.0047867 50        7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList
00:00:00.0065335 100       7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.0071898 1000      7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList
00:00:00.0080432 1000      7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:00.0085193 1000      7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList
00:00:00.0087325 1000      7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.0133317 500       7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList
00:00:00.0143728 10000     7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList
00:00:00.0214763 1000      7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList
00:00:00.0283301 10000     7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.0305283 10000     7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList
00:00:00.0321448 10000     7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:00.0327071 10000     7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList
00:00:00.0757325 10000     7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:00.0797429 100000    7.1.3     Mac   CoreCLR   Foreach(){} NoNeedOfArrayList
00:00:00.2757138 100000    7.1.3     Mac   CoreCLR   For         NoNeedOfArrayList
00:00:00.2867560 100000    7.1.3     Mac   CoreCLR   While       NoNeedOfArrayList
00:00:00.3245791 100000    7.1.3     Mac   CoreCLR   DoUntil     NoNeedOfArrayList
00:00:00.3424291 10000     7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList
00:00:00.3626266 100000    7.1.3     Mac   CoreCLR   DoWhile     NoNeedOfArrayList
00:00:01.2502689 100000    7.1.3     Mac   CoreCLR   .Foreach{}  NoNeedOfArrayList
00:00:02.3177292 100000    7.1.3     Mac   CoreCLR   |Foreach    NoNeedOfArrayList

#>