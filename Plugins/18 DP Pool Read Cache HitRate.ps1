﻿$Title = "DP Pool Cache Read HitRate"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


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


$ctl0values = Get-Content -path $CsvPath"\CTL0_DPPool_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
$pools = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\PoolReadHitRates" | Out-Null

foreach ($pool in $pools){
  
  $PoolReadHitRatesSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - Pool $pool" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $PoolReadHitRatesSingleChart.AddSerie("C0 - Pool $pool", $LineType)
  $PoolReadHitRatesSingleChart.AddSerie("C1 - Pool $pool", $LineType)  
  
  get-HDSStatsDPPoolIORate -Controller 0 | ForEach-Object {

    $PoolReadHitRatesSingleChart.AddSerieValues("C0 - Pool $pool", $_.($XpropertyName), $_.($pool))

  }

  get-HDSStatsDPPoolIORate -Controller 1 | ForEach-Object {

    $PoolReadHitRatesSingleChart.AddSerieValues("C1 - Pool $pool", $_.($XpropertyName), $_.($pool))

  }
  $PoolReadHitRatesSingleChart.SaveChart("$GraphOutputPath\PoolReadHitRates\PoolReadHitRates_Pool$Pool.png")       
}

    







