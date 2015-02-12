$Title = "Port Truecopy Bandwith Usage"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# Which ports to graph? Example: All | 0a,0b,1a,1b
$PortsToGraph ="0c,1c"
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
    
        $ctl0values | Add-PSGraphSerie -ChartName "TCBandwithUsageChart" -Name "0$port" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType

    }
    foreach ($port in $ports){
    
        $ctl1values | Add-PSGraphSerie -ChartName "TCBandwithUsageChart" -Name "1$port" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType

    }
    $TCBandwithUsageChart.SaveChart("$GraphOutputPath\PortTruecopyBandwithUsage.png")
    


}else{

  $PortsToGraph = $PortsToGraph -split ','
  $TCBandwithUsageChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle
  foreach ($port in $PortsToGraph){
  
      $controller = $port.Substring(0,1)
      $portletter = $port.Substring(1,1)

      get-HDSStatsPortTrueCopyTransRate -Controller $controller | Add-PSGraphSerie -ChartName "TCBandwithUsageChart" -Name $port -YPropertyName $portletter -XPropertyName $XPropertyName -Type $LineType


  }
  $TCBandwithUsageChart.SaveChart("$GraphOutputPath\PortTruecopyBandwithUsage.png")

}

