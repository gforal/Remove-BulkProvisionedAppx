<#
    
    Author:  Graham Foral
    Date:    11/3/2022
    Version: 1.0

    .SYNOPSIS
    To provide a simple way to remove unwanted provisioned Appx packages included with an Online WIM.
    
    .PARAMETER Filters
    Specify the filters you want to use for Appx Removal

    .EXAMPLE
    ./Remove-BulkProvisionedAppx.ps1 -Filters zune,phone,xbox,maps,communications,skype,alarms,wallet,sketch,people,mspaint,mixed,solitaire,bing,"3dviewer"
    

#>

param($Filters)

$Filters -split "," | Out-Null
Write-Host "Number of filters: $($Filters.count)" 


ForEach ($Filter in $Filters) {
    $Filter = "`*" + $Filter + "`*"
    $Appxs = Get-AppxProvisionedPackage -Online | Where-Object { ($_.DisplayName -like $Filter) } 

    Write-Host "Processing filter $Filter, the following Provisioned Appx Packages were found:"
    Write-Host "$($Appxs.DisplayName)"

    ForEach ($Appx in $Appxs) {
        Write-Host "Removing $($Appx.DisplayName)"
        
        try { 
            Remove-AppxProvisionedPackage -Online -PackageName $Appx.PackageName -AllUsers 
        }
        catch {
                
        }
    }   
}
