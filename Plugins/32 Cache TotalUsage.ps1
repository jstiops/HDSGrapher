﻿$Title = "Cache Total Queue Usage Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "Cache Total Queue Usage Rate"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsTotalQRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $ctlValues = Get-Content -path $CsvPath"\CTL"$Controller"_Cache_TotalUsageRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    $ctlValues

}

$TotalQChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$TotalQChart.AddSerie("Controller 0", $LineType)
get-HDSStatsTotalQRate -Controller "0" | ForEach-Object {

  $TotalQChart.AddSerieValues("Controller 0", $_.($XPropertyName), $_.0)

}
$TotalQChart.AddSerie("Controller 1", $LineType)
get-HDSStatsTotalQRate -Controller "1" | ForEach-Object {

  $TotalQChart.AddSerieValues("Controller 1", $_.($XPropertyName), $_.0)

}
$TotalQChart.SaveChart("$GraphOutputPath\CacheTotalQChart.png")




