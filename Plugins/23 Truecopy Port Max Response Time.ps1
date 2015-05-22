$Title = "Port Truecopy Max Response Time"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# Which ports to graph? Example: All | 0a,0b,1a,1b
$PortsToGraph ="0d,1d"
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "Microseconds"
$AxisXTitle = "Time"
$ChartTitle = "TrueCopy Port Max Response Time"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsPortTrueCopyMaxTime {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    
    Get-Content -path $CsvPath"\CTL"$Controller"_Port_CTL_CMD_Max_Time.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    
}

$TCPortMaxResponseTimeChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle

if($PortsToGraph -eq "All"){
    
    
    $ctl0values = get-HDSStatsPortTrueCopyMaxTime -Controller 0 
    $ctl1values = get-HDSStatsPortTrueCopyMaxTime -Controller 1

    $ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

    foreach ($port in $ports){
    
        $TCPortMaxResponseTimeChart.AddSerie("0$port", $LineType)
        $ctl0values | ForEach-Object {

          $TCPortMaxResponseTimeChart.AddSerieValues("0$port", $_.($XPropertyName), $_.($port))

        }

    }
    foreach ($port in $ports){
    
        $TCPortMaxResponseTimeChart.AddSerie("1$port", $LineType)
        $ctl1values | ForEach-Object {

          $TCPortMaxResponseTimeChart.AddSerieValues("1$port", $_.($XPropertyName), $_.($port))

        }

    }

}else{

  $PortsToGraph = $PortsToGraph -split ','
  
  foreach ($port in $PortsToGraph){
  
      $controller = $port.Substring(0,1)
      $portletter = $port.Substring(1,1)

      $TCPortMaxResponseTimeChart.AddSerie("$port", $LineType)
      get-HDSStatsPortTrueCopyMaxTime -Controller $controller | ForEach-Object {

        $TCPortMaxResponseTimeChart.AddSerieValues("$port", $_.($XPropertyName), $_.($portletter))

      }

  }
}
$TCPortMaxResponseTimeChart.SaveChart("$GraphOutputPath\PortTruecopyMaxResponseTime.png")


