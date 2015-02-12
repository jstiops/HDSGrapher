$Title = "Drive TagCount v2"
$Author = "Jeffrey Strik"
$PluginVersion = 2.0
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
    
    $ctl0values | Add-PSGraphSerie -Name "CTL0-$drive" -YPropertyName $drive -XPropertyName $XPropertyName -ChartName "DriveTagChartC0" -Type $LineType

  }
  
}

if($DriveToGraph -eq "All"){
  
  $DriveTagChartC1 = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval 
  foreach ($drive in $drives){
    
    $ctl1values | Add-PSGraphSerie -Name "CTL1-$drive" -YPropertyName $drive -XPropertyName $XPropertyName -ChartName "DriveTagChartC1" -Type $LineType

  }
  
}

$DriveTagChartC0.SaveChart("$GraphOutputPath\DriveTagCountC0.png")
$DriveTagChartC1.SaveChart("$GraphOutputPath\DriveTagCountC1.png")
