﻿$Title = "Total Reads VS Writes Percentage"
$Author = "Jeffrey Strik"
$PluginVersion = 3.0


# Start of Settings
# End of Settings

#settings for plugins
$LineType = "StackedArea100"
$AxisYTitle = "%"
$AxisXTitle = "Time"
$ChartTitle = "Read VS Write IOPs"
$XPropertyName = "Time"
#settings for plugins


Function RvsWPortReadRate {
    
    $ctl0values = Get-Content -path $CsvPath"\CTL0_Port_ReadRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Port_ReadRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    #get the ports used on this system
    $PortsObj = $ctl0values | get-member | Where-Object {$_.Name -eq "A" -or $_.Name -eq "B" -or $_.Name -eq "C" -or $_.Name -eq "D" -or $_.Name -eq "E" -or $_.Name -eq "F"}

    #build objects with summed total property added to it for Controller0 values
    $objCollectionC0 = @()
    $ctl0Values | ForEach-Object {
        $totalIORate = 0
        $currentObj = $_
            $PortsObj | ForEach-Object {
        
                $totalIORate = $totalIORate +  [int]($currentObj |Select-Object -ExpandProperty ($_.Name))

            }
        $_ |Add-Member NoteProperty TotalIORate $totalIORate
        $objCollectionC0 += $_
    }

    #build objects with summed total property added to it for Controller1 values
    $objCollectionC1 = @()
    $ctl1Values | ForEach-Object {
        $totalIORate = 0
        $currentObj = $_
            $PortsObj | ForEach-Object {
        
                $totalIORate = $totalIORate +  [int]($currentObj |Select-Object -ExpandProperty ($_.Name))

            }
        $_ |Add-Member NoteProperty TotalIORate $totalIORate
        $objCollectionC1 += $_
    }

    #build objects with calculated IORate. This is the Sum of all IOPs of all ports from both controllers
    $objCollectionTotal = @()
    $counter = 0
    $objCollectionC0 | ForEach-Object {

        $totalIORate = [int]$_.TotalIORate + [int]$objCollectionC1[$counter].TotalIORate
        
        $props = [ordered]@{Time = $_.Time
                            ReadRate =  $totalIORate
                        }
        $obj= New-Object -TypeName PSObject -Property $props
        $objCollectionTotal += $obj

    }
 
    $objCollectionTotal

}

Function RvsWPortWriteRate {
    
    $ctl0values = Get-Content -path $CsvPath"\CTL0_Port_WriteRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","
    $ctl1values = Get-Content -path $CsvPath"\CTL1_Port_WriteRate.csv" | Select-Object -Skip 5 | ConvertFrom-Csv -Delimiter ","

    #get the ports used on this system
    $PortsObj = $ctl0values | get-member | Where-Object {$_.Name -eq "A" -or $_.Name -eq "B" -or $_.Name -eq "C" -or $_.Name -eq "D" -or $_.Name -eq "E" -or $_.Name -eq "F"}

    #build objects with summed total property added to it for Controller0 values
    $objCollectionC0 = @()
    $ctl0Values | ForEach-Object {
        $totalIORate = 0
        $currentObj = $_
            $PortsObj | ForEach-Object {
        
                $totalIORate = $totalIORate +  [int]($currentObj |Select-Object -ExpandProperty ($_.Name))

            }
        $_ |Add-Member NoteProperty TotalIORate $totalIORate
        $objCollectionC0 += $_
    }

    #build objects with summed total property added to it for Controller1 values
    $objCollectionC1 = @()
    $ctl1Values | ForEach-Object {
        $totalIORate = 0
        $currentObj = $_
            $PortsObj | ForEach-Object {
        
                $totalIORate = $totalIORate +  [int]($currentObj |Select-Object -ExpandProperty ($_.Name))

            }
        $_ |Add-Member NoteProperty TotalIORate $totalIORate
        $objCollectionC1 += $_
    }

    #build objects with calculated IORate. This is the Sum of all IOPs of all ports from both controllers
    $objCollectionTotal = @()
    $counter = 0
    $objCollectionC0 | ForEach-Object {

        $totalIORate = [int]$_.TotalIORate + [int]$objCollectionC1[$counter].TotalIORate
        
        $props = [ordered]@{Time = $_.Time
                            WriteRate =  $totalIORate
                        }
        $obj= New-Object -TypeName PSObject -Property $props
        $objCollectionTotal += $obj

    }
 
    $objCollectionTotal

}



$ReadVSWriteChart = New-PSGraphChart -ChartTitle $ChartTitle -AxisXTitle $AxisXTitle -AxisYTitle $AxisYTitle -AxisXInterval $AxisXInterval
$ReadVSWriteChart.AddSerie("Reads", $LineType)
$ReadVSWriteChart.AddSerie("Writes", $LineType)
RvsWPortReadRate | ForEach-Object {

  $ReadVSWriteChart.AddSerieValues("Reads", $_.($XPropertyName), $_.ReadRate)

}
RvsWPortWriteRate | ForEach-Object {

  $ReadVSWriteChart.AddSerieValues("Writes", $_.($XPropertyName), $_.WriteRate)

}
$ReadVSWriteChart.SaveChart("$GraphOutputPath\ReadsVSWritesPercentage.png")
