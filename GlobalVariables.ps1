# You can change the following defaults by altering the below settings:
#


# Set the following to true to enable the setup wizard for first time run
$SetupWizard =$False
# Please set the output foldername for the graphs (must be available in the folder where CSVs are located)
$GraphOutputFolderName ="graphs"

# Start of Settings
# Press enter to select the folder containing CSV files, current setting is:
$CsvPath ="C:\hds\pfmhome\"
# Specify the X-Asis interval
$AxisXInterval =5
# End of Settings

# Please Specify the customer name
$CustomerName ="Customer"
# Specify if chart images will be opened after generating them
$OpenGraphImages =$false

[string]$GraphOutputPath ='{0}\{1}' -f $CsvPath,$GraphOutputFolderName

# End of Global Variables
