function smaller_branchless ([int]$a,[int]$b) {
    return ($a -lt $b)
}
Function Smaller ([int]$a,[int]$b) {
    if ($a -lt $b) {
        return $true
    }else {
        return $false
    }
}
Function AdvSmaller {
    [CmdletBinding()]
    Param([int]$a,[int]$b)
    Process{
        if ($a -lt $b) {
            return $true
        }else {
            return $false
        }
    }
}

Function AdvSmallerPiped {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$a,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$b
        )
    Process{
        if ($a -lt $b) {
            return $true
        }else {
            return $false
        }
    }
}
$ErrorActionPreference = "Stop"
$anonymusBranchLessFunction = {Param($a,$b) $a -lt $b}

$obj = [PSCustomObject]@{a=2;b=4}
$objhash = @{a=2;b=4}
$tests = @()
$Samples = 1
foreach($tries in 100){
    $tests += [PSCustomObject]@{
        Name = "Smaller_branchless"
        ScriptBlock = {Smaller_branchless 4 5}
    },
    [PSCustomObject]@{
        Name = "Smaller"
        ScriptBlock = {Smaller 4 5}
    },
    [PSCustomObject]@{
        Name = "NoFunction" 
        ScriptBlock = { 4 -lt 5 } 
    },
    [PSCustomObject]@{
        Name = "NoFunctionIF" 
        ScriptBlock = { if (4 -lt 5) {} }
    },
    [PSCustomObject]@{
        Name = "AdvSmaller" 
        ScriptBlock = {AdvSmaller 4 5}
    },
    [PSCustomObject]@{
        Name = "AdvSmallerPipedSinglets" 
        ScriptBlock = {$obj | AdvSmallerPiped}
    },
    [PSCustomObject]@{
        Name = "anonymusBranchLessFunction" 
        ScriptBlock = {$anonymusBranchLessFunction.Invoke( 4, 5 )}
    } | Test-Performance -repeat $tries -Samples $Samples -InformationAction Continue
    #$tests += Test-Performance Smaller_branchless {Smaller_branchless 4 5} -repeat $tries
    #$tests += Test-Performance Smaller {Smaller 4 5} -repeat $tries
    # $tests += Test-Performance NoFunction { 4 -lt 5 } -repeat $tries
    # $tests += Test-Performance NoFunctionIF { if (4 -lt 5) {} } -repeat $tries
    # $tests += Test-Performance AdvSmaller {AdvSmaller 4 5} -repeat $tries
    # $tests += Test-Performance AdvSmallerPipedSinglets {$obj | AdvSmallerPiped} -repeat $tries
    # $tests += Test-Performance anonymusBranchLessFunction {$anonymusBranchLessFunction.Invoke( 4, 5 )} -repeat $tries
}

foreach($tries in 100){
    $objects = for($int=0;$int -lt $tries; $int++){$obj}
    $objectshash = for($int=0;$int -lt $tries; $int++){$objhash}
    [PSCustomObject]@{
        Name = "AdvSmallerPiped" 
        ScriptBlock = { $objects | AdvSmallerPiped } 
    },
    #$tests += Test-Performance AdvSmallerPiped { $objects | AdvSmallerPiped } -repeat 1 | Add-Member -NotePropertyName TimesExec -NotePropertyValue $tries -Force -PassThru
    [PSCustomObject]@{
        Name = "NoFunctionForeachIF"  
        ScriptBlock = { Foreach($it in $objects){ 4 -lt 5 } }
    },
    [PSCustomObject]@{
        Name = "NoFunctionForeach"  
        ScriptBlock = { Foreach($it in $objects){ if (4 -lt 5){} } }
    },
    
    # $tests += Test-Performance NoFunctionForeachIF { Foreach($it in $objects){ 4 -lt 5 } }      | Add-Member -NotePropertyName TimesExec -NotePropertyValue $tries -Force -PassThru
    # $tests += Test-Performance NoFunctionForeach { Foreach($it in $objects){ if (4 -lt 5){} } } | Add-Member -NotePropertyName TimesExec -NotePropertyValue $tries -Force -PassThru
    [PSCustomObject]@{
        Name = "SPLATSmaller_branchless"
        ScriptBlock = { foreach($Splat in $objectshash) {Smaller_branchless @Splat} }
    },
    [PSCustomObject]@{
        Name = "SPLATSmaller"
        ScriptBlock = { foreach($Splat in $objectshash) {Smaller @Splat } }
    },
    [PSCustomObject]@{
        Name = "SPLATAdvSmaller" 
        ScriptBlock = { foreach($Splat in $objectshash) {AdvSmaller @Splat  } }
    } | Test-Performance -Repeat $tries -Samples $Samples -InformationAction Continue | Add-Member -NotePropertyName TimesExec -NotePropertyValue $tries -Force -PassThru

    # $tests += Test-Performance SPLATSmaller_branchless { foreach($Splat in $objectshash) {Smaller_branchless @Splat} } | Add-Member -NotePropertyName TimesExec -NotePropertyValue $tries -Force -PassThru
    # $tests += Test-Performance          | Add-Member -NotePropertyName TimesExec -NotePropertyValue $tries -Force -PassThru
    # $tests += Test-Performance SPLATAdvSmaller         { foreach($Splat in $objectshash) {AdvSmaller @Splat  } }       
    # Cannot splat Anonymus function
    # $tests += Test-Performance SPLATanonymusBranchLessFunction { foreach( $Splat in $objectshash) {$anonymusBranchLessFunction.Invoke( $Splat.a,$Splat.b ) } } | Add-Member -NotePropertyName TimesExec -NotePropertyValue $tries -Force -PassThru
}

# $UpdatedTests = @()
# # $ObjectType = $tests[0].PSObject.Copy()
# Foreach( $timesExec in $tests | Group-Object TimesExec ) {
#     Foreach ($group in $timesExec.Group | Group-Object Name ){
        
#         $results = $group.Group.Time | Measure-Object -Sum -Average -Maximum -Minimum Ticks

#         $New = [PSCustomObject]@{
#             PSTypeName = "TestResultsIndividual"
#             Name = $Group.Name
#             Time = [TimeSpan]::FromTicks($results.Sum)
#             TimesExec = $Group.Group[0].TimesExec
#             PSVersion = $Group.Group[0].PSVersion
#             OS  = $Group.Group[0].OS
#             CLR = $Group.Group[0].CLR
#             Avg = [TimeSpan]::FromTicks($results.Average)
#             Min = [TimeSpan]::FromTicks($results.Minimum)
#             Max = [TimeSpan]::FromTicks($results.Maximum)
#         }
#         $updatedTests += $New
#     }
# }

# $updatedTests |Sort-Object Time
$tests |Sort-Object TimesExec,Time