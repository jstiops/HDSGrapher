﻿$Title = "Top RaidGroups IOPs"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# How many RaidGroups to show?
$amount ="5"
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "Top RaidGroups by IOPs"
$XPropertyName = "Time"
#settings for plugins


function Get-HDSStatsTopRGsIORate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)][string]$amount=5
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_RG_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_RG_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    $counter = 0
    $objCollection = @()
    $RGids = $ctl0values |Get-Member |Where-Object {$_.Name -match "\d+"} | Select-Object -ExpandProperty Name

    $ctl0values | ForEach-Object {
    # iterate through RG id
        
        $props = [ordered]@{Time = $_.Time}
        $obj= New-Object -TypeName PSObject -Property $props
        foreach($RGid in $RGids)
        {

            $totalIORate = [int]$_.($RGid) + [int]$ctl1values[$counter].($RGid)
            $obj | Add-Member NoteProperty $RGid $totalIORate
            
            
        }
        $objCollection += $obj
        $counter++     
        
    }

    $objAvgCollection = @()
    foreach($RGid in $RGids) {
     
        $avgIORate = ($objCollection | Measure-Object ($RGid) -Average -Maximum -Minimum).Average
        $props = [ordered]@{RaidGroup = $RGid
                            AvgIORate = $avgIORate }
        $obj= New-Object -TypeName PSObject -Property $props
        $objAvgCollection += $obj

    }
    
    $objAvgCollection | Sort-Object AvgIORate -Descending | Select-Object -First $amount

}

function get-HDSStatsRGIORate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$ID
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_RG_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_RG_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    
    
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


$TopRGIOPsChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$counter = 1 #used to display rank
Get-HDSStatsTopRGsIORate -amount $amount| ForEach-Object {
    $RG = $_.RaidGroup
    $TopRGIOPsChart.AddSerie("$counter - RaidGroup $RG", $LineType)
    
    get-HDSStatsRGIORate -ID $_.RaidGroup | ForEach-Object {

      $TopRGIOPsChart.AddSerieValues("$counter - RaidGroup $RG", $_.($XPropertyName), $_.IORate)

    }
    $counter ++
}  
$TopRGIOPsChart.SaveChart("$GraphOutputPath\TOPRGIOPs.png")

