$Title = "Port Bandwith Usage"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


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
    
$PortBandwithChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$ctl0values = get-HDSStatsPortTransRate -Controller 0
$ctl1values = get-HDSStatsPortTransRate -Controller 1
$ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

New-Item -ItemType Directory -Force -Path "$GraphOutputPath\FEPortTransferRates"

foreach ($port in $ports){
    
  $ctl0values | Add-PSGraphSerie -ChartName "PortBandwithChart" -Name "0$port" -XPropertyName $XPropertyName -YPropertyName $port -Type $LineType

}
foreach ($port in $ports){
    
  $ctl1values | Add-PSGraphSerie -ChartName "PortBandwithChart" -Name "1$port" -XPropertyName $XPropertyName -YPropertyName $port  -Type $LineType

}

foreach ($port in $ports){
    
  $PortBandwithSingleC0Chart = New-PSGraphChart -ChartTitle "$ChartTitle - Port 0$port" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $ctl0values | Add-PSGraphSerie -ChartName "PortBandwithSingleC0Chart" -Name "0$port" -XPropertyName $XPropertyName -YPropertyName $port -Type $LineType
  $PortBandwithSingleC0Chart.SaveChart("$GraphOutputPath\FEPortTransferRates\FEPortTransferRates_Port0$port.png")
}
foreach ($port in $ports){
    
  $PortBandwithSingleC1Chart = New-PSGraphChart -ChartTitle "$ChartTitle - Port 1$port" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $ctl1values | Add-PSGraphSerie -ChartName "PortBandwithSingleC1Chart" -Name "1$port" -XPropertyName $XPropertyName -YPropertyName $port -Type $LineType
  $PortBandwithSingleC1Chart.SaveChart("$GraphOutputPath\FEPortTransferRates\FEPortTransferRates_Port1$port.png")
}

$PortBandwithChart.SaveChart("$GraphOutputPath\FEPortTransferRates\FEPortTransferRates.png")
    



