﻿$Title = "Top LUNs IOPs"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# How many LUNs to show?
$amount ="5"
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "Top LUNs by IOPs"
$XPropertyName = "Time"
#settings for plugins



function Get-HDSStatsTopLUNsIORate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)][string]$amount=5
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_Lu_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Lu_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    $counter = 0
    $objCollection = @()
    $LUNids = $ctl0values |Get-Member |Where-Object {$_.Name -match "\d+"} | Select-Object -ExpandProperty Name

    $ctl0values | ForEach-Object {
    # iterate through LUN id
        
        $props = [ordered]@{Time = $_.Time}
        $obj= New-Object -TypeName PSObject -Property $props
        foreach($LUNid in $LUNids)
        {

            $totalIORate = [int]$_.($LUNid) + [int]$ctl1values[$counter].($LUNid)
            $obj | Add-Member NoteProperty $LUNid $totalIORate
            
            
        }
        $objCollection += $obj
        $counter++     
        
    }

    $objAvgCollection = @()
    foreach($LUNid in $LUNids) {
     
        $avgIORate = ($objCollection | Measure-Object ($LUNid) -Average -Maximum -Minimum).Average
        $props = [ordered]@{LUN = $LUNid
                            AvgIORate = $avgIORate }
        $obj= New-Object -TypeName PSObject -Property $props
        $objAvgCollection += $obj

    }
    
    $objAvgCollection | Sort-Object AvgIORate -Descending | Select-Object -First $amount

}
function get-HDSStatsLUNIORate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$ID
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_Lu_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Lu_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    
    
    $counter = 0
    $objCollection = @()
    $ctl0values | ForEach-Object {
        
        $ctl1value = $ctl1values[$counter] | Select-Object -ExpandProperty $($ID) 
        $totalValue = [int]$_.($ID) + [int]$ctl1value
        $props = [ordered]@{Time = $_.Time
                            IORate =  $totalValue
                        }
        $obj= New-Object -TypeName PSObject -Property $props
        $objCollection += $obj
        $counter++
    }

    $objCollection


}

$TopLUNsChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$counter = 1
Get-HDSStatsTopLUNsIORate -amount $amount| ForEach-Object {
    $LUN = $_.LUN
    $TopLUNsChart.AddSerie("$counter - LUN $LUN", $LineType)
    get-HDSStatsLUNIORate -ID $_.LUN | ForEach-Object {

      $TopLUNsChart.AddSerieValues("$counter - LUN $LUN", $_.($XPropertyName), $_.IORate)

    }
    $counter ++
}   
$TopLUNsChart.SaveChart("$GraphOutputPath\TOPLUNIOPs.png")

