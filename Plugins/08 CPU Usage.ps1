﻿$Title = "CPU Usage"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


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

  $CPUChart.AddSerie("Controller 0 - Core X", $LineType)
  $CPUChart.AddSerie("Controller 0 - Core Y", $LineType)
  $CPUChart.AddSerie("Controller 1 - Core X", $LineType)
  $CPUChart.AddSerie("Controller 1 - Core Y", $LineType)

  $controller0Values | ForEach-Object{

    $CPUChart.AddSerieValues("Controller 0 - Core X", $_.($XPropertyName), $_.X)
    $CPUChart.AddSerieValues("Controller 0 - Core Y", $_.($XPropertyName), $_.Y)
  }
  
  $controller1Values | ForEach-Object{

    $CPUChart.AddSerieValues("Controller 1 - Core X", $_.($XPropertyName), $_.X)
    $CPUChart.AddSerieValues("Controller 1 - Core Y", $_.($XPropertyName), $_.Y)

  }

}else{
  
  $CPUChart.AddSerie("Controller 0 - Core X", $LineType)
  $CPUChart.AddSerie("Controller 1 - Core X", $LineType)

  $controller0Values | ForEach-Object{

    $CPUChart.AddSerieValues("Controller 0 - Core X", $_.($XPropertyName), $_.X)

  }
  
  $controller1Values | ForEach-Object{

    $CPUChart.AddSerieValues("Controller 1 - Core X", $_.($XPropertyName), $_.X)

  }
  
}
$CPUChart.SaveChart("$GraphOutputPath\ProcessorUsage.png", "png", $false ) 
