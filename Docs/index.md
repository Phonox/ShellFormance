# Summary of all tests
## Information
- There's little to no explaination to what or why stuff workas as it does.
- Assert feature, is not 100% correct, still WIP. For instance, similar code could return an [hashtable] object vs Dictionary from System.Collections.Generic.Dictionary[String,String].
- This is for now a technical overview how similar code runs differently depending on how you write the code, difference of OS and soon PSVersion.
- As of this moment. All tests have a small body(i.e. very little code that executes)
- The score system is relative to lowest to highest time execution of each code.
- 1 is the best score a test can have, nothing can have lower than 1, as that represents best time. Low volume is tests with 'repetitions less than 100' and high is 'repetitions greater or equal to 100' and then calculate the sum of it.
- If the first test have 1 in score, second place is 2, then it took 2x time to execute or 100% more time.
## Best-Loops
### Links
- Full report: [Best-Loops.md](/Docs/Best-Loops.md)
- Code: [Best-Loops.ps1](/PerformanceTests/Best-Loops.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|Foreach(){}|1,0000|1,0000|1,0000|True|Win|
|For(){}|2,0496|1,3916|2,8721|True|Win|
|lAnonymusPipe|2,2387|2,2074|2,2779|True|Win|
|lAnonymusPipeVar|2,2989|2,3336|2,2556|True|Win|
|Do{}Until()|2,3107|1,7620|2,9966|True|Win|
|While(){}|2,3245|1,7975|2,9832|True|Win|
|Do{}Until()|2,5155|1,6016|3,6579|True|Mac|
|Do{}While()|2,7955|1,4058|4,5327|True|Mac|
|Do{}While()|2,8609|3,0821|2,5844|True|Win|
|While(){}|3,3114|2,5765|4,2299|True|Mac|
|.Foreach({})|4,1373|3,3428|5,1305|True|Win|
|Foreach(){}|4,6169|7,5104|1,0000|True|Mac|
|For(){}|4,9397|4,5857|5,3821|True|Mac|
|lForeach{}|8,0219|6,3213|10,1477|True|Win|
|lAnonymusPipe|8,7136|12,9089|3,4695|True|Mac|
|lAnonymusPipeVar|14,3871|23,9059|2,4885|True|Mac|
|.Foreach({})|14,5938|12,1676|17,6266|True|Mac|
|lForeach{}|44,6627|53,3286|33,8304|True|Mac|
## Best-Null
### Links
- Full report: [Best-Null.md](/Docs/Best-Null.md)
- Code: [Best-Null.ps1](/PerformanceTests/Best-Null.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|Null=stuff|1,0327|1,0588|1,0000|False|Win|
|[Void]Stuff|1,2482|1,2038|1,3036|False|Win|
|Stuff*>Null|1,4150|1,3692|1,4722|True|Mac|
|Stuff*>Null|1,8802|1,3902|2,4927|False|Win|
|[Void]Stuff|1,9178|2,2595|1,4906|True|Mac|
|Stuff>Null|2,2787|2,2273|2,3430|False|Win|
|Stuff>Null|2,2840|2,1541|2,4462|True|Mac|
|Null=stuff|4,1122|6,2570|1,4313|True|Mac|
|StufflOutNull|10,2171|2,5282|19,8283|False|Win|
|StufflOutNull|12,8581|12,1360|13,7608|True|Mac|
## Best-Pipes
### Links
- Full report: [Best-Pipes.md](/Docs/Best-Pipes.md)
- Code: [Best-Pipes.ps1](/PerformanceTests/Best-Pipes.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|lAnonymousFunc|1,0999|1,0219|1,1975|True|Win|
|lAnonymousFunc|1,2905|1,1052|1,5221|True|Mac|
|lSimpleFunction1|1,5207|1,6688|1,3355|True|Win|
|lSimpleFunction4|1,8718|1,4545|2,3935|True|Win|
|l& SimpleMethod|1,9861|1,7461|2,2862|True|Win|
|lForeach|2,0399|1,7386|2,4164|True|Win|
|lSimpleFunction3|2,0635|1,7805|2,4172|True|Win|
|lForeach{}{}{}|2,1133|1,9505|2,3167|True|Win|
|lSimpleFunction2|2,1900|2,0494|2,3659|True|Win|
|lSimpleFunction1|2,9603|4,2411|1,3593|True|Mac|
|lSimpleFunction3|3,4696|3,8227|3,0283|True|Mac|
|lSimpleFunction4|4,0417|5,0817|2,7417|True|Mac|
|lSimpleFunction2|5,9330|7,7629|3,6457|True|Mac|
|l& SimpleMethod|6,4665|9,0333|3,2580|True|Mac|
|lForeach|6,9110|9,6921|3,4347|True|Mac|
|lForeach2.0|8,0426|12,7919|2,1060|True|Win|
|lForeach{}{}{}|9,7541|15,1249|3,0407|True|Mac|
|lForeach2.0|21,2291|36,2899|2,4030|True|Mac|
## Best-Where-return_1
### Links
- Full report: [Best-Where-return_1.md](/Docs/Best-Where-return_1.md)
- Code: [Best-Where-return_1.ps1](/PerformanceTests/Best-Where-return_1.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|Foreach(){}|1,2197|1,3102|1,1066|True|Win|
|lAnonymusPipe|1,5828|1,9015|1,1845|True|Win|
|Do{}While()|1,6689|1,3877|2,0204|True|Win|
|While(){}|1,7170|1,4046|2,1076|True|Win|
|Do{}Until()|1,7968|1,5985|2,0447|True|Win|
|For(){}|1,9337|1,6454|2,2939|True|Win|
|.Where({})|1,9477|1,6935|2,2655|True|Win|
|.Foreach({})|2,5391|2,8831|2,1090|True|Win|
|For(){}|4,5696|1,3868|8,5481|True|Mac|
|While(){}|4,7947|6,7913|2,2990|True|Mac|
|lForeach-Obj{}|5,4358|4,4737|6,6385|True|Win|
|Foreach(){}|5,9561|6,4962|5,2809|True|Mac|
|.Where({})|6,7775|9,1352|3,8304|True|Mac|
|lWhere-Obj{}|8,1012|6,5458|10,0454|True|Win|
|.Foreach({})|9,5611|15,1527|2,5717|True|Mac|
|Do{}While()|9,7280|15,9252|1,9816|True|Mac|
|lAnonymusPipe|11,7342|20,2960|1,0319|True|Mac|
|Do{}Until()|13,4240|17,9391|7,7800|True|Mac|
|lForeach-Obj{}|23,1059|28,7569|16,0422|True|Mac|
|lWhere-Obj{}|50,9773|72,9454|23,5171|True|Mac|
## Best-Where-return_2
### Links
- Full report: [Best-Where-return_2.md](/Docs/Best-Where-return_2.md)
- Code: [Best-Where-return_2.ps1](/PerformanceTests/Best-Where-return_2.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|Foreach(){}2x|1,3880|1,2450|1,5668|True|Win|
|For(){}SHORTER|1,4601|1,1632|1,8313|True|Win|
|Foreach(){}Shorter|1,6999|1,9300|1,4123|True|Win|
|lAnonymusPipe|1,8206|2,4770|1,0000|True|Win|
|For(){}2x|1,8796|1,3269|2,5705|True|Win|
|Do{}Until()2x|1,9265|1,3357|2,6651|True|Win|
|Foreach(){}2x|1,9967|1,1563|3,0473|True|Mac|
|While(){}2x|2,0207|1,4470|2,7377|True|Win|
|Do{}While()2x|2,1190|1,5814|2,7909|True|Win|
|.Where{})2x|2,5801|2,2547|2,9868|True|Win|
|Foreach(){}Shorter|2,9160|4,1547|1,3677|True|Mac|
|.Foreach({})2x|3,0815|2,9301|3,2707|True|Win|
|lAnonymusPipe|3,7858|6,0144|1,0000|True|Mac|
|While(){}2x|4,6597|6,0074|2,9751|True|Mac|
|lForeach-Obj{}|5,5662|5,0066|6,2657|True|Win|
|Do{}Until()2x|5,8318|6,3824|5,1436|True|Mac|
|.Foreach({})2x|6,0396|5,2439|7,0343|True|Mac|
|For(){}SHORTER|6,2264|9,2494|2,4477|True|Mac|
|lForeach-Obj{}|10,0899|11,8889|7,8411|True|Mac|
|lWhere-Obj{}|10,6325|8,8569|12,8521|True|Win|
|Do{}While()2x|11,2319|16,5830|4,5430|True|Mac|
|For(){}2x|12,2580|15,2946|8,4623|True|Mac|
|.Where{})2x|16,2684|25,0058|5,3465|True|Mac|
|lWhere-Obj{}|53,9633|50,0235|58,8880|True|Mac|
## Call-HashValue
### Links
- Full report: [Call-HashValue.md](/Docs/Call-HashValue.md)
- Code: [Call-HashValue.ps1](/PerformanceTests/Call-HashValue.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|Hash[Key]|1,2025|1,1761|1,2354|True|Win|
|Hash.Key|1,3452|1,5612|1,0753|True|Win|
|Hash.ContainsKey()|1,3825|1,3765|1,3899|True|Win|
|Hash.GetEnum|1,4160|1,4602|1,3607|True|Win|
|Hash.Key|3,0000|2,4264|3,7171|True|Mac|
|Hash.GetEnum|4,5692|2,7975|6,7839|True|Mac|
|Hash[Key]|5,7324|9,2922|1,2827|True|Mac|
|Hash.ContainsKey()|11,8478|17,9867|4,1742|True|Mac|
## Initialize-ArraysList
### Links
- Full report: [Initialize-ArraysList.md](/Docs/Initialize-ArraysList.md)
- Code: [Initialize-ArraysList.ps1](/PerformanceTests/Initialize-ArraysList.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|QuickInstanceNEW|1,1054|1,1704|1,0240|False|Win|
|ArrayList|1,4161|1,6998|1,0615|False|Win|
|QuickInstance|1,4666|1,7017|1,1727|False|Win|
|QuickInstanceNEW|5,9294|9,7650|1,1350|True|Mac|
|ArrayList|6,9717|11,4467|1,3779|True|Mac|
|QuickInstance|8,5725|10,6838|5,9334|True|Mac|
|NewObject|63,8742|12,0488|128,6559|False|Win|
|NewObject|204,4009|86,6898|351,5397|True|Mac|
## Initialize-Hashtables
### Links
- Full report: [Initialize-Hashtables.md](/Docs/Initialize-Hashtables.md)
- Code: [Initialize-Hashtables.ps1](/PerformanceTests/Initialize-Hashtables.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|QuickInstance|1,1512|1,1251|1,1838|False|Win|
|DictStrIntNEW|1,4308|1,7632|1,0152|False|Win|
|DictStrStrNEW|1,4559|1,7541|1,0832|False|Win|
|hashTableNEW|1,5444|1,8697|1,1379|False|Win|
|HashNEW|1,5792|1,9540|1,1108|False|Win|
|HashNEW|1,7568|1,2816|2,3507|True|Mac|
|hashTableNEW|1,7798|1,7458|1,8224|True|Mac|
|DictStrStrNEW|6,1588|9,9611|1,4059|True|Mac|
|DictStrIntNEW|7,7907|12,9102|1,3913|True|Mac|
|QuickInstance|9,9305|15,8108|2,5800|True|Mac|
|HereHash|29,1021|10,9934|51,7380|False|Win|
|NEWObject|32,6897|9,0024|62,2988|False|Win|
|NEWObjectHash|47,8304|12,8214|91,5915|False|Win|
|HereHash|90,2269|80,0350|102,9668|True|Mac|
|NEWObject|132,1500|99,4975|172,9656|True|Mac|
|NEWDictStrStr|136,7079|39,9453|257,6613|False|Win|
|NEWObjectHash|186,4163|95,1063|300,5539|True|Mac|
|NEWDictStrStr|431,0536|284,8548|613,8020|True|Mac|
## Initialize-PSCustomObject
### Links
- Full report: [Initialize-PSCustomObject.md](/Docs/Initialize-PSCustomObject.md)
- Code: [Initialize-PSCustomObject.ps1](/PerformanceTests/Initialize-PSCustomObject.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|NewPSobjCUSTOMHASH|1,0919|1,0881|1,0967|False|Win|
|NewPSobjHASH|1,6616|2,1764|1,0181|False|Win|
|CastHash1|2,0025|2,0235|1,9762|True|Mac|
|CastHash1|2,1280|2,4315|1,7487|False|Win|
|NewPSobjCUSTOMHASH|3,8353|6,0851|1,0230|True|Mac|
|NewPSobjHASH|3,9204|5,1213|2,4192|True|Mac|
|CastCUSTOMHash1|4,9138|2,4119|8,0411|True|Win|
|CastCUSTOMHash1|5,1452|4,3914|6,0874|True|Mac|
|NewPSObj|41,4301|11,4733|78,8762|True|Win|
|NewPSObjCUSTOM|45,9963|9,3161|91,8466|True|Win|
|NewPSObjCUSTOM|110,0066|84,6985|141,6417|True|Mac|
|NewPSObj|121,1700|82,0704|170,0445|True|Mac|
## Operands
### Links
- Full report: [Operands.md](/Docs/Operands.md)
- Code: [Operands.ps1](/PerformanceTests/Operands.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|SingleObject_Hash-init|1,1938|1,3489|1,0000|True|Win|
|SingleObject_Contain()|3,6120|2,3438|5,1974|True|Win|
|SingleObject_IndexOf()|3,9856|2,9019|5,3403|True|Win|
|SingleObject-EQ|10,7548|1,7474|22,0140|True|Win|
|SingleObject-NOT-EQ|14,8606|3,6321|28,8963|True|Win|
|SingleObject-Contains|22,3005|2,7447|46,7452|True|Win|
|SingleObject-in|23,3232|1,2557|50,9077|True|Win|
|SingleObject-Match|61,1006|8,6935|126,6094|True|Win|
|SingleObject_Hash+init|465,5107|8,0216|1037,3721|True|Win|
## Select-Unique_Int
### Links
- Full report: [Select-Unique_Int.md](/Docs/Select-Unique_Int.md)
- Code: [Select-Unique_Int.ps1](/PerformanceTests/Select-Unique_Int.ps1 )
### Report
|Name|TotalScore|LowVolume|HighVolume|Assert|OS|
|---|---|---|---|---|---|
|Generic.HashSet|1,0224|1,0000|1,0597|True|Win|
|Linq-Distinct|2,2933|3,0332|1,0602|True|Win|
|Select-Object|4,3730|4,3422|4,4242|True|Win|
|Linq-Distinct|4,4396|6,5033|1,0000|True|Mac|
|Sort-Object|4,7237|4,8505|4,5125|True|Win|
|Get-Unique|6,2839|5,5849|7,4490|True|Win|
|Select-Object|8,3069|9,8305|5,7676|True|Mac|
|Sort-Object|33,9679|6,7524|79,3272|True|Mac|
|Generic.HashSet|35,1953|1,2615|91,7516|True|Mac|
|Get-Unique|37,1580|38,6844|34,6141|True|Mac|
