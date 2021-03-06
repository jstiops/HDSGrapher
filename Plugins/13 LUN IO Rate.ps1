﻿$Title = "LUN IO Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "LUN IOPs"
$XPropertyName = "Time"
#settings for plugins


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

$LUNIOPsChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

$ctl0values = Get-Content -path $CsvPath"\CTL0_Lu_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
$luns = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\LUNIORates" |Out-Null

foreach ($lun in $luns){
  
  $LUNIOPsChart.AddSerie("LUN $lun", $LineType)
  get-HDSStatsLUNIORate -ID $lun | ForEach-Object{
    
    $LUNIOPsChart.AddSerieValues("LUN $lun", $_.($XPropertyName), $_.IORate)

  }
  
  $LUNIOPsSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - LUN $lun" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $LUNIOPsSingleChart.AddSerie("LUN $lun", $LineType)
  get-HDSStatsLUNIORate -ID $lun | ForEach-Object{
    
    $LUNIOPsSingleChart.AddSerieValues("LUN $lun", $_.($XPropertyName), $_.IORate)

  }
  $LUNIOPsSingleChart.SaveChart("$GraphOutputPath\LUNIORates\LUNIORates_LUN$lun.png")

}
$LUNIOPsChart.SaveChart("$GraphOutputPath\LUNIORates\LUNIORates.png")
