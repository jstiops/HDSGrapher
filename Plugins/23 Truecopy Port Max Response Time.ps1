$Title = "Port Truecopy Max Response Time"
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
    
    New-Chart -ChartTitle "Port Truecopy Max Response Time" -AxisYTitle "MicroSecond" -AxisXInterval $AxisXInterval
    $ctl0values = get-HDSStatsPortTrueCopyMaxTime -Controller 0 
    $ctl1values = get-HDSStatsPortTrueCopyMaxTime -Controller 1

    $ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

    foreach ($port in $ports){
    
        $ctl0values | Add-PSGraphSerie -ChartName "TCPortMaxResponseTimeChart" -Name "0$port" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType

    }
    foreach ($port in $ports){
    
        $ctl1values | Add-PSGraphSerie -ChartName "TCPortMaxResponseTimeChart" -Name "1$port" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType

    }

}else{

  $PortsToGraph = $PortsToGraph -split ','
  
  foreach ($port in $PortsToGraph){
  
      $controller = $port.Substring(0,1)
      $portletter = $port.Substring(1,1)

      get-HDSStatsPortTrueCopyMaxTime -Controller $controller | Add-PSGraphSerie -ChartName "TCPortMaxResponseTimeChart" -Name $port -YPropertyName $portletter -XPropertyName $XPropertyName -Type $LineType

  }
}
$TCPortMaxResponseTimeChart.SaveChart("$GraphOutputPath\PortTruecopyMaxResponseTime.png")


