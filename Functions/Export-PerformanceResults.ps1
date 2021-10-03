Function Export-PerformanceResults{
    Param([Parameter(ValueFromPipeline)]$Items, [string]$Path)
    Begin{$ItemsFromPipe = [System.Collections.ArrayList]@()}
    Process{
        if ($items.GetType().BaseType.Name -eq 'Array' ) {
            $ItemsFromPipe.AddRange( $Items )
        }else{
            $Null = $ItemsFromPipe.Add($items)
        }
    }
    End{
        $ItemsFromPipe |ConvertTo-Csv -NoTypeInformation |Out-File -FilePath $Path
    }
}

Export-ModuleMember -Function Export-PerformanceResults