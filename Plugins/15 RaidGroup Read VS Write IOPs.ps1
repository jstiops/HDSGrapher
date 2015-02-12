$Title = "RaidGroup Read VS Write IOPs"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "StackedArea"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "RaidGroup Read vs Write IOPs"
$XPropertyName = "Time"
#settings for plugins

function get-HDSStatsRGReadRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$ID
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_Rg_ReadRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Rg_ReadRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    
    
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

function get-HDSStatsRGWriteRate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$ID
)
    $ctl0values = Get-Content -path $CsvPath"\CTL0_Rg_WriteRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Rg_WriteRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    
    
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

$ctl0values = Get-Content -path $CsvPath"\CTL0_Rg_WriteRate01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

$rgs = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 

New-Item -ItemType Directory -Force -Path "$GraphOutputPath\RGReadsVSWrites"

foreach ($rg in $rgs){
  
  $RGReadVSWriteSingleChart = New-PSGraphChart -ChartTitle "$ChartTitle - RG $rg" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval

  get-HDSStatsRGReadRate -ID $rg | Add-PSGraphSerie -ChartName "RGReadVSWriteSingleChart" -Name "Reads" -YPropertyName "ReadRate" -XPropertyName $XPropertyName -Type $LineType
  get-HDSStatsRGWriteRate -ID $rg | Add-PSGraphSerie -ChartName "RGReadVSWriteSingleChart" -Name "Writes" -YPropertyName "WriteRate" -XPropertyName $XPropertyName -Type $LineType

  $RGReadVSWriteSingleChart.SaveChart("$GraphOutputPath\RGReadsVSWrites\RGReadsVSWrites_RG$rg.png")

}