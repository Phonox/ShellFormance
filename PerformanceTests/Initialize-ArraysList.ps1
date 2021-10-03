# ArrayLists
$Sample = 10
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    Write-Information "---- LOOP $loop ----"
    $splat = @{Sample = $Sample ; repeat = $loop}
    @(
        @{Name='ArrayList'       ; ScriptBlock= { $null = [system.collections.ArrayList]::New()   } } ,
        @{Name='NewObject'       ; ScriptBlock= { $null = New-Object System.Collections.ArrayList } } ,
        @{Name='QuickInstance'   ; ScriptBlock= { $null = [System.Collections.ArrayList]@() }  } ,
        @{Name='QuickInstanceNEW'; ScriptBlock= { $null = [System.Collections.ArrayList]::new() } }
        # Space for using system.Collections
    ).Foreach{ Test-Performance @splat @_ }
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure

<#
TL;DR
When creating arraylist, New-object is the only way which should be avoided
#>