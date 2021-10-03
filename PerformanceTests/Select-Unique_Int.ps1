<#
This comes from
https://ridicurious.com/2018/04/13/unique-items-in-powershell/
#>
$Sample = 4
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000){
    $array = 1..$tries
    $array += $array |Get-Random -Count ([math]::round( $loop/3) + 1 )
    $assert = ([System.Collections.Generic.HashSet[int]]( $array ) )
    $splat = @{ Assert = $assert ; Samples = $Sample}
    $TheseTests = @()
    Write-Information "---- LOOP $tries ----"
    $TheseTests += Test-Performance Select-Object   @splat -sb { $array | Select-Object -Unique }
    $TheseTests += Test-Performance Sort-Object     @splat -sb { $array | Sort-Object -Unique }
    $TheseTests += Test-Performance Get-Unique      @splat -sb { $array | Sort-Object |Get-Unique }
    $TheseTests += Test-Performance Generic.HashSet @splat -sb { ( [System.Collections.Generic.HashSet[int]]( $array ) ) }
    $TheseTests += Test-Performance Linq-Distinct   @splat -sb { [Linq.Enumerable]::Distinct([int[]]@( $array ) ) }
    $TheseTests| Foreach-Object { $_."TimesExec" = $loop ; $_ }
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure

