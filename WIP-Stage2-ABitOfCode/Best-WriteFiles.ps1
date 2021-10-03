# Write to file
<#
Requirements
Encoding UTF8

Stuff to go through
xmlbuilder
stringbuilder
+= "new string"
out-file
Add-Content
#>
$Encoding = 'UTF8'
#$OutputEncoding = [System.Text.Encoding]::$Encoding

$ErrorActionPreference = 'Stop'
$Sample = 7
$InformationPreference = "Continue"
$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    $assert = "stuff"

} )
$Measure = Measure-PerformanceScore $Tests
$Name = $( (Split-Path -Leaf $MyInvocation.MyCommand.path) -replace '\.ps\w?1')
$Path = Join-Path (Join-Path (Split-Path $PSScriptRoot -Parent ) "Results") "$Name-$($tests[0].PSVersion.Substring(0,1) ).csv"
Export-PerformanceResults -Items ($Tests|Sort-Object Time) -Path $Path
$Path = Join-Path (Join-Path (Split-Path $PSScriptRoot -Parent ) "Results") "$Name-Results-$($tests[0].PSVersion.Substring(0,1) ).csv"
Export-PerformanceResults -Items ($Measure|Sort-Object TotalScore) -Path $Path
$Measure
