$Title = "LUN Read VS Write IOPs"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


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

New-Item -ItemType Directory -Force -Path "$GraphOutputPath\LUNReadsVSWrites"

foreach ($lun in $luns){
  
  $LUNReadVSWriteSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - LUN$lun" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

  get-HDSStatsLUNReadRate -ID $lun | Add-PSGraphSerie -ChartName "LUNReadVSWriteSingleChart" -Name "Reads" -YPropertyName "ReadRate" -XPropertyName $XPropertyName -Type $LineType
  get-HDSStatsLUNWriteRate -ID $lun | Add-PSGraphSerie -ChartName "LUNReadVSWriteSingleChart" -Name "Writes" -YPropertyName "WriteRate" -XPropertyName $XPropertyName -Type $LineType

  $LUNReadVSWriteSingleChart.SaveChart("$GraphOutputPath\LUNReadsVSWrites\LUNReadsVSWrites_LUN$lun.png")

}
