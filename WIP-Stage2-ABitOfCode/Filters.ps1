# Filters

$SomeImportantArray = [System.Collections.Arraylist]@()
Foreach ($stuff in 1..100) {
    $null = $SomeImportantArray.Add((
        [PSCustomObject]@{
            First = $Stuff
            Second = $stuff * 2
            Third = $stuff * 3
        }
    ))
}

$BigArray = [System.Collections.Arraylist]@()
Foreach ($stuff in 1..500) {
    $null = $BigArray.Add((
        [PSCustomObject]@{
            First = $Stuff % 20
            Second = $stuff * 2
            Third = ([int]($stuff * 3 / 5))
        }
    ))
}

<#

# REQUIREMENT - There should be no "" in the array
#>

$hash = @{}
foreach($it in $SomeImportantArray) {$hash[$it.First] = $it }

# Reference Count is 167
$Tests = @()
#foreach ($time in 1..6 ) {
        $Assert = $BigArray | Where-Object { $SomeImportantArray.First -eq $_.Third }

    $Tests += Test-Performance -Samples 7 -Name "Where-Object" {
        $BigArray | Where-Object { $SomeImportantArray.First -eq $_.Third }
    } -Assert $Assert

    $Tests += Test-Performance -Samples 7 -Name "Foreach-Object" {
        $BigArray | Foreach-Object { if ($SomeImportantArray.First -eq $_.Third){$_} }
    } -Assert $Assert

    $Tests += Test-Performance -Samples 7 -Name "Foreach(){}" { # Start of Branchless programming
        Foreach ( $b in $BigArray) {
            Foreach ( $item in $SomeImportantArray.First -eq $b.Third) { $b }
        }
    } -Assert $Assert
    
    $Tests += Test-Performance -Samples 7 -Name "Foreach(){}IF" {
        Foreach ( $b in $BigArray) {
            if ($SomeImportantArray.First -eq $b.Third) { $b }
        }
    } -Assert $Assert

    $Tests += Test-Performance -Samples 7 -Name "HashIF" {
        Foreach ( $b in $BigArray) {
            if ($hash[$b.Third] ) { $b }
        }
    } -Assert $Assert

    $Tests += Test-Performance -Samples 7 -Name "HashAndForeach" {
        Foreach ( $b in $BigArray) {
            foreach ( $a in $hash[$b.Third] ) { $b }
        }
    } -Assert $Assert
    #$Tests += Test-Performance -Name "SelectString" {
    #    # $Global:Check6 = 
    #    $null = (Select-String -input $BigArray "^$rand$" -AllMatches)
    #}
#}
#$Tests |Sort-Object Time
Measure-PerformanceScore $tests
#foreach ( $it in $Check1.count -eq $Check2.count -and $Check1.count -eq $Check3.count -and $Check1.count -eq $Check4.count -and $Check1.count -eq $Check5.count, 
#($check3 |ConvertTo-Json) -eq ($check2 |ConvertTo-Json), 
#($check1 |ConvertTo-Json) -eq ($check2 |ConvertTo-Json), 
#($check3 |ConvertTo-Json) -eq ($check3 |ConvertTo-Json), 
#($check1 |sort-object First,Second,Third | convertTo-Json) -eq ($check5 |Sort-Object First,Second,Third |ConvertTo-Json) ) {
#    Write-host "Success`: $it"
#}
