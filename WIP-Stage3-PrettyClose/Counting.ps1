$Tests = @()
$max = 100
$int=1
$arr = $int..$max
$counted = $arr.count

$Tests += Test-Performance  -Name "For" -scriptblock { for($int=1;$int -lt $max;$int++){ $null = $int } }
$Tests += test-Performance IndexOf { foreach( $i in $arr){  $null = $arr.indexOf($i) } }
$Tests += test-Performance eq { foreach( $i in $arr){  $null = $arr -eq $i } }

$Tests += Test-Performance  -Name "For" -scriptblock { for($int=1;$int -lt $max;$int++){  Write-Progress -PercentComplete (100*( $int /$max)) -Activity "test" } }
$Tests += test-Performance IndexOf { foreach( $i in $arr){  Write-Progress -PercentComplete (100*( $arr.indexOf($i) /$max)) -Activity "test" } }

$Tests += test-Performance "$max`_ReCount" { foreach( $i in $arr){  $null = $arr.count } }
$Tests += test-Performance "$max`_Counted" { foreach( $i in $arr){  $null = $counted } }

$Tests |sort-object time