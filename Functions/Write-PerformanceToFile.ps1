function Write-PerformanceToFile{
    Param(
        $ScriptFilePath,
        $Measure,
        $AllTests
    )
    Begin{
        $modPath = Get-Module Shellformance
        $PathResult = Join-Path $modPath.ModuleBase  "Results"
        $PSV = $PSVersionTable.PSVersion.ToString()
    }
    Process{
        $Name = (Split-Path -Leaf $ScriptFilePath) -replace '\.ps\w?1'
        $OS = $AllTests[0].OS

        $Path = Join-Path $PathResult "$Name-$PSV-$OS.csv"
        Export-PerformanceResults -Items ($AllTests|Sort-Object Time) -Path $Path
        $Path = Join-Path $PathResult "$Name-Results-$PSV-$OS.csv"
        Export-PerformanceResults -Items ($Measure|Sort-Object TotalScore) -Path $Path
    }
}
Export-ModuleMember -Function Write-PerformanceToFile -ea ignore