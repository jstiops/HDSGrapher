$Title = "Cache Middle Queue Usage Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "Cache Middle Queue Usage Rate"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsMiddleQRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $ctlValues = Get-Content -path $CsvPath"\CTL"$Controller"_Cache_MiddleUsageRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    $ctlValues

}

$MiddleQChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
get-HDSStatsMiddleQRate -Controller "0" | Add-PSGraphSerie -ChartName "MiddleQChart" -Name "Controller 0" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType 
get-HDSStatsMiddleQRate -Controller "1" | Add-PSGraphSerie -ChartName "MiddleQChart" -Name "Controller 1" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType
$MiddleQChart.SaveChart("$GraphOutputPath\CacheMiddleQChart.png")




