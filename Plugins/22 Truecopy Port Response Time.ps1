$Title = "Port Truecopy Response Time"
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
$ChartTitle = "TrueCopy Port Response Time"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsPortTrueCopyTime {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    
    Get-Content -path $CsvPath"\CTL"$Controller"_Port_Data_CMD_Time.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    
}

$TCResponseTimeChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle

if($PortsToGraph -eq "All"){
    
    $ctl0values = get-HDSStatsPortTrueCopyTime -Controller 0 
    $ctl1values = get-HDSStatsPortTrueCopyTime -Controller 1

    $ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

    foreach ($port in $ports){

        $TCResponseTimeChart.AddSerie("0$port", $LineType)    
        
        $ctl0values | ForEach-Object {

          $TCResponseTimeChart.AddSerieValues("0$port", $_.($XPropertyName), $_.($port))

        }

    }
    foreach ($port in $ports){
    
        $TCResponseTimeChart.AddSerie("1$port", $LineType)    
        
        $ctl1values | ForEach-Object {

          $TCResponseTimeChart.AddSerieValues("1$port", $_.($XPropertyName), $_.($port))

        }

    }

}else{

  $PortsToGraph = $PortsToGraph -split ','
  
  foreach ($port in $PortsToGraph){
  
      $controller = $port.Substring(0,1)
      $portletter = $port.Substring(1,1)

      $TCResponseTimeChart.AddSerie("$port", $LineType)
      get-HDSStatsPortTrueCopyTime -Controller $controller | ForEach-Object {

        $TCResponseTimeChart.AddSerieValues("$port", $_.($XPropertyName), $_.($portletter))

      }

  }

}

$TCResponseTimeChart.SaveChart("$GraphOutputPath\PortTruecopyResponseTime.png")

