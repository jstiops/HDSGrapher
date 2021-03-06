﻿$Title = "Total Backend IO Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 1.0


# Start of Settings 
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "Total Backend IOPs"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsTotalBackendIORate {

    $ctl0values = Get-Content -path $CsvPath"\CTL0_Back-end_IORate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Back-end_IORate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    #get the paths used on this system
    $PortsObj = $ctl0values | get-member | Where-Object {$_.Name -eq "0" -or $_.Name -eq "1" -or $_.Name -eq "2" -or $_.Name -eq "3"}

    #build objects with summed total property added to it for Controller0 values
    $objCollectionC0 = @()
    $ctl0Values | ForEach-Object {
        $totalIORate = 0
        $currentObj = $_
            $PortsObj | ForEach-Object {
        
                $totalIORate = $totalIORate +  [int]($currentObj |Select-Object -ExpandProperty ($_.Name))

            }
        $_ |Add-Member NoteProperty TotalIORate $totalIORate
        $objCollectionC0 += $_
    }

    #build objects with summed total property added to it for Controller1 values
    $objCollectionC1 = @()
    $ctl1Values | ForEach-Object {
        $totalIORate = 0
        $currentObj = $_
            $PortsObj | ForEach-Object {
        
                $totalIORate = $totalIORate +  [int]($currentObj |Select-Object -ExpandProperty ($_.Name))

            }
        $_ |Add-Member NoteProperty TotalIORate $totalIORate
        $objCollectionC1 += $_
    }

    #build objects with calculated IORate. This is the Sum of all IOPs of all paths from both controllers
    $objCollectionTotal = @()
    $counter = 0
    $objCollectionC0 | ForEach-Object {

        $totalIORate = [int]$_.TotalIORate + [int]$objCollectionC1[$counter].TotalIORate
        
        $props = [ordered]@{Time = $_.Time
                            IORate =  $totalIORate
                        }
        $obj= New-Object -TypeName PSObject -Property $props
        $objCollectionTotal += $obj

    }

    
    $objCollectionTotal


}

$BackendIOPsChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$BackendIOPsChart.AddSerie("Backend IOPs", $LineType)
get-HDSStatsTotalBackendIORate | ForEach-Object {

  $BackendIOPsChart.AddSerieValues("Backend IOPs", $_.($XPropertyName), $_.IORate)
  
}
$BackendIOPsChart.SaveChart("$GraphOutputPath\BackendIOPs.png")

