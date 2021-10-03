$Sample = 10
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
  $splat = @{Repeat = $loop ; Sample = $sample}
  Write-Information "---- LOOP $loop ----"
    @(
        @{Name='Null=stuff'   ; ScriptBlock= { $null = "awdawd" } } ,
        @{Name='[Void]Stuff'  ; ScriptBlock= { [void] "awdawd"    } } ,
        @{Name='Stuff>Null'   ; ScriptBlock= { "awdawd" >$null    } } ,
        @{Name='Stuff*>Null'  ; ScriptBlock= { "awdawd" *>$null    } } ,
        @{Name='Stuff|OutNull'; ScriptBlock= { "awdawd" |Out-Null } }
    ).Foreach{ Test-Performance @splat @_}
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure
