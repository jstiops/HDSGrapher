# HDSGrapher

Graphing HDS storage statistics

This script framework can creat graphs from .csv files coming from HDS HUS and AMS storage arrays
.CSV files have to be generated using Storage Navigator Modular 2


##Supported arrays:
* HUS110
* HUS130
* HUS150
* AMS2100
* AMS2300
* AMS2500

These scripts use the PSGraph powershell module. 
https://github.com/jsttech/PSGraph

##Instalation
1. Download the .zip bundle of HDSGrapher from Github
2. Download and install the PSGraph powershell module
3. Install MS Chart control (if .NET < 4.0, it's included in .NET 4.0 and higher)
4. Unpack GDSGrapher zip file locally
5. Start a powershell console
6. Run **HDSGrapher\select-plugins.ps1** to select graphs to generate
7. Run **HDSGrapher\charting.ps1 -config** to answer some basic questions and point to the folder which contains the .CSV files
