# Testing Functions
Function ProcessEnd ($param){Begin{$collect = [System.Collections.ArrayList]@()}Process{if ($collect.GetType().Name -eq "Array" -or $collect.GetType().Name -eq 'ArrayList') {$collect.AddRange($param)}else{$null=$param.Add($param)}} }
#Not changed yet
Function ProcessNormal ($param){Begin{$collect = [System.Collections.ArrayList]@()}Process{if ($collect.GetType().Name -eq "Array" -or $collect.GetType().Name -eq 'ArrayList') {$collect.AddRange($param)}else{$null=$param.Add($param)}} }
Test-Performance -SB { }