﻿$Title = "LUN Read Cache Hit Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0

# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "LUN Read Cache Hit Rate"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsLUNReadHitRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $ctlValues = Get-Content -path $CsvPath"\CTL"$Controller"_Lu_ReadHit01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctlValues

}


New-Item -ItemType Directory -Force -Path "$GraphOutputPath\LUNReadHitRate" | Out-Null
    
$ctl0values = Get-Content -path $CsvPath"\CTL0_Lu_ReadHit01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
$ctl1values = Get-Content -path $CsvPath"\CTL1_Lu_ReadHit01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

$luns = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

foreach ($lun in $luns){
  
  $LUNReadCacheHitRateSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - LUN$LUN" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $LUNReadCacheHitRateSingleChart.AddSerie("C0 - LUN $lun", $LineType)
  $LUNReadCacheHitRateSingleChart.AddSerie("C1 - LUN $lun", $LineType)

  
  $ctl0values | ForEach-Object {

    $LUNReadCacheHitRateSingleChart.AddSerieValues("C0 - LUN $lun", $_.($XPropertyName), $_.($lun))

  }
  
  
  $ctl1values | ForEach-Object {

    $LUNReadCacheHitRateSingleChart.AddSerieValues("C1 - LUN $lun", $_.($XPropertyName), $_.($lun))

  }

  $LUNReadCacheHitRateSingleChart.SaveChart("$GraphOutputPath\LUNReadHitRate\LUNReadHitRate_LUN$lun.png")

}
    


