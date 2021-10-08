$Sample = 7
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    Write-Information "---- LOOP $loop ----"
    $assert = @( Foreach( $item in 1..$loop){ [PSCustomObject]@{Item = 1} } )
    $splat = @{Sample = $Sample ; Assert = $assert ; Repeat = $loop }
    $Less  = @{Sample = $Sample ; Repeat = $loop }
    Test-Performance @splat -Name 'NewPSObjCUSTOM'     -SB { New-Object -TypeName PSCUSTOMObject -Property @{Item = 1} } 
    Test-Performance @splat -Name 'NewPSObj'           -SB { New-Object -TypeName PSObject -Property @{Item = 1} } 
    Test-Performance @splat -Name 'CastCUSTOMHash1'    -SB { [PSCUSTOMObject]@{Item = 1} }
    Test-Performance @Less  -Name 'CastHash1'          -SB { [PSObject]@{Item = 1} }
    Test-Performance @Less  -Name 'NewPSobjHASH'       -SB { [PSobject]::new(@{Item = 1} ) }
    Test-Performance @Less  -Name 'NewPSobjCUSTOMHASH' -SB { [PSCUSTOMobject]::new(@{Item = 1} ) }
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure

<#
WINNER 
[PSCustomobject]::new( @{Item = 1} ) But this is not an PSCustomObject, this is an PSObject/HashTable!
#>