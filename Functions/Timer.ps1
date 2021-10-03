Function Set-Timer {
    <#
    .Synopsis
       Set a new timer
    .DESCRIPTION
       Instead of writing new ad-hoc timer for instance:
       * When you have worked 8h.
       * If you are going to check a build in x minutes.
       * You are cooking stuff
       * Want to execute a command at specific time (comming feature)
    .EXAMPLE
       $int = 5 ;1..2 |% { $SoonDate = (Get-date).AddSeconds(0.5) ;  Set-timer -date $SoonDate "test$_" -ScriptBlock 'Write-Host "WOOP$int!!"; $int += 2; write-warning $int'} ;
 
 Time                RemindMeOf ID
 ----                ---------- --
 2020-03-22 08:31:51 test1      10
 2020-03-22 08:31:51 test2      11
 
 [FS]C:Users\patri\OneDrive\Development\Powershell\PhonoxsPSHelpers\ | S01:10 | T08:31
 >
  <<<---  Time's UP!!!  --->>>
  <<<---  test2  --->>>
 WOOP5!!
 WARNING: 7
 [FS]C:Users\patri\OneDrive\Development\Powershell\PhonoxsPSHelpers\ | S01:10 | T08:31
 >
  <<<---  Time's UP!!!  --->>>
  <<<---  test1  --->>>
 WOOP5!!
 WARNING: 7
 # Post timer operations
 $int
 5
 # with other words, did not update $int
 .EXAMPLE
 $global:int = 5 ;1..2 |% { $SoonDate = (Get-date).AddSeconds(0.5) ;  Set-timer -date $SoonDate "test$_" -ScriptBlock 'Write-Host "WOOP$int!!"; $global:int += 2; write-warning $global:int'} ;
 
 Time                RemindMeOf ID
 ----                ---------- --
 2020-03-22 08:36:25 test1      10
 2020-03-22 08:36:25 test2      11
 
 [FS]C:Users\patri\OneDrive\Development\Powershell\PhonoxsPSHelpers\ | S01:14 | T08:36
 >
  <<<---  Time's UP!!!  --->>>
  <<<---  test1  --->>>
 WOOP5!!
 WARNING: 7
 [FS]C:Users\patri\OneDrive\Development\Powershell\PhonoxsPSHelpers\ | S01:14 | T08:36
 >
  <<<---  Time's UP!!!  --->>>
  <<<---  test2  --->>>
 WOOP7!!
 WARNING: 9
 # Post timer operations
 > $int
 9
 # saved the variables
 .EXAMPLE
 1..2 |% { $SoonDate = (Get-date).AddSeconds(0.5) ;  Set-timer -date $SoonDate "test$_" -ScriptBlock 'Write-Host "WOOP$int!!";update-persistentdata; set-persistentdata int ($int += 2); write-warning $int'} ;
 
 Time                RemindMeOf ID
 ----                ---------- --
 2020-03-22 08:14:30 test1      10
 2020-03-22 08:14:30 test2      11
 
 [FS]C:Users\patri\OneDrive\Development\Powershell\PhonoxsPSHelpers\ | S00:52 | T08:14
 >
  <<<---  Time's UP!!!  --->>>
  <<<---  test2  --->>>
 WOOP2!!
 WARNING: 4
 [FS]C:Users\patri\OneDrive\Development\Powershell\PhonoxsPSHelpers\ | S00:52 | T08:14
 >
  <<<---  Time's UP!!!  --->>>
  <<<---  test1  --->>>
 WOOP4!!
 WARNING: 6
 # Post timer operations..
 $int
 2
 # Requires update-persistendata for update
 
    .LINK
       Set-Timer
    .LINK
       Get-Timer
    .LINK
       Remove-Timer
    #>
     [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'int')]
     Param(
         [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ValueFromRemainingArguments = $false,
                    Position = 0,
                    ParameterSetName = 'Minutes')]
         [ValidateNotNullOrEmpty()]
         #Type an integer to leave the parameter out
         [int]$Minutes,
         [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ValueFromRemainingArguments = $false,
                    Position = 0,
                    ParameterSetName = 'Decimal')]
         [ValidateNotNullOrEmpty()]
         #Type a decimal number(hours) to leave the parameter out
       
         [double]$DecimalHour,
         [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ValueFromRemainingArguments = $false,
                    Position = 0,
                    ParameterSetName = 'datetime')]
         [ValidateNotNullOrEmpty()]
         #Help about this parameter
         [dateTime]$Date,
         [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ValueFromRemainingArguments = $false,
                    Position = 1)]
         [string]$RemindMeOf,
         [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ValueFromRemainingArguments = $false,
                    Position = 2)]
         [string[]]$ScriptBlock
     )
     Begin {
         If (!$Script:StartedTimers) {
             $Script:StartedTimers = @()
             #"Instansierat"
         }
         if (!$Global:timer) {
             $Global:timer = New-Object timers.timer
             $Global:timer.Interval = 1000
         }
     }
     Process {
         #if ( $pscmdlet.ShouldProcess("Target", "Operation") )
         #{
         #}
         #write-host $time
         $ErrorActionPreference = 'Stop'
         $ScriptBlock = [scriptblock]::Create($ScriptBlock)
         if ($PSCmdlet.ParameterSetName -eq "Minutes") {
             [datetime]$NewTimer = (get-date).AddMinutes($Minutes)
         }
         elseif ($PSCmdlet.ParameterSetName -eq "Decimal") {
             [datetime]$NewTimer = (Get-date).AddHours($DecimalHour)
         }
         elseif ($PSCmdlet.ParameterSetName -eq "datetime") {
             [datetime]$NewTimer = $Date
         }
         $NewId = Get-Timer | Sort-Object id | Select-Object -Last 1 -ExpandProperty id
         if (!$newid) { $NewId = 1 }
         else { $newid++ }
 
         do {
             $OK = $false
             if ( "Timer$newid" -notin (Get-EventSubscriber).SourceIdentifier ) {
                 $OK = $true
             }
             else { $NewId++ }
         }until($OK)
         
         $BoolSB = [bool]$ScriptBlock[0]
         $BoolRemind = [bool]$RemindMeOf
         $action = [scriptblock]::Create(@"
             [datetime]`$now = get-date;
             `$short = `$now.ToShortTimeString()
             if(`$now -gt [DateTime]"$NewTimer"){
                 Write-Host ""
                 Write-Host -ForegroundColor Magenta " <<<---  Time's UP!!!  --->>>  ";
                 if (`$$BoolRemind ) { Write-Host -ForegroundColor Magenta " <<<---  $RemindMeOf  --->>>  ";}
                 if (`$$BoolSB ) {. {$ScriptBlock} }
                 #`$wshell = New-Object -ComObject Wscript.Shell
                 #`$wshell.Popup("`$short - $($RemindMeOf)",0,"Done",0x0)
                 #Show-MsgBox -Prompt ("IT IS PAST $newTimer`: $RemindMeOf" ) -Title "TIMER $newid" -Icon Exclamation -BoxType OKOnly
                 Remove-Timer -id $newid
                 Get-Command Remove-Timer
             }
"@)
         Register-ObjectEvent -InputObject $Global:timer -EventName elapsed -SourceIdentifier "Timer$newid" -Action $action -ErrorAction SilentlyContinue | Out-Null
         $Global:timer.Start()
 
         $CustomObject = [PSCustomObject]@{
             Time       = $NewTimer;
             RemindMeOf = $RemindMeOf
             ID         = $newid;
             Action     = $Action
         }
         $Script:StartedTimers += $CustomObject
         $CustomObject
     }
     End {
     }
 }
 
 
 Function Get-Timer {
 <#
 .Synopsis
    Get all timers
 .DESCRIPTION
    Get all timers
 .EXAMPLE
    Get-Timer
 .LINK
    Set-Timer
 .LINK
    Get-Timer
 .LINK
    Remove-Timer
 #>
     [CmdletBinding(SupportsShouldProcess)]
     Param(
         #[Parameter(ValueFromPipeline,
         #           ValueFromPipelineByPropertyName,
         #           ValueFromRemainingArguments=$false,
         #           Position=0)]
         #[ValidateNotNullOrEmpty()]
         ##Help about this parameter
         #$Stuff
         [switch]$CommingUp
     )
     Begin {
     
     }
     Process {
         $Script:StartedTimers | Sort-Object Time #| select -First 1
     }
     End {
         
     }
 }
 
 
 Function Remove-Timer {
 <#
 .Synopsis
    Remove a timer
 .DESCRIPTION
    Remove a timer
 .EXAMPLE
    Example of how to use this cmdlet
 .LINK
    Set-Timer
 .LINK
    Get-Timer
 .LINK
    Remove-Timer
 #>
     [CmdletBinding(SupportsShouldProcess)]
     Param(
         #[Parameter(
         #           ValueFromPipeline,
         #           ValueFromPipelineByPropertyName,
         #           ValueFromRemainingArguments=$false,
         #           Position=0)]
         #[ValidateNotNullOrEmpty()]
         ##Help about this parameter
         [int]$ID,
         [switch]$All
     )
     Begin {
     
     }
     Process {
         if ($all) {
             $Script:StartedTimers | ForEach-Object {
                 $Global:Timer.stop()
                 unregister-event "Timer$ID" -ErrorAction Continue -Force
             }
             $Script:StartedTimers = @()
         }
         elseif ($id) {
             $Script:StartedTimers = @($Script:StartedTimers | ForEach-Object { 
                 if ( $_.ID -ne $ID ) { $_ }
                 else {
                     $Global:Timer.stop() | Out-Host
                     unregister-event "Timer$ID" -ErrorAction Continue -Force | Out-Host
                 }
             } )
         }
     }
     End {
         if (!$Script:StartedTimers) { $Script:StartedTimers = @() }
         else { $Global:Timer.Start() }
         return ""
     }
 }
 Export-ModuleMember -function Set-Timer, Get-Timer, Remove-Timer -ErrorAction Ignore