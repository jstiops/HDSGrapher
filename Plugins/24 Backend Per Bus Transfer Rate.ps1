$Title = "Backend Bandwith Per Bus"
$Author = "Micheal Gnocchi"
$PluginVersion = 2.0


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
    
        $ctl0values | Add-PSGraphSerie -ChartName "BackendBandwithChart" -Name "CTL0:Bus$bus" -YPropertyName $bus -XPropertyName $XPropertyName -Type $LineType

    }
    foreach ($bus in $Buses){
    
        $ctl1values | Add-PSGraphSerie -ChartName "BackendBandwithChart" -Name "CTL1:Bus$bus" -YPropertyName $bus -XPropertyName $XPropertyName -Type $LineType

    }

}else{

  $BusToGraph = $BusToGraph -split ','
  
  foreach ($bus in $BusToGraph){
  
      $controller = $bus.Substring(0,1)
      $busletter = $bus.Substring(1,1)

      get-HDSStatsBackendTransferRate -Controller $controller | Add-PSGraphSerie -Name $bus -YPropertyName $busletter -XPropertyName $XPropertyName -Type $LineType


  }
}

$BackendBandwithChart.SaveChart("$GraphOutputPath\BackendBandwith.png")
