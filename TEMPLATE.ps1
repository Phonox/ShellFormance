$randomWord = "stuff"
$Sample = 7
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"
$tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
  $assert = ""
  $splat = @{Sample = $Sample ; Assert = $assert}
  Write-Information "---- LOOP $loop ----"
    $TheseTests = @()
    $TheseTests += Test-Performance @splat -Name "|SimpleFunction1" -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |SimpleFunction1 }
    $TheseTests| Foreach-Object { $_."TimesExec" = $loop ; $_ } # in case if -repeat is not applicable
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure
