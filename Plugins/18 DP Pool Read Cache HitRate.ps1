$Title = "DP Pool Cache Read HitRate"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "HDP Pool Read Cache Hitrate"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsDPPoolIORate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $ctlValues = Get-Content -path $CsvPath"\CTL"$Controller"_DPPool_ReadHit01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    
    $ctlValues
    

}
$PoolReadHitRatesChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

$ctl0values = Get-Content -path $CsvPath"\CTL0_DPPool_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
$pools = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\PoolReadHitRates"

foreach ($pool in $pools){
  
  $PoolReadHitRatesSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - Pool $pool" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  
  get-HDSStatsDPPoolIORate -Controller 0 | Add-PSGraphSerie -ChartName "PoolReadHitRatesSingleChart" -Name "C0 - Pool $pool" -XPropertyName $XPropertyName -YPropertyName $pool -Type $LineType 
  get-HDSStatsDPPoolIORate -Controller 1 | Add-PSGraphSerie -ChartName "PoolReadHitRatesSingleChart" -Name "C1 - Pool $pool" -XPropertyName $XPropertyName -YPropertyName $pool -Type $LineType 
  $PoolReadHitRatesSingleChart.SaveChart("$GraphOutputPath\PoolReadHitRates\PoolReadHitRates_Pool$Pool.png")       
}

foreach ($pool in $pools){
  
  $PoolReadHitRatesSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - Pool $pool" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  get-HDSStatsDPPoolIORate -Controller 0 | Add-PSGraphSerie -ChartName "PoolReadHitRatesChart" -Name "C0 - Pool $pool" -XPropertyName $XPropertyName -YPropertyName $pool -Type $LineType 
  get-HDSStatsDPPoolIORate -Controller 1 | Add-PSGraphSerie -ChartName "PoolReadHitRatesChart" -Name "C1 - Pool $pool" -XPropertyName $XPropertyName -YPropertyName $pool -Type $LineType 
  
}
   
$PoolReadHitRatesChart.SaveChart("$GraphOutputPath\PoolReadHitRates\PoolReadHitRates.png")
    







