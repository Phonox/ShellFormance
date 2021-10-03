#Best Pipe functions / How to write most effective small code-body pipe functions

# from https://powershell.one/tricks/performance/pipeline
function Foreach-ObjectFast
{
  param
  (
    [ScriptBlock]
    $Process,
    
    [ScriptBlock]
    $Begin,
    
    [ScriptBlock]
    $End
  )
  
  begin
  {
    # construct a hard-coded anonymous simple function from
    # the submitted scriptblocks:
    $code = @"
& {
  begin
  {
    $Begin
  }
  process
  {
    $Process
  }
  end
  {
    $End
  }
}
"@
    # turn code into a scriptblock and invoke it
    # via a steppable pipeline so we can feed in data
    # as it comes in via the pipeline:
    $pip = [ScriptBlock]::Create($code).GetSteppablePipeline()
    $pip.Begin($true)
  }
  process 
  {
    # forward incoming pipeline data to the custom scriptblock:
    $pip.Process($_)
  }
  end
  {
    $pip.End()
  }
}

# from https://powershell.one/tricks/performance/pipeline
function Where-ObjectFast
{
  param
  (
    [ScriptBlock]
    $FilterScript
  )
  
  begin
  {
    # construct a hard-coded anonymous simple function:
    $code = @"
& {
  process { 
    if ($FilterScript) 
    { `$_ }
  }
}
"@
    # turn code into a scriptblock and invoke it
    # via a steppable pipeline so we can feed in data
    # as it comes in via the pipeline:
    $pip = [ScriptBlock]::Create($code).GetSteppablePipeline()
    $pip.Begin($true)
  }
  process 
  {
    # forward incoming pipeline data to the custom scriptblock:
    $pip.Process($_)
  }
  end
  {
    $pip.End()
  }
}

$SimpleMethod = {Param([Parameter(ValueFromPipeline)]$stuff) Process{"$stuff"}}
function SimpleFunction1 { Param()Process{$_} }
function SimpleFunction2 { Param([Parameter(ValueFromPipeline)]$stuff)Process{$stuff } }
function SimpleFunction3 { [CmdletBinding()]Param([Parameter(ValueFromPipeline)]$stuff)Process{$stuff} }
function SimpleFunction4 { [CmdletBinding(SupportsShouldProcess)]Param([Parameter(ValueFromPipeline)]$stuff)Process{$stuff} }

$randomWord = "stuff"
$Sample = 7
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    $assert = ( [system.Collections.ArrayList]@("$randomWord`n" * $loop -split "`n") )
    $splat = @{Sample = $Sample ; Assert = $assert}

    Write-Information "---- LOOP $loop ----"
    $assert.RemoveAt( $assert.count -1)
    $TheseTests = @()
    $TheseTests += Test-Performance @splat -Name "|SimpleFunction1" -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |SimpleFunction1 }
    $TheseTests += Test-Performance @splat -Name "|SimpleFunction2" -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |SimpleFunction2 }
    $TheseTests += Test-Performance @splat -Name "|SimpleFunction3" -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |SimpleFunction3 }
    $TheseTests += Test-Performance @splat -Name "|SimpleFunction4" -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |SimpleFunction4 }
    $TheseTests += Test-Performance @splat -Name "|AnonymousFunc"   -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |& {Process{"$_"} } }
    $TheseTests += Test-Performance @splat -Name "|& SimpleMethod"  -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |& $SimpleMethod }
    $TheseTests += Test-Performance @splat -Name "|Foreach2.0"      -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |Foreach-ObjectFast -Process {"$_"} }
    $TheseTests += Test-Performance @splat -Name "|Foreach"         -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |Foreach-Object -Process {"$_"} }
    $TheseTests += Test-Performance @splat -Name "|Foreach{}{}{}"   -ScriptBlock { (1..$loop).ForEach{"$RandomWord"} |Foreach-Object -Begin {} -Process {"$_"} -End {} }
    $TheseTests| Foreach-Object { $_."TimesExec" = $loop ; $_ }
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure