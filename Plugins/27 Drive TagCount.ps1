﻿$Title = "Drive TagCount v2"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0
# Graphs all drives


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "Line"
$AxisYTitle = "Tag Count"
$AxisXTitle = "Time"
$ChartTitle = "Drive Tag Count"
$XPropertyName = "Time"
$DriveToGraph ="All"
#settings for plugins
	
function get-HDSStatsDriveTagCount {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
  )
  
  $content = Get-Content -path $CsvPath"\CTL"$Controller"_DriveOpe_TagCount01.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
  $content  

}

$ctl0values = get-HDSStatsDriveTagCount -Controller 0 
$ctl1values = get-HDSStatsDriveTagCount -Controller 1
$drives = $ctl0values |Get-Member|Where-Object {$_.Name -match "\d+" -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

if($DriveToGraph -eq "All"){
  
  
  $DriveTagChartC0 = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
  foreach ($drive in $drives){
    $DriveTagChartC0.AddSerie("CTL0-$drive", $LineType)
    $ctl0values | ForEach-Object{
     
      $DriveTagChartC0.AddSerieValues("CTL0-$drive", $_.($XPropertyName), $_.($drive))

    }
    
  }
  
}

if($DriveToGraph -eq "All"){
  
  $DriveTagChartC1 = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval 
  foreach ($drive in $drives){
    
    $DriveTagChartC1.AddSerie("CTL1-$drive", $LineType)
    $ctl1values | ForEach-Object {

      $DriveTagChartC1.AddSerieValues("CTL1-$drive", $_.($XPropertyName), $_.($drive))

    }
    
  }
  
}

$DriveTagChartC0.SaveChart("$GraphOutputPath\DriveTagCountC0.png")
$DriveTagChartC1.SaveChart("$GraphOutputPath\DriveTagCountC1.png")
