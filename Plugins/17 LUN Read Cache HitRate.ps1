$Title = "LUN Read Cache Hit Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0

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

$LUNReadCacheHitRateChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\LUNReadHitRate"
    
$ctl0values = Get-Content -path $CsvPath"\CTL0_Lu_ReadHit01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
$ctl1values = Get-Content -path $CsvPath"\CTL1_Lu_ReadHit01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

$luns = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

foreach ($lun in $luns){
  $LUNReadCacheHitRateSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - LUN$LUN" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

  $ctl0values | Add-PSGraphSerie -ChartName "LUNReadCacheHitRateChart" -Name "C0 - LUN $lun" -YPropertyName $lun -XPropertyName $XPropertyName -Type $LineType
  $ctl1values | Add-PSGraphSerie -ChartName "LUNReadCacheHitRateChart" -Name "C1 - LUN $lun" -YPropertyName $lun -XPropertyName $XPropertyName -Type $LineType

  $ctl0values | Add-PSGraphSerie -ChartName "LUNReadCacheHitRateSingleChart" -Name "C0 - LUN $lun" -YPropertyName $lun -XPropertyName $XPropertyName -Type $LineType
  $ctl1values | Add-PSGraphSerie -ChartName "LUNReadCacheHitRateSingleChart" -Name "C1 - LUN $lun" -YPropertyName $lun -XPropertyName $XPropertyName -Type $LineType

  $LUNReadCacheHitRateSingleChart.SaveChart("$GraphOutputPath\LUNReadHitRate\LUNReadHitRate_LUN$lun.png")

}
   
$LUNReadCacheHitRateChart.SaveChart("$GraphOutputPath\LUNReadHitRate\LUNReadHitRate.png")
    


