$Title = "LUN Average Tag count"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0

# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "Average Tag Count"
$AxisXTitle = "Time"
$ChartTitle = "LUN Average Tag Count (Queue Depth)"
$XPropertyName = "Time"
#settings for plugins

$HUSLUNbestPracticeQueueDepth = 32



function get-HDSStatsLUNAVGTagCount {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True)][string[]]$ID
  )
  $ctl0values = Get-Content -path $CsvPath"\CTL0_Luex_TagAverage01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
  $ctl1values = Get-Content -path $CsvPath"\CTL1_Luex_TagAverage01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
  
  $counter = 0
  $objCollection = @()
  $ctl0values | ForEach-Object {
    
    $ctl1value = $ctl1values[$counter] | Select-Object -ExpandProperty $($ID) 
    $totalValue = [int]$_.($ID) + [int]$ctl1value
    $props = [ordered]@{Time = $_.Time
                            TagCount =  $totalValue
							LUNLimit = $HUSLUNbestPracticeQueueDepth
                        }
    $obj= New-Object -TypeName PSObject -Property $props
    $objCollection += $obj
    $counter++
  }
  
  $objCollection
  
  
}

$LUNAVGTagCountAllChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\LUNAVGTagCounts"

  
  
  $ctl0values = Get-Content -path $CsvPath"\CTL0_Luex_TagAverage01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
  $luns = $ctl0values |gm|Where-Object {$_.Name -match '\d+' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name 
  $counter=0
  foreach ($lun in $luns){
    $counter++
    $objects = get-HDSStatsLUNAVGTagCount -ID $lun 

    #Create Chart for individual LUNs
    $LUNAVGTagCountChart = New-PSGraphChart -ChartTitle "$ChartTitle - LUN$lun" -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
    
    #add serie to graph with all LUNs
    $objects| Add-PSGraphSerie -ChartName "LUNAVGTagCountAllChart" -Name "LUN $lun" -YPropertyName "TagCount" -XPropertyName $XPropertyName -Type "StackedArea"
    
    #add serie to graph with individual LUNs
    $objects | Add-PSGraphSerie -ChartName "LUNAVGTagCountChart" -Name "LUN $lun" -YPropertyName "TagCount" -XPropertyName $XPropertyName -Type $LineType
    
    #voeg als laatste de best practice lijn toe.
    #eerst voor alle LUNs
    if ($counter -eq ($LUNsToGraph | measure).Count){
      #add serie to graph with all LUNs
      $objects | Add-PSGraphSerie -ChartName "LUNAVGTagCountAllChart" -Name "LUN Best Practice limit" -YPropertyName "LUNLimit" -XPropertyName $XPropertyName -Type $LineType
     
    }
    
    #add serie to graph for individual LUNs
    $objects | Add-PSGraphSerie -ChartName "LUNAVGTagCountChart" -Name "LUN Best Practice limit" -YPropertyName "LUNLimit" -XPropertyName $XPropertyName -Type $LineType
    
    #save individual LUN charts
    $LUNAVGTagCountChart.SaveChart("$GraphOutputPath\LUNAVGTagCounts\LUNAVGTagCount_LUN$LUN.png")
    
  }

  

$LUNAVGTagCountAllChart.SaveChart("$GraphOutputPath\LUNAVGTagCounts\LUNAVGTagCount.png")



