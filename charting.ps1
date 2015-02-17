<#
.SYNOPSIS
   Creates graphs out of HDS Modular CSV files
.DESCRIPTION
   Creates graphs out of HDS Modular CSV Files
   Graphs are build useing plugins
.NOTES
   File Name  : charting.ps1
   Author     : Jeffrey Strik
   Version    : 2.0

.LINK
   http://www.google.com

.INPUTS
   See parameters
.OUTPUTS
   Graph images

.PARAMETER config
   If this switch is set, run the setup wizard for the global variables and all plugin variables

#>
param (
  [Switch]$config
)
$Version = "2.0"
$Date = Get-Date
Add-Type -AssemblyName System.Windows.Forms

################################################################################
#                                  Functions                                   #
################################################################################
<# Write timestamped output to screen #>
function Write-CustomOut ($Details){
  $LogDate = Get-Date -Format T
  Write-Host "$($LogDate) $Details"
}

<# Search $file_content for name/value pair with ID_Name and return value #>
Function Get-ID-String ($file_content,$ID_name) {
  if ($file_content | Select-String -Pattern "\$+$ID_name\s*=") {
    $value = (($file_content | Select-String -pattern "\$+${ID_name}\s*=").toString().split("=")[1]).Trim(' "')
    return ( $value )
  }
}

<# Get basic information abount a plugin #>
Function Get-PluginID ($Filename){
  # Get the identifying information for a plugin script
  $file = Get-Content $Filename
  $Title = Get-ID-String $file "Title"
  if ( !$Title ) { $Title = $Filename }
  $PluginVersion = Get-ID-String $file "PluginVersion"
  $Author = Get-ID-String $file "Author"
  $Ver = "{0:N1}" -f $PluginVersion

  return @{"Title"=$Title; "Version"=$Ver; "Author"=$Author }
}

<# Run through settings for specified file, expects question on one line, and variable/value on following line #>
Function Invoke-Settings ($Filename, $GB) {
  $file = Get-Content $filename
  $OriginalLine = ($file | Select-String -Pattern "# Start of Settings").LineNumber
  $EndLine = ($file | Select-String -Pattern "# End of Settings").LineNumber
  if (!(($OriginalLine +1) -eq $EndLine)) {
    $Array = @()
    $Line = $OriginalLine
    $PluginName = (Get-PluginID $Filename).Title
    If ($PluginName.EndsWith(".ps1",1)) {
      $PluginName = ($PluginName.split("\")[-1]).split(".")[0]
    }
    Write-Host "`n$PluginName"
    do {
      $Question = $file[$Line]
      $Line ++
      $Split= ($file[$Line]).Split("=")
      $Var = $Split[0]
      $CurSet = $Split[1]

      # Check if the current setting is in speech marks
      $String = $false
      if ($CurSet -match '"') {
        $String = $true
        $CurSet = $CurSet.Replace('"', '')
      }
      $NewSet = Read-Host "$Question [$CurSet]"
      If (-not $NewSet) {
        $NewSet = $CurSet
      }
      If ($String) {
        $Array += $Question
        #$Array += "$Var=`"$NewSet`""

        #if variable being read and set is regarding csv path, show folder browser
        if($Var -match '\$CsvPath'){

          $pfmFolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
              SelectedPath = $PfmPath
              }

          [void]$pfmFolderBrowser.ShowDialog()

          $pathselected = $pfmFolderBrowser.SelectedPath
          $Array += "$Var=`"$pathselected`""
        }else{

          $Array += "$Var=`"$NewSet`""

        }
      } Else {
        $Array += $Question
        #$Array += "$Var=$NewSet"
        #if variable being read and set is regarding csv path, show folder browser
        if($Var -match '\$CsvPath'){

          $pfmFolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
              SelectedPath = $CsvPath
              }

          [void]$pfmFolderBrowser.ShowDialog()
          #$test = $pfmFolderBrowser.SelectedPath
          $pathselected = $pfmFolderBrowser.SelectedPath
          $Array += "$Var=$pathselected"

        }else{

          $Array += "$Var=$NewSet"

        }

      }

      $Line ++
    } Until ( $Line -ge ($EndLine -1) )
    $Array += "# End of Settings"

    $out = @()
    $out = $File[0..($OriginalLine -1)]
    $out += $array
    $out += $File[$Endline..($file.count -1)]
    if ($GB) { $out[$SetupLine] = '$SetupWizard =$False' }
    $out | Out-File $Filename
  }
}


################################################################################
#                                Initialization                                #
################################################################################
# Setup all paths required for script to run
function Get-ScriptDirectory
{
    Split-Path $script:MyInvocation.MyCommand.Path
}

$ScriptPath = (Split-Path ((Get-Variable MyInvocation).Value).MyCommand.Path)

$PluginsFolder = "$(Get-ScriptDirectory)\Plugins\"
$Plugins = Get-ChildItem -Path $PluginsFolder -filter "*.ps1" | Sort Name
$GlobalVariables = "$(Get-ScriptDirectory)\GlobalVariables.ps1"

## Determine if the setup wizard needs to run
$file = Get-Content $GlobalVariables
$Setup = ($file | Select-String -Pattern '# Set the following to true to enable the setup wizard for first time run').LineNumber
$SetupLine = $Setup ++
$SetupSetting = Invoke-Expression (($file[$SetupLine]).Split("="))[1]

#check for environment value existence to specify start of folderbrowser
if(test-path Env:\HDS_PFMHOME){
  $PfmPath = $env:HDS_PFMHOME
}else{
  $PfmPath = 'C:\'
}

if ($SetupSetting -or $config) {
  Clear-Host
  Invoke-Settings -Filename $GlobalVariables -GB $true
	<#Foreach ($plugin in $Plugins) {
		Invoke-Settings -Filename $plugin.Fullname
	}#>
}

## Include GlobalVariables and validate settings
#Write-Host "Including global variables from $GlobalVariables..."
. "$(Get-ScriptDirectory)\GlobalVariables.ps1"

$testing = Test-Path $GraphOutputPath -pathType container
if((Test-Path $GraphOutputPath -pathType container) -eq $False ){

  write-host "Graph Output folder specified does not exist. creating folder"
  New-Item -ItemType Directory -Force -Path "$GraphOutputPath" |Out-Null


}

if ($SetupSetting -or $config) {
  Foreach ($plugin in $Plugins) {
    Invoke-Settings -Filename $plugin.Fullname
  }
}


$gvars = @("CsvPath" , "CustomerName" , "GraphOutputFolderName" )
foreach($gvar in $gvars) {
  if (!($(Get-Variable -Name "$gvar" -Erroraction 'SilentlyContinue'))) {
    Write-Error ($lang.varUndefined -f $gvar)
  }
}

################################################################################
#                                 Script logic                                 #
################################################################################
# Start generating the report
#$TTRReport = @()
Write-Host "`nBegin Plugin Processing"
# Loop over all enabled plugins
$p = 0
$Plugins | Foreach {
  #$TableFormat = $null
  $IDinfo = Get-PluginID $_.Fullname
  $p++
  Write-CustomOut ($IDinfo["Title"], $IDinfo["Version"])
  #$pluginStatus = ($lang.pluginStatus -f $p, $plugins.count, $_.Name)
  #$TTR = [math]::round((Measure-Command {$Details = . $_.FullName}).TotalSeconds, 2)
  . $_.FullName
  #$TTRReport += New-Object PSObject -Property @{"Name"=$_.Name; "TimeToRun"=$TTR}
  #$ver = "{0:N1}" -f $PluginVersion
  #Write-CustomOut ($IDinfo["Title"], $IDinfo["Version"])
}

################################################################################
#                                    Output                                    #
################################################################################
# Run EndScript once everything else is complete
if (Test-Path ($ScriptPath + "\EndScript.ps1")) {
  . ($ScriptPath + "\EndScript.ps1")
}
