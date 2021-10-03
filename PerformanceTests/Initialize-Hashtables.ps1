$Sample = 7
$ErrorActionPreference = 'Stop'
$InformationPreference = "Continue"

$Tests = @( foreach ( $loop in 1,3,8,13,21,100,1000,10000,100000){
    # https://ridicurious.com/2019/10/04/11-ways-to-create-hashtable-in-powershell/
    Write-Information "---- LOOP $loop ----"
    $splat = @{Sample = $Sample ; repeat = $loop}
    (
        @{Name='NEWObjectHash'; ScriptBlock={ $hash = New-Object Hashtable @{} } },
        @{Name='NEWDictStrStr'; ScriptBlock={ $Dictionary = New-Object 'System.Collections.Generic.Dictionary[String,String]' } },
        @{Name='NEWObject';     ScriptBlock={ $hash = New-Object System.Collections.Hashtable } },
        @{Name='QuickInstance'; ScriptBlock={ $hash = @{} } },
        @{Name='hashTableNEW';  ScriptBlock={ $hash = [hashtable]::new() } },
        @{Name='DictStrStrNEW'; ScriptBlock={ $Dictionary = [System.Collections.Generic.Dictionary[String,String]]::new() } },
        @{Name='DictStrIntNEW'; ScriptBlock={ $Dictionary = [System.Collections.Generic.Dictionary[string,int]]::new() } },
        @{Name='HashNEW';       ScriptBlock={ $Hashtable =  [System.Collections.Specialized.OrderedDictionary]::new() } },
        @{Name='HereHash';      ScriptBlock={ $HereHash = "" |ConvertFrom-StringData } }
    ).Foreach{ [pscustomobject]$_} |Test-Performance @splat
} )

$Measure = Measure-PerformanceScore $Tests |Sort-Object TotalScore
Write-PerformanceToFile -ScriptFilePath $MyInvocation.MyCommand.path -Measure $Measure -AllTests ($Tests|Sort-Object Time)
$Measure

<#
@{Name='HereHash';      ScriptBlock={ $HereHash = @"
name='test'
"@|ConvertFrom-StringData } }

TL;DR; for instantiating hashtables
Use these:
NEWHash       [System.Collections.Specialized.OrderedDictionary]::new()
hashTableNEW  [hashtable]::new()
QuickInstance @{}
DictStrInt    [System.Collections.Generic.Dictionary[string,int]]::new()
DictStrStr    [System.Collections.Generic.Dictionary[string,string]]::new()

Do not use 
New-Object to create anykind of hashtable and preferably not ConvertFrom-StringData either
NEWDictStrStr    New-Object 'System.Collections.Generic.Dictionary[String,String]'
NEWObjectHash New-Object Hashtable @{}
NEWObject     New-Object System.Collections.Hashtable
HereHash      "" |ConvertFrom-StringData
#>