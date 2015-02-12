$Title = "CPU Usage"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# Is this a dual core array?
$DualCore ="No"
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "Processor Usage (Best Practice < 70%)"
$XPropertyName = "Time"
#settings for plugins

function Get-HDSStatsProcessorUsage{
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $ctlValues = Get-Content -path $CsvPath"\CTL"$Controller"_Processor_Usage.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctlValues

}

$CPUChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval -AxisXTitle $AxisXTitle
$controller0Values = Get-HDSStatsProcessorUsage -Controller "0"
$controller1Values = Get-HDSStatsProcessorUsage -Controller "1"
if($DualCore -eq "Yes"){

  $controller0Values | Add-PSGraphSerie -Name "Controller 0 - Core X" -YPropertyName "X" -XPropertyName $XPropertyName -ChartName "CPUChart" -Type $LineType
  $controller0Values | Add-PSGraphSerie -Name "Controller 0 - Core Y" -YPropertyName "Y" -XPropertyName $XPropertyName -ChartName "CPUChart" -Type $LineType
  $controller1Values | Add-PSGraphSerie -Name "Controller 1 - Core X" -YPropertyName "X" -XPropertyName $XPropertyName -ChartName "CPUChart" -Type $LineType
  $controller1Values | Add-PSGraphSerie -Name "Controller 1 - Core Y" -YPropertyName "Y" -XPropertyName $XPropertyName -ChartName "CPUChart" -Type $LineType

}else{
  
  $controller0Values | Add-PSGraphSerie -Name "Controller 0" -YPropertyName "X" -XPropertyName $XPropertyName -ChartName "CPUChart" -Type $LineType
  $controller1Values | Add-PSGraphSerie -Name "Controller 1" -YPropertyName "X" -XPropertyName $XPropertyName -ChartName "CPUChart" -Type $LineType
  
}
$CPUChart.SaveChart("$GraphOutputPath\ProcessorUsage.png", "png", $false ) 
