Function RunAllTests{
    $modPath = Get-Module Shellformance
    $PathToTests = Join-Path $modPath.ModuleBase  "PerformanceTests"
    $AllTestPaths = Get-ChildItem $PathToTests -file #| Select-Object -First 1
    $Jobs = @(Foreach($path in $AllTestPaths){
        $leaf = split-path -leaf $path
        Start-Job -InitializationScript {Import-Module ../Shellformance.psd1 -DisableNameChecking} -ScriptBlock { . $using:Path } -Verbose -WorkingDirectory $PathToTests -name $leaf
    } )
    Write-Information "All jobs have started! Count`: $($jobs.count)"
    # wait-job $jobs
}
Export-ModuleMember -function RunAllTests -ea ignore