import-module PSGraph

function Get-ScriptDirectory
{
    Split-Path $script:MyInvocation.MyCommand.Path
}
get-scriptdirectory

(get-scriptdirectory)+"\dkdkdkd.ps1"
