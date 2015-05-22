$Title = "Port Truecopy Bandwith Usage"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# Which ports to graph? Example: All | 0a,0b,1a,1b
$PortsToGraph ="0D,1D"
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "MBps"
$AxisXTitle = "Time"
$ChartTitle = "TrueCopy Port Bandwith usage"
$XPropertyName = "Time"
#settings for plugins


function get-HDSStatsPortTrueCopyTransRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    
    Get-Content -path $CsvPath"\CTL"$Controller"_Port_Data_CMD_TransRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    
}


if($PortsToGraph -eq "All"){
    
    
    $TCBandwithUsageChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle
    $ctl0values = get-HDSStatsPortTrueCopyTransRate -Controller 0 
    $ctl1values = get-HDSStatsPortTrueCopyTransRate -Controller 1
    $ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

    foreach ($port in $ports){
        
        $TCBandwithUsageChart.AddSerie("0$port", $LineType)
        $ctl0values | ForEach-Object {

          $TCBandwithUsageChart.AddSerieValues("0$port", $_.($XPropertyName), $_.($port))

        }
        

    }
    foreach ($port in $ports){
    
        $TCBandwithUsageChart.AddSerie("1$port", $LineType)
        $ctl1values | ForEach-Object {

          $TCBandwithUsageChart.AddSerieValues("1$port", $_.($XPropertyName), $_.($port))

        }

    }
    $TCBandwithUsageChart.SaveChart("$GraphOutputPath\PortTruecopyBandwithUsage.png")
    


}else{

  $PortsToGraph = $PortsToGraph -split ','
  $TCBandwithUsageChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle
  foreach ($port in $PortsToGraph){
  
      $controller = $port.Substring(0,1)
      $portletter = $port.Substring(1,1)

      $TCBandwithUsageChart.AddSerie("$port", $LineType)
      
      get-HDSStatsPortTrueCopyTransRate -Controller $controller | ForEach-Object {

        $TCBandwithUsageChart.AddSerieValues("$port", $_.($XPropertyName), $_.($portletter))

      }


  }
  $TCBandwithUsageChart.SaveChart("$GraphOutputPath\PortTruecopyBandwithUsage.png")

}

