$Title = "Frontend Port IO Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0

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


$FEPortChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

$ctl0values = get-HDSStatsPortIORate -Controller 0
$ctl1values = get-HDSStatsPortIORate -Controller 1

$ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\FEPortIORates" |Out-Null

foreach ($port in $ports){

    $FEPortChart.AddSerie("0$port", $LineType)

    $ctl0values | foreach-object {

      $FEPortChart.AddSerieValues("0$port", $_.($XPropertyName), $_.($port))

    }

}

foreach ($port in $ports){

  $FEPortChart.AddSerie("1$port", $LineType)
  $ctl1values | Foreach-Object {
    
    $FEPortChart.AddSerieValues("1$port", $_.($XPropertyName), $_.($port))

  }

}
$FEPortChart.SaveChart("$GraphOutputPath\FEPortIORates\FEPortIORates.png")

foreach ($port in $ports){

  $FEPortSingleC0Chart = New-PSGraphChart -ChartTitle "$ChartTitle - Port 0$port" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $FEPortSingleC0Chart.AddSerie("0$port", $LineType)

    $ctl0values | foreach-object {

      $FEPortSingleC0Chart.AddSerieValues("0$port", $_.($XPropertyName), $_.($port))

    }
  $FEPortSingleC0Chart.SaveChart("$GraphOutputPath\FEPortIORates\FEPortIORates_Port0$port.png")
}

foreach ($port in $ports){

  $FEPortSingleC1Chart = New-PSGraphChart -ChartTitle "$ChartTitle - Port 1$port" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $FEPortSingleC1Chart.AddSerie("1$port", $LineType) 
  $ctl1values | Foreach-Object {
    
    $FEPortSingleC1Chart.AddSerieValues("1$port", $_.($XPropertyName), $_.($port))

  }
  $FEPortSingleC1Chart.SaveChart("$GraphOutputPath\FEPortIORates\FEPortIORates_Port1$port.png")

}



