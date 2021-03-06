﻿$Title = "Port Bandwith Usage"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "StackedArea"
$AxisYTitle = "MBps"
$AxisXTitle = "Time"
$ChartTitle = "Port Bandwith Usage"
$XPropertyName = "Time"
#settings for plugins


function get-HDSStatsPortTransRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    
    Get-Content -path $CsvPath"\CTL"$Controller"_Port_TransRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    
}

$ctl0values = get-HDSStatsPortTransRate -Controller 0
$ctl1values = get-HDSStatsPortTransRate -Controller 1
$ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

New-Item -ItemType Directory -Force -Path "$GraphOutputPath\FEPortTransferRates" | Out-Null

#create chart for all charts, stacked
$PortBandwithChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

#first loop through values for controller 0
#this is done to make it simpler and more readable. Side effect is controller 0 series are added first in the charts
foreach ($port in $ports){
  #Loop through ports
  
  #for each port, create a chart and add a serie per port
  $PortBandwithSingleC0Chart = New-PSGraphChart -ChartTitle "$ChartTitle - Port 0$port" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval  
  $PortBandwithSingleC0Chart.AddSerie("0$port", $LineType)

  #add a serie to the combined chart with all ports
  $PortBandwithChart.AddSerie("0$port", $LineType)

      $ctl0values | ForEach-Object {
      #loop through values of the current port and add them to the single chart and the combined chart
    
        $PortBandwithChart.AddSerieValues("0$port", $_.($XPropertyName), $_.($port))
        $PortBandwithSingleC0Chart.AddSerieValues("0$port", $_.($XPropertyName), $_.($port))
    

      }
  #save the chart of the single port after the values have been added to the series
  $PortBandwithSingleC0Chart.SaveChart("$GraphOutputPath\FEPortTransferRates\FEPortTransferRates_Port0$port.png")

}

#loop through values for controller 1
foreach ($port in $ports){
  #Loop through ports
  
  #for each port, create a chart and add a serie per port
  $PortBandwithSingleC1Chart = New-PSGraphChart -ChartTitle "$ChartTitle - Port 1$port" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval  
  $PortBandwithSingleC1Chart.AddSerie("1$port", $LineType)

  #add a serie to the combined chart with all ports
  $PortBandwithChart.AddSerie("1$port", $LineType)
  
      $ctl1values | ForEach-Object {

        $PortBandwithChart.AddSerieValues("1$port", $_.($XPropertyName), $_.($port))
        $PortBandwithSingleC1Chart.AddSerieValues("1$port", $_.($XPropertyName), $_.($port))
    
      }

  $PortBandwithSingleC1Chart.SaveChart("$GraphOutputPath\FEPortTransferRates\FEPortTransferRates_Port1$port.png")
}

#finally save combined chart
$PortBandwithChart.SaveChart("$GraphOutputPath\FEPortTransferRates\FEPortTransferRates.png")
    



