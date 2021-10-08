#lets try operands
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$array = 1,3,8,13,21,100,1000,10000,100000
$tests = @(foreach ( $loop in $array){
    $rand = Get-random -InputObject $loop
    $woopies = 1..$loop
    #$objects = $woopies.count
    Write-Information "---- LOOP $loop ----"
    #$Bool     = @{ Assert = $(foreach($null in $woopies) {$true} ) }
    $Bool     = @{ Assert = $true }
    #$BoolN    = @{ Assert = $(foreach($null in $woopies) {$false} ) }
    $BoolN    = @{ Assert = $false }
    #$Result   = @{ Assert = $(foreach($null in $woopies) { $rand } ) }
    $Result   = @{ Assert = $rand }
    #$ResultM1 = @{ Assert = $(foreach($null in $woopies) { $rand -1 } ) }
    $ResultM1 = @{ Assert = $rand -1 }
    
    $thisTests = @()
    $thisTests += Test-Performance @ResultM1 -Name "SingleObject_IndexOf()"    { $woopies.indexOf($rand) }  # Result -1
    #Test-Performance @bool -Name "IF-SingleObject_IndexOf()" { if($woopies.indexOf($rand)){} }   #bool
    $thisTests += Test-Performance @bool -Name "SingleObject_Contain()"    { $woopies.Contains($rand) } #bool
    #Test-Performance @bool -Name "IF-SingleObject_Contain()" { if ($woopies.Contains($rand)) {} }#bool
    $thisTests += Test-Performance @bool -Name SingleObject-Contains    { $woopies -contains $rand }    #bool
    #Test-Performance @bool -Name IF-SingleObject-Contains { if($woopies -contains $rand){} }     #bool
    $thisTests += Test-Performance @bool -Name SingleObject-in          { $rand -in $woopies }          #bool
    #Test-Performance @bool -Name IF-SingleObject-in       { if ($rand -in $woopies ){} }         #bool
    $thisTests += Test-Performance @BoolN -Name SingleObject-NOT-EQ      { -Not ($woopies -eq $rand) } # -NOT bool
    #Test-Performance @bool -Name IF-SingleObject-NOT-EQ   { if (-Not ( $woopies -eq $rand ) ) {} } #bool
    $thisTests += Test-Performance @Result -Name SingleObject-EQ          { $woopies -eq $rand }          #result
    #Test-Performance @Result -Name IF-SingleObject-EQ       { if ($woopies -eq $rand) {} }         #result
    $thisTests += Test-Performance @Result -Name SingleObject-Match       { $woopies -match "^$rand$" }  #result
    #Test-Performance @Result -Name IF-SingleObject-Match    { if ($woopies -match "^$rand$") {} }  #result
    $thisTests += Test-Performance @Result -Name "SingleObject_Hash+init"   { $hash=@{}; foreach($it in $woopies) {$hash[$it] = $it} ; $hash[$rand] } #result
    #Test-Performance @Result -Name "IF-SingleObject_Hash+init" { $hash=@{}; foreach($it in $woopies) {$hash[$it] = $it} ; if($hash[$rand]){} } #result
    
    $hash=@{}; foreach($it in $woopies) {$hash[$it] = $it}
    $thisTests += Test-Performance @Result -Name SingleObject_Hash-init    { $hash[$rand]  } #result
    #Test-Performance @Result -Name IF-SingleObject_PreRenderHash { if( $hash[$rand]) {} } #result
    $thisTests | Add-Member -Force -NotePropertyName TimesExec -NotePropertyValue $loop -PassThru
} )
# $test2 = @( foreach( $loop in $array){
#     $woopies = 1..$loop
#     if ($loop -lt 2) { $round = 1 }
#     else{$round = [int]($loop /3)}
#     Write-Information "---- LOOP $loop ----"
#     $rand = Get-random -InputObject $loop -count $round
#     $objects = $woopies.count
#     #$Result = @{ Assert = $(foreach($null in $woopies) {$rand } ) }
#     $Result = @{ Assert = $rand }
#     #$Bool   = @{ Assert = $(foreach($null in $woopies) {$true} ) }
#     $Bool   = @{ Assert = $true }
#     $TheseTests = @()
#     $TheseTests += Test-Performance @Bool -Name "multipleObject_Contains()" -SB { foreach($r in $rand) { $woopies.contains( $r ) } }
#     $TheseTests += Test-Performance @Bool -Name "multipleObject_Contains"   -SB { foreach($r in $rand) { $woopies -contains $r } }
#     $TheseTests += Test-Performance @Result -Name "multipleObject_Match"    -SB { foreach($r in $rand) { $woopies -match "^$r$" } }
#     $TheseTests += Test-Performance @Result -Name "multipleObject_EQ"       -SB { foreach($r in $rand) { $woopies -eq $r } }
#     $TheseTests += Test-Performance @Result -Name "multipleObject_Hash"     -SB { $hash=@{}; foreach($it in $woopies) {$hash[$it] = $it} ; foreach($r in $rand) { $hash[$r] } }
#     $TheseTests += Test-Performance @Result -Name "multipleObject_MatchJoinedString" -SB { $r = "^$($rand -join "$|^")$" ; $woopies -match $r }
    
#     if ($loop -lt 10000) {
#         # These gets worse at 10k-100k
#         $TheseTests += Test-Performance -Name "multipleObject_IndexOf" -SB { foreach($r in $rand) { $woopies.indexOf($r) } } -Assert $( $rand - 1 )
#         $TheseTests += Test-Performance -Name "multipleObject_In" -SB { foreach($r in $rand) { $r -in $woopies } } @bool
#     }
#     $TheseTests | Add-Member -PassThru -NotePropertyName TimesExec -NotePropertyValue $woopies.count -force
# } )
# $tests.AddRange( $test2 )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure


#$tc |Where-Object Name -Match '^100000-' | Sort-object time
#$tc | Where-Object Name -Match '^multiple' | Where-Object TimesExec -eq 100000 |Sort-Object Time

<#
Results
-eq, contains() and -contains are best

-contains and -eq can complete a query of 100k 20 times before anything has been evaluated
00:00:00.0001419 20        7.1.3     Mac   CoreCLR   100000-SingleObject-Contains
00:00:00.0001749 20        7.1.3     Mac   CoreCLR   100000-SingleObject-EQ
00:00:00.0001150 20        7.1.3     Mac   CoreCLR   100000-SingleObject-NOT-EQ

Evaluations
Close to no difference between -Contains, .Contains(), .IndexOf(), -In and -eq
It starts to becaome a difference between these namned methods vs hash and match.
Best method vs hash is 2x time
hash vs match is 3x
match vs hash + initialization of object 3x
Best vs worst 6.344x

00:00:00.0002051 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject-Contains
00:00:00.0002053 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject_Contain()
00:00:00.0002155 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject_IndexOf()
00:00:00.0002164 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject-in
00:00:00.0003020 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject-EQ
00:00:00.0005513 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject_Hash
00:00:00.0013013 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject-Match

NOK
00:00:00.0033492 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject_Hash+init

Picking 1 object, 20 times from a list of 100k, -EQ, -Contains and -In is best
Time             TimesExec PSVersion OS    CLR       Name
----             --------- --------- --    ---       ----
00:00:00.1654799 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-EQ
00:00:00.1769152 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-NOT-EQ
00:00:00.2073935 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-Contains
00:00:00.2879830 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-in
00:00:00.3694916 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject_IndexOf()
00:00:00.4024716 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject_Contain()
00:00:00.8505377 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject_Hash
00:00:02.5230304 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-Match
00:00:06.6026457 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject_Hash+init


Total results - Picking 1 object, 20 times from a list of 100k
Time             TimesExec PSVersion OS    CLR       Name
----             --------- --------- --    ---       ----
00:00:00.0001107 20        7.1.3     Mac   CoreCLR   50000-SingleObject-EQ
00:00:00.0001144 20        7.1.3     Mac   CoreCLR   50-SingleObject-EQ
00:00:00.0001152 20        7.1.3     Mac   CoreCLR   50000-SingleObject-Contains
00:00:00.0001156 20        7.1.3     Mac   CoreCLR   50-SingleObject-Contains
00:00:00.0001229 20        7.1.3     Mac   CoreCLR   1000-SingleObject-Contains
00:00:00.0001419 20        7.1.3     Mac   CoreCLR   100000-SingleObject-Contains
00:00:00.0001616 20        7.1.3     Mac   CoreCLR   1000-SingleObject-EQ
00:00:00.0001700 20        7.1.3     Mac   CoreCLR   10000-SingleObject-Contains
00:00:00.0001725 20        7.1.3     Mac   CoreCLR   10000-SingleObject-EQ
00:00:00.0001749 20        7.1.3     Mac   CoreCLR   100000-SingleObject-EQ
00:00:00.0001778 20        7.1.3     Mac   CoreCLR   50-SingleObject-in
00:00:00.0001868 20        7.1.3     Mac   CoreCLR   50-SingleObject_IndexOf()
00:00:00.0001958 20        7.1.3     Mac   CoreCLR   50-SingleObject_Contain()
00:00:00.0002051 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject-Contains
00:00:00.0002053 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject_Contain()
00:00:00.0002155 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject_IndexOf()
00:00:00.0002164 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject-in
00:00:00.0003020 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject-EQ
00:00:00.0005004 20        7.1.3     Mac   CoreCLR   50-SingleObject_Hash
00:00:00.0005513 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject_Hash
00:00:00.0011751 20        7.1.3     Mac   CoreCLR   50-SingleObject-Match
00:00:00.0013013 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject-Match
00:00:00.0014239 20        7.1.3     Mac   CoreCLR   1000-IF-SingleObject-EQ
00:00:00.0016004 20        7.1.3     Mac   CoreCLR   1000-SingleObject_IndexOf()
00:00:00.0016063 20        7.1.3     Mac   CoreCLR   1000-IF-SingleObject_IndexOf()
00:00:00.0016801 20        7.1.3     Mac   CoreCLR   1000-SingleObject-in
00:00:00.0021270 20        7.1.3     Mac   CoreCLR   1000-IF-SingleObject-in
00:00:00.0025729 20        7.1.3     Mac   CoreCLR   1000-IF-SingleObject-Contains
00:00:00.0027232 20        7.1.3     Mac   CoreCLR   1000-IF-SingleObject_Contain()
00:00:00.0033492 20        7.1.3     Mac   CoreCLR   50-IF-SingleObject_Hash+init
00:00:00.0035121 20        7.1.3     Mac   CoreCLR   50-SingleObject_Hash+init
00:00:00.0047283 20        7.1.3     Mac   CoreCLR   1000-SingleObject_Contain()
00:00:00.0085061 20        7.1.3     Mac   CoreCLR   1000-SingleObject_Hash
00:00:00.0103938 20        7.1.3     Mac   CoreCLR   1000-IF-SingleObject_Hash
00:00:00.0176233 20        7.1.3     Mac   CoreCLR   10000-IF-SingleObject-EQ
00:00:00.0269307 20        7.1.3     Mac   CoreCLR   10000-SingleObject_IndexOf()
00:00:00.0277427 20        7.1.3     Mac   CoreCLR   10000-SingleObject-in
00:00:00.0308679 20        7.1.3     Mac   CoreCLR   10000-IF-SingleObject-Contains
00:00:00.0314900 20        7.1.3     Mac   CoreCLR   10000-SingleObject_Contain()
00:00:00.0368026 20        7.1.3     Mac   CoreCLR   10000-IF-SingleObject_Contain()
00:00:00.0476364 20        7.1.3     Mac   CoreCLR   10000-IF-SingleObject_IndexOf()
00:00:00.0598540 20        7.1.3     Mac   CoreCLR   1000-IF-SingleObject-Match
00:00:00.0696578 20        7.1.3     Mac   CoreCLR   50000-IF-SingleObject-EQ
00:00:00.0713280 20        7.1.3     Mac   CoreCLR   50000-SingleObject-in
00:00:00.0720130 20        7.1.3     Mac   CoreCLR   10000-IF-SingleObject_Hash
00:00:00.0748711 20        7.1.3     Mac   CoreCLR   10000-SingleObject_Hash
00:00:00.0772020 20        7.1.3     Mac   CoreCLR   1000-SingleObject_Hash+init
00:00:00.0784547 20        7.1.3     Mac   CoreCLR   10000-IF-SingleObject-in
00:00:00.0886373 20        7.1.3     Mac   CoreCLR   1000-IF-SingleObject_Hash+init
00:00:00.0941185 20        7.1.3     Mac   CoreCLR   50000-IF-SingleObject-in
00:00:00.1035692 20        7.1.3     Mac   CoreCLR   50000-IF-SingleObject-Contains
00:00:00.1040477 20        7.1.3     Mac   CoreCLR   1000-SingleObject-Match
00:00:00.1311610 20        7.1.3     Mac   CoreCLR   50000-SingleObject_Contain()
00:00:00.1350016 20        7.1.3     Mac   CoreCLR   50000-IF-SingleObject_Contain()
00:00:00.1587616 20        7.1.3     Mac   CoreCLR   50000-IF-SingleObject_IndexOf()
00:00:00.1649523 20        7.1.3     Mac   CoreCLR   100000-SingleObject-in
00:00:00.1654799 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-EQ
00:00:00.1693635 20        7.1.3     Mac   CoreCLR   50000-SingleObject_IndexOf()
00:00:00.1882313 20        7.1.3     Mac   CoreCLR   10000-IF-SingleObject-Match
00:00:00.2073935 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-Contains
00:00:00.2722767 20        7.1.3     Mac   CoreCLR   10000-SingleObject-Match
00:00:00.2879830 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-in
00:00:00.3694916 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject_IndexOf()
00:00:00.3718328 20        7.1.3     Mac   CoreCLR   100000-SingleObject_IndexOf()
00:00:00.4024716 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject_Contain()
00:00:00.4060595 20        7.1.3     Mac   CoreCLR   100000-SingleObject_Contain()
00:00:00.4100352 20        7.1.3     Mac   CoreCLR   50000-SingleObject_Hash
00:00:00.4755326 20        7.1.3     Mac   CoreCLR   50000-IF-SingleObject_Hash
00:00:00.6728658 20        7.1.3     Mac   CoreCLR   10000-IF-SingleObject_Hash+init
00:00:00.7087987 20        7.1.3     Mac   CoreCLR   10000-SingleObject_Hash+init
00:00:00.8396279 20        7.1.3     Mac   CoreCLR   100000-SingleObject_Hash
00:00:00.8505377 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject_Hash
00:00:00.8962753 20        7.1.3     Mac   CoreCLR   50000-IF-SingleObject-Match
00:00:00.9328763 20        7.1.3     Mac   CoreCLR   50000-SingleObject-Match
00:00:02.0852454 20        7.1.3     Mac   CoreCLR   100000-SingleObject-Match
00:00:02.5230304 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject-Match
00:00:03.1143274 20        7.1.3     Mac   CoreCLR   50000-SingleObject_Hash+init
00:00:04.5424903 20        7.1.3     Mac   CoreCLR   50000-IF-SingleObject_Hash+init
00:00:06.6026457 20        7.1.3     Mac   CoreCLR   100000-IF-SingleObject_Hash+init
00:00:06.8398183 20        7.1.3     Mac   CoreCLR   100000-SingleObject_Hash+init

The multipleObject tests:
These tests is looking for each number in the array that has been shuffled, so if the array is 5, there's just 5 numbers and is looking for them
There's no consideration to evaluation. 
If the previous test is correct, it will add more time to evaluate it.

Only 3 methods are okey when handling loads of queueries (Sub 1sec)
-Contains, -Eq and $hash[objects]

These took more than 1sec to complete
00:00:27.5465994 100000    7.1.3     Mac   CoreCLR   multipleObject_IndexOf
00:00:28.5855203 100000    7.1.3     Mac   CoreCLR   multipleObject_Contains()
00:08:00.4000155 100000    7.1.3     Mac   CoreCLR   multipleObject_MatchJoinedString
00:12:02.1027325 100000    7.1.3     Mac   CoreCLR   multipleObject_In
00:35:50.3172273 100000    7.1.3     Mac   CoreCLR   multipleObject_Match


Time             TimesExec PSVersion OS    CLR       Name
----             --------- --------- --    ---       ----
00:00:00.0001671 50        7.1.3     Mac   CoreCLR   multipleObject_EQ
00:00:00.0001716 50        7.1.3     Mac   CoreCLR   multipleObject_IndexOf
00:00:00.0001737 50        7.1.3     Mac   CoreCLR   multipleObject_Contains
00:00:00.0002052 50        7.1.3     Mac   CoreCLR   multipleObject_Contains()
00:00:00.0002884 50        7.1.3     Mac   CoreCLR   multipleObject_Hash
00:00:00.0003296 50        7.1.3     Mac   CoreCLR   multipleObject_In
00:00:00.0004624 50        7.1.3     Mac   CoreCLR   multipleObject_MatchJoinedString
00:00:00.0020300 50        7.1.3     Mac   CoreCLR   multipleObject_Match
00:00:00.0031493 1000      7.1.3     Mac   CoreCLR   multipleObject_Contains
00:00:00.0033261 1000      7.1.3     Mac   CoreCLR   multipleObject_EQ
00:00:00.0053624 1000      7.1.3     Mac   CoreCLR   multipleObject_Contains()
00:00:00.0058194 1000      7.1.3     Mac   CoreCLR   multipleObject_IndexOf
00:00:00.0060448 1000      7.1.3     Mac   CoreCLR   multipleObject_Hash
00:00:00.0206522 1000      7.1.3     Mac   CoreCLR   multipleObject_MatchJoinedString
00:00:00.0261168 10000     7.1.3     Mac   CoreCLR   multipleObject_EQ
00:00:00.0271864 10000     7.1.3     Mac   CoreCLR   multipleObject_Contains
00:00:00.0503473 10000     7.1.3     Mac   CoreCLR   multipleObject_Hash
00:00:00.0709323 1000      7.1.3     Mac   CoreCLR   multipleObject_In
00:00:00.1238562 50000     7.1.3     Mac   CoreCLR   multipleObject_Contains
00:00:00.1253860 50000     7.1.3     Mac   CoreCLR   multipleObject_EQ
00:00:00.2300852 100000    7.1.3     Mac   CoreCLR   multipleObject_Contains
00:00:00.2381827 100000    7.1.3     Mac   CoreCLR   multipleObject_EQ
00:00:00.2584837 1000      7.1.3     Mac   CoreCLR   multipleObject_Match
00:00:00.2788334 50000     7.1.3     Mac   CoreCLR   multipleObject_Hash
00:00:00.2836186 10000     7.1.3     Mac   CoreCLR   multipleObject_Contains()
00:00:00.2906353 10000     7.1.3     Mac   CoreCLR   multipleObject_IndexOf
00:00:00.4801512 100000    7.1.3     Mac   CoreCLR   multipleObject_Hash
00:00:03.3183671 10000     7.1.3     Mac   CoreCLR   multipleObject_MatchJoinedString
00:00:06.7485685 50000     7.1.3     Mac   CoreCLR   multipleObject_IndexOf
00:00:06.8171061 50000     7.1.3     Mac   CoreCLR   multipleObject_Contains()
00:00:07.6187884 10000     7.1.3     Mac   CoreCLR   multipleObject_In
00:00:22.4004684 10000     7.1.3     Mac   CoreCLR   multipleObject_Match
00:00:27.5465994 100000    7.1.3     Mac   CoreCLR   multipleObject_IndexOf
00:00:28.5855203 100000    7.1.3     Mac   CoreCLR   multipleObject_Contains()
00:01:40.5499198 50000     7.1.3     Mac   CoreCLR   multipleObject_MatchJoinedString
00:02:59.8489711 50000     7.1.3     Mac   CoreCLR   multipleObject_In
00:08:00.4000155 100000    7.1.3     Mac   CoreCLR   multipleObject_MatchJoinedString
00:08:28.1726827 50000     7.1.3     Mac   CoreCLR   multipleObject_Match
00:12:02.1027325 100000    7.1.3     Mac   CoreCLR   multipleObject_In
00:35:50.3172273 100000    7.1.3     Mac   CoreCLR   multipleObject_Match
#>