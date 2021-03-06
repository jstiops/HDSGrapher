﻿$Title = "Cache Physical Queue Usage Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "Cache Physical Queue Usage Rate"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsPhysQRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $ctlValues = Get-Content -path $CsvPath"\CTL"$Controller"_Cache_PhysicalUsageRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    $ctlValues

}

$PhysQChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$PhysQChart.AddSerie("Controller 0", $LineType)
get-HDSStatsPhysQRate -Controller "0" | ForEach-Object {

  $PhysQChart.AddSerieValues("Controller 0", $_.($XPropertyName), $_.0)

}
$PhysQChart.AddSerie("Controller 1", $LineType)
get-HDSStatsPhysQRate -Controller "1" | ForEach-Object {

  $PhysQChart.AddSerieValues("Controller 1", $_.($XPropertyName), $_.0)

}

$PhysQChart.SaveChart("$GraphOutputPath\CachePhysQChart.png")




