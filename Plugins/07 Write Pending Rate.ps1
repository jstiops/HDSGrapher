$Title = "Write pending rate"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


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
get-HDSStatsWritePendingRate -Controller "0" | Add-PSGraphSerie -ChartName "WritePendingChart" -Name "Controller 0" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType 
get-HDSStatsWritePendingRate -Controller "1" | Add-PSGraphSerie -ChartName "WritePendingChart" -Name "Controller 1" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType
$WritePendingChart.SaveChart("$GraphOutputPath\WritePendingRate.png")




