$Title = "Cache Clean Queue Usage Rate"
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
get-HDSStatsCleanQRate -Controller "0" | Add-PSGraphSerie -ChartName "CleanQChart" -Name "Controller 0" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType 
get-HDSStatsCleanQRate -Controller "1" | Add-PSGraphSerie -ChartName "CleanQChart" -Name "Controller 1" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType
$CleanQChart.SaveChart("$GraphOutputPath\CacheCleanQChart.png")




