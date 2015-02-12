$Title = "Frontend Port IO Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings 
# End of Settings

#settings for plugins
$LineType = "StackedArea"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "Total FrontEnd Port IOPs"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsPortIORate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)   
    $content = Get-Content -path $CsvPath"\CTL"$Controller"_Port_IORate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $content  
}


$FEPortChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisXTitle -AxisXInterval $AxisXInterval
    
$ctl0values = get-HDSStatsPortIORate -Controller 0
$ctl1values = get-HDSStatsPortIORate -Controller 1
     
$ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\FEPortIORates"

foreach ($port in $ports){
    
    $ctl0values | Add-PSGraphSerie -Name "0$port" -ChartName "FEPortChart" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType

}

foreach ($port in $ports){
  
  $ctl1values | Add-PSGraphSerie -Name "1$port" -ChartName "FEPortChart" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType

}

foreach ($port in $ports){
  
  $FEPortSingleC0Chart = New-PSGraphChart -ChartTitle "$ChartTitle - Port 0$port" -AxisXTitle $AxisXTitle -AxisYTitle $AxisXTitle -AxisXInterval $AxisXInterval
  $ctl0values | Add-PSGraphSerie -Name "0$port" -ChartName "FEPortSingleC0Chart" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType
  $FEPortSingleC0Chart.SaveChart("$GraphOutputPath\FEPortIORates\FEPortIORates_Port0$port.png")
}

foreach ($port in $ports){

  $FEPortSingleC1Chart = New-PSGraphChart -ChartTitle "$ChartTitle - Port 1$port" -AxisXTitle $AxisXTitle -AxisYTitle $AxisXTitle -AxisXInterval $AxisXInterval
  $ctl1values | Add-PSGraphSerie -Name "0$port" -ChartName "FEPortSingleC1Chart" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType
  $FEPortSingleC1Chart.SaveChart("$GraphOutputPath\FEPortIORates\FEPortIORates_Port1$port.png")

}


$FEPortChart.SaveChart("$GraphOutputPath\FEPortIORates\FEPortIORates.png")

