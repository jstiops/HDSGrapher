$Title = "Cache Physical Queue Usage Rate"
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
get-HDSStatsPhysQRate -Controller "0" | Add-PSGraphSerie -ChartName "PhysQChart" -Name "Controller 0" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType 
get-HDSStatsPhysQRate -Controller "1" | Add-PSGraphSerie -ChartName "PhysQChart" -Name "Controller 1" -XPropertyName $XPropertyName -YPropertyName "0" -Type $LineType
$PhysQChart.SaveChart("$GraphOutputPath\CachePhysQChart.png")




