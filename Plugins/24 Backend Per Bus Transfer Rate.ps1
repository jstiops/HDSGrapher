﻿$Title = "Backend Bandwith Per Bus"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# Which bus to graph? Example: All | 0,1
$BusToGraph ="All"
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "MBps"
$AxisXTitle = "Time"
$ChartTitle = "Backend Bandwith Usage"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsBackendTransferRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    
    Get-Content -path $CsvPath"\CTL"$Controller"_Back-end_TransRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    
}

$BackendBandwithChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle  -AxisXInterval $AxisXInterval
if($BusToGraph -eq "All"){
    
    
    $ctl0values = get-HDSStatsBackendTransferRate -Controller 0
    $ctl1values = get-HDSStatsBackendTransferRate -Controller 1

    $Buses = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

    foreach ($bus in $Buses){
    
        $BackendBandwithChart.AddSerie("CTL0:Bus$bus", $LineType)
        $ctl0values | ForEach-Object {

          $BackendBandwithChart.AddSerieValues("CTL0:Bus$bus", $_.($XPropertyName), $_.($bus))

        }
        

    }
    foreach ($bus in $Buses){
    
        $BackendBandwithChart.AddSerie("CTL1:Bus$bus", $LineType)
        $ctl1values | ForEach-Object {

          $BackendBandwithChart.AddSerieValues("CTL1:Bus$bus", $_.($XPropertyName), $_.($bus))

        }

    }

}else{

  $BusToGraph = $BusToGraph -split ','
  
  foreach ($bus in $BusToGraph){
  
      $controller = $bus.Substring(0,1)
      $busletter = $bus.Substring(1,1)
      
      $BackendBandwithChart.AddSerie("$bus", $LineType)
      get-HDSStatsBackendTransferRate -Controller $controller | ForEach-Object {

        $BackendBandwithChart.AddSerieValues("$bus", $_.($XPropertyName), $_.($busletter))

      }
   }
}

$BackendBandwithChart.SaveChart("$GraphOutputPath\BackendBandwith.png")
