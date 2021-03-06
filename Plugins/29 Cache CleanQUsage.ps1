﻿$Title = "Cache Clean Queue Usage Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "Cache Clean Queue Usage Rate"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsCleanQRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $ctlValues = Get-Content -path $CsvPath"\CTL"$Controller"_Cache_CleanUsageRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    $ctlValues

}

$CleanQChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

$CleanQChart.AddSerie("Controller 0", $LineType)
get-HDSStatsCleanQRate -Controller "0" | ForEach-Object {

  $CleanQChart.AddSerieValues("Controller 0", $_.($XPropertyName), $_.0)


}
$CleanQChart.AddSerie("Controller 1", $LineType)
get-HDSStatsCleanQRate -Controller "1" | ForEach-Object {

  $CleanQChart.AddSerieValues("Controller 1", $_.($XPropertyName), $_.0)


}

$CleanQChart.SaveChart("$GraphOutputPath\CacheCleanQChart.png")




