﻿$Title = "LUN Read VS Write IOPs"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "StackedArea"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "LUN Read VS Write IOPs"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsLUNReadRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$ID
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_Lu_ReadRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Lu_ReadRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    
    
    $counter = 0
    $objCollection = @()
    $ctl0values | ForEach-Object {
        
        $ctl1value = $ctl1values[$counter] | Select-Object -ExpandProperty $($ID) 
        $totalValue = [int]$_.($ID) + [int]$ctl1value
        $props = [ordered]@{Time = $_.Time
                            ReadRate =  $totalValue
                        }
        $obj= New-Object -TypeName PSObject -Property $props
        $objCollection += $obj
        $counter++
    }

    $objCollection


}

function get-HDSStatsLUNWriteRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$ID
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_Lu_WriteRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Lu_WriteRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    
    
    $counter = 0
    $objCollection = @()
    $ctl0values | ForEach-Object {
        
        $ctl1value = $ctl1values[$counter] | Select-Object -ExpandProperty $($ID) 
        $totalValue = [int]$_.($ID) + [int]$ctl1value
        $props = [ordered]@{Time = $_.Time
                            WriteRate =  $totalValue
                        }
        $obj= New-Object -TypeName PSObject -Property $props
        $objCollection += $obj
        $counter++
    }

    $objCollection


}

$ctl0values = Get-Content -path $CsvPath"\CTL0_Lu_WriteRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

$luns = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

New-Item -ItemType Directory -Force -Path "$GraphOutputPath\LUNReadsVSWrites" | Out-Null

foreach ($lun in $luns){
  
  $LUNReadVSWriteSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - LUN$lun" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  $LUNReadVSWriteSingleChart.AddSerie("Reads", $LineType)
  get-HDSStatsLUNReadRate -ID $lun | ForEach-Object {

    $LUNReadVSWriteSingleChart.AddSerieValues("Reads", $_.($XPropertyName), $_.ReadRate)

  }

  $LUNReadVSWriteSingleChart.AddSerie("Writes", $LineType)
  get-HDSStatsLUNWriteRate -ID $lun | ForEach-Object {

    $LUNReadVSWriteSingleChart.AddSerieValues("Writes", $_.($XPropertyName), $_.WriteRate)

  }

  $LUNReadVSWriteSingleChart.SaveChart("$GraphOutputPath\LUNReadsVSWrites\LUNReadsVSWrites_LUN$lun.png")

}
