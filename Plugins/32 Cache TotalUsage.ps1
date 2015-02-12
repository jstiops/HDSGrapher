$Title = "Cache Total Queue Usage Rate"
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
get-HDSStatsTotalQRate -Controller "0" | Add-PSGraphSerie -ChartName "TotalQChart" -Name "Controller 0" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType 
get-HDSStatsTotalQRate -Controller "1" | Add-PSGraphSerie -ChartName "TotalQChart" -Name "Controller 1" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType
$TotalQChart.SaveChart("$GraphOutputPath\CacheTotalQChart.png")




