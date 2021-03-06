﻿$Title = "Raidgroup IO Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "StackedArea"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "RaidGroup IOPs"
$XPropertyName = "Time"
#settings for plugins

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

    
$RGIOPsChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$ctl0values = Get-Content -path $CsvPath"\CTL0_RG_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    
$rgs = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\RGIORates" |Out-Null
foreach ($rg in $rgs){
  
  $RGIOPsChart.AddSerie("RG $rg", $LineType)
  get-HDSStatsRGIORate -ID $rg | ForEach-Object{

    $RGIOpsChart.AddSerieValues("RG $rg", $_.($XpropertyName), $_.IORate)

  }

  $RGIOPsSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - RaidGroup $rg" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $RgIOPsSingleChart.AddSerie("RG $rg", $LineType)
  get-HDSStatsRGIORate -ID $rg | ForEach-Object {

    $RgIOPsSingleChart.AddSerieValues("RG $rg", $_.($XPropertyName), $_.IORate)

  }
  
  $RGIOPsSingleChart.SaveChart("$GraphOutputPath\RGIORates\RGIORate_RG$rg.png")

}
$RGIOPsChart.SaveChart("$GraphOutputPath\RGIORates\RGIORate.png")
    






