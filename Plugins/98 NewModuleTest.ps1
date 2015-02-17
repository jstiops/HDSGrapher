$Title = "New Module Test"
$Author = "Jeffrey Strik"
$PluginVersion = 1.0
#settings for plugins
$LineType = "StackedArea"
$AxisYTitle = "IOPs"
$AxisXTitle = "Time"
$ChartTitle = "Plugin to test new module architecture"
$XPropertyName = "Time"
#settings for plugins
function get-HDSStatsPortIORate {
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string[]]$Controller
)
    $content = Get-Content -path $CsvPath"\CTL"$Controller"_Port_IORate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $content
}


$FEPortChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYtitle -AxisXInterval $AxisXInterval

$ctl0values = get-HDSStatsPortIORate -Controller 0
$ctl1values = get-HDSStatsPortIORate -Controller 1

$ports = $ctl0values |gm|Where-Object {$_.Name -match '^[ABCDEFGH]' -and $_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name
New-Item -ItemType Directory -Force -Path "$GraphOutputPath\ModuleTests" |out-null

foreach ($port in $ports){

    #$ctl0values | Add-PSGraphSerie -Name "0$port" -ChartName "FEPortChart" -YPropertyName $port -XPropertyName $XPropertyName -Type $LineType
    $FEPortChart.AddSerie("0$port")
    $ctl0values | Foreach-Object {

        $FEPortChart.AddSerieValues("0$port", $_.($XPropertyName), $_.($port))

    }

}

$FEPortChart.SaveChart("$GraphOutputPath\ModuleTests\ModuleTest.png")
