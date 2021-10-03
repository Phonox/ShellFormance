# StringCreation
$first= ' test ';
$last='stand'
$tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    Write-Information "---- LOOP $loop ----"
    $assert = [string]::Format('Hello{0}{1}.',$first,$last)
    @(
        @{Name='Format';       ScriptBlock={[string]::Format('Hello{0}{1}.',$first,$last)}},
        @{Name='ConcatPS';     ScriptBlock={"hello" + "$first" + "$last" }},
        @{Name='ConcatPSAsLit';ScriptBlock={'hello' + $first + $last }},
        @{Name='strInterpolation';ScriptBlock={"hello$first$last" }},
        @{Name='QuickFormat';  ScriptBlock={'Hello{0}{1}.' -f $first, $last} },
        @{Name='ConcatC#';     ScriptBlock={[string]::Concat('hello',$first,$last) } },
        @{Name='JoinC#';       ScriptBlock={[string]::Join("",@('hello',$first,$last) ) } },
        @{Name='PS-Join';      ScriptBlock={"Hello",$first,$last -join ""} }
        # place for StringBuilder
    ).Foreach{ [pscustomobject]$_ } |Test-Performance -Repeat $loop # -Assert $assert
} )
# $tests | Sort-Object Time
$m = Measure-PerformanceScore $tests | Sort-Object TotalScore
$m