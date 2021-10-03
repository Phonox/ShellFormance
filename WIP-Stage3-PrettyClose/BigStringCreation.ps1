# StringCreation
$tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    Write-Information "---- LOOP $loop ----"
    $assert = 1..$loop -join ","
    @(
        @{Name='JoinC#';       ScriptBlock={ [string]::Join(",",(1..$loop) ) } },
        @{Name='PS-Join';      ScriptBlock={ 1..$loop -join "," } },
        @{Name='foreach1';     ScriptBlock={ foreach($word in 1..$loop){if ($item -eq 1) {$newword = $word}else{ [string]::Concat($NewWord,",$word") } } } },
        @{Name='StringBuilder';ScriptBlock={
$test = [System.Text.StringBuilder]::new()
foreach($item in 1..$loop){
    if ($item -eq 1) {
    $test.Append($item)}else{
    $test.AppendFormat(", {0}",$loop )}
}
$test.ToString()} }

        #@{Name='Format';       ScriptBlock={[string]::Format('Hello{0}{1}.',$first,$last)}},
        #@{Name='ConcatPS';     ScriptBlock={"hello" + "$first" + "$last" }},
        #@{Name='ConcatPSAsLit';ScriptBlock={'hello' + $first + $last }},
        #@{Name='DynamicString';ScriptBlock={"hello$first$last" }},
        #@{Name='QuickFormat';  ScriptBlock={'Hello{0}{1}.' -f $first, $last} },
        #@{Name='ConcatC#';     ScriptBlock={[string]::Concat('hello',$first,$last) } }
        # place for StringBuilder
    ).Foreach{ [PSObject]::New($_) } |Test-Performance |& {Process {$_.TimesExec = $loop; $_}}
} )
# $tests | Sort-Object Time
$m = Measure-PerformanceScore $tests | Sort-Object TotalScore
$m