﻿$Title = "DP Pool IO Rate"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "StackedArea"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "HDP Pool IOPs"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsDPPoolIORate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$ID
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_DPPool_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_DPPool_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    
    
    $counter = 0
    $objCollection = @()
    $ctl0values | ForEach-Object {
        
        $ctl1value = $ctl1values[$counter] | Select-Object -ExpandProperty $($ID) 
        $totalValue = [int]$_.($ID) + [int]$ctl1value
        $props = [ordered]@{Time = $_.Time
                            IORate =  $totalValue
                        }
        $obj= New-Object -TypeName PSObject -Property $props
        $objCollection += $obj
        $counter++
    }

    $objCollection
    

}
$PoolIOPsChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

$ctl0values = Get-Content -path $CsvPath"\CTL0_DPPool_IORate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
$pools = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\PoolIORate" |Out-Null

foreach ($pool in $pools){
  
  $PoolIOPsChart.AddSerie("Pool $pool", $LineType)
  get-HDSStatsDPPoolIORate -ID $pool | ForEach-Object{

    $PoolIOPsChart.AddSerieValues("Pool $pool", $_.($XPropertyName), $_.IORate)

  }

  $PoolIOPsSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - Pool $pool" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $PoolIOPsSingleChart.AddSerie("Pool $pool", $LineType)
  get-HDSStatsDPPoolIORate -ID $pool | ForEach-Object {

   $PoolIOPsSingleChart.AddSerieValues("Pool $pool", $_.($XpropertyName), $_.IORate)

  }
  $PoolIOPsChart.SaveChart("$GraphOutputPath\PoolIORate\DPPoolIORate_Pool$Pool.png")       
}
   
$PoolIOPsChart.SaveChart("$GraphOutputPath\PoolIORate\DPPoolIORate.png")
    







