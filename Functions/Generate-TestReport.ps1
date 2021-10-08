Function Generate-TestReport {
    $modPath    = Get-Module Shellformance
    $PathResult = Join-Path $modPath.ModuleBase  "Results"
    $PathDocs   = Join-Path $modPath.ModuleBase  "Docs"
    $PathIndex  = Join-Path $PathDocs 'Index.md'
    $Pathtests  = Join-Path $modPath.ModuleBase PerformanceTests
    $TestFiles  = (Get-ChildItem $Pathtests).Name -replace '\.ps1'

    if ( !(Test-Path $PathDocs)) {$null = New-Item -ItemType Directory $PathDocs -Force}
    $MDIndex = [System.Collections.ArrayList]@(
        "# Summary of all tests"
        "## Information",
        "- There's little to no explaination to what or why stuff workas as it does.",
        "- Assert feature, is not 100% correct, still WIP. For instance, similar code could return an [hashtable] object vs Dictionary from System.Collections.Generic.Dictionary[String,String].",
        "- This is for now a technical overview how similar code runs differently depending on how you write the code, difference of OS and soon PSVersion.",
        "- As of this moment. All tests have a small body(i.e. very little code that executes)",
        "- The score system is relative to lowest to highest time execution of each code.",
        "- 1 is the best score a test can have, nothing can have lower than 1, as that represents best time. Low volume is tests with 'repetitions less than 100' and high is 'repetitions greater or equal to 100' and then calculate the sum of it.",
        "- If the first test have 1 in score, second place is 2, then it took 2x time to execute or 100% more time."
    )

    Foreach($file in $TestFiles){
        $Object = Join-Path $PathResult $file
        $AllResultsOfTest = Get-ChildItem $Object*
        $MDFilePath = Join-Path $PathDocs "$file.md"
        # Summary
        $AllSummaries = foreach( $item in $AllResultsOfTest) { if ($item.Name -Cmatch '-Results-'){$item} }
        if ($AllSummaries){ # Make sure there are files.
            $CSVsummary   = foreach( $item in $AllSummaries) { Import-Csv -Path $item.FullName | Add-Member -NotePropertyName OS -NotePropertyValue ($item[0].name -replace '.*\d-(\w+)\.csv$','$1') -Force -PassThru}
            Foreach( $row in $CSVsummary ) { 
                Try{$Row.TotalScore= [convert]::ToDecimal( ($Row.TotalScore -replace '\.',',') ); $Row.LowVolume = [convert]::ToDecimal( ($Row.LowVolume -replace '\.',',') ); $Row.HighVolume = [convert]::ToDecimal( ($Row.HighVolume -replace '\.',',') )
                }Catch{
                    $_
                }
            }
            $CSVSummary   = $CSVSummary | Sort-Object TotalScore

            # Whole file
            $AllWholeReports = foreach( $item in $AllResultsOfTest) { if ($item.Name -cnotmatch '-Results-'){$item} }
            $CSVWholeReports = foreach( $item in $AllWholeReports) { Import-Csv -Path $item.FullName | Add-Member -NotePropertyName OS -NotePropertyValue ($item[0].name -replace '.*\d-(\w+)\.csv$','$1') -Force -PassThru}
            Foreach( $row in $CSVWholeReports ) { $Row.Score= [convert]::ToDecimal( ($Row.Score -replace '\.',',') ) ; $Row.TimesExec= [convert]::ToInt32( $Row.TimesExec )}
            $CSVWholeReports = $CSVWholeReports | Sort-Object TimesExec,Score
            
            $MDSummaryTable = ConvertTo-MarkDownTable $CSVSummary
            $MDWholeTable   = ConvertTo-MarkDownTable $CSVWholeReports

            $null = $MDIndex.Add( "## $File" )
            $null = $MDIndex.Add( "Full report: [$File]($( (Resolve-Path -Relative $MDFilePath) -replace '^\.' -replace '\\','/' ))<br/>" )
            $null = $MDIndex.Add( "Code: [$File]($( (Resolve-Path -Relative "$Pathtests\$file.ps1") -replace '^\.' -replace '\\','/' ) )" )
            $MDIndex.AddRange( $MDSummaryTable )
            #$null = $MDIndex.Add( "" )
            @("# $file","## Index",'- Description',"- Summary","- Full report",'## Description',"There's no explaination to anything yet, to be decided. But this describes how code runs differently and also depending on OS.<br/>","To find the code: [$File]($( (Resolve-Path -Relative "$Pathtests\$file.ps1") -replace '^\.' -replace '\\','/' ) )","## Summary",$MDSummaryTable, "## Full report",$MDWholeTable) | Out-File -FilePath $MDFilePath
        }
    }
    Out-File -InputObject $MDIndex -FilePath $PathIndex -Force
}

Function ConvertTo-MarkDownTable {
    Param(
        [Parameter(ValueFromPipeline)]
        $Objects
    )
    Begin{$StuffToProcess = [System.Collections.ArrayList]@()}
    Process{
        $null = $StuffToProcess.AddRange( @($Objects) )
    }
    End{
        Foreach($item in $StuffToProcess){
            $item.name = $item.name -replace '\|','l'
        }
        $Convert = [System.Collections.ArrayList]@(( $StuffToProcess |ConvertTo-CSV -Delimiter "|" -NoTypeInformation) -replace '"' ) 
        $ExtraRow = "---|" * ($Convert[0].split('|').count -1 ) + '---'
        $Convert.Insert(1,$ExtraRow)
        $Convert -replace '^|$','|'
    }
}

Export-ModuleMember -function Generate-TestReport