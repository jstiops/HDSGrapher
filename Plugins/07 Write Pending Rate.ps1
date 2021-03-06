﻿$Title = "Write pending rate"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "Write Pending Rate"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsWritePendingRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $ctlValues = Get-Content -path $CsvPath"\CTL"$Controller"_Cache_WritePendingRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    $ctlValues

}

$WritePendingChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$WritePendingChart.AddSerie("Controller 0", $LineType)
get-HDSStatsWritePendingRate -Controller "0" | ForEach-Object {

  $WritePendingChart.AddSerieValues("Controller 0", $_.($XPropertyName), $_.0)

}

$WritePendingChart.AddSerie("Controller 1", $LineType)
get-HDSStatsWritePendingRate -Controller "1" | ForEach-Object {

  $WritePendingChart.AddSerieValues("Controller 1", $_.($XPropertyName), $_.0)

}

$WritePendingChart.SaveChart("$GraphOutputPath\WritePendingRate.png")




