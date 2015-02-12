$Title = "Port Truecopy Response Time"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# Which ports to graph? Example: All | 0a,0b,1a,1b
$PortsToGraph ="0c,1c"
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
    
        $ctl0values | Add-PSGraphSerie -ChartName "TCResponseTimeChart" -Name "0$port" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType

    }
    foreach ($port in $ports){
    
        $ctl1values | Add-PSGraphSerie -ChartName "TCResponseTimeChart" -Name "1$port" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType

    }

}else{

  $PortsToGraph = $PortsToGraph -split ','
  
  foreach ($port in $PortsToGraph){
  
      $controller = $port.Substring(0,1)
      $portletter = $port.Substring(1,1)

      get-HDSStatsPortTrueCopyTime -Controller $controller | Add-PSGraphSerie -ChartName "TCResponseTimeChart" -Name $port -YPropertyName $portletter -XPropertyName $XPropertyName -Type $LineType


  }
  

}

$TCResponseTimeChart.SaveChart("$GraphOutputPath\PortTruecopyResponseTime.png")

