<######################################  
SYNOPSIS  
     Data scrapes all anchors from website to CSV with full tag info and exports href elements to a text document.
DESCRIPTION   
    Generates a report proivding detailed information for all links on the set site.
NOTES  
    File Name  : get-URL.ps1  
    Author     : Luke Encrapera
    Email      : luke.encrapera@gianteagle.com
    Requires   : PowerShell V2+  
Documentation can be found in About.txt     
######################################>
#SetExecutionPolicy -Unrestricted

function export_CSV {
    Clear-Host
    $geturl=Invoke-WebRequest http://gecentral/Pages/ViewAllApplications.aspx -UseDefaultCredentials
    Start-Sleep -Seconds 1.5
    $links = ($geturl.Links  <#|Where href -match '\url=http\d+' | where class -NotMatch '+'#>)
    #$links.outertext + $links.href #| Select-Object -First 6 #Need to filter out recents
    $logondomain = whoami
    $username = $logondomain -replace ".*\\"
    $links | Export-Csv "C:\Users\$username\Documents\GitHub\Application-Availability\src\export.csv" 
    #C:\Users\914476\Documents\GitHub\Application-Availability
}

function export_TXT {
    Clear-Host
    $geturl=Invoke-WebRequest http://gecentral/Pages/ViewAllApplications.aspx -UseDefaultCredentials
    $links = ($geturl.Links)
    #$links | export-txt 'C:\Users\914476\Documents\Scripts\URLstatus\GEURLs.txt' 
    $logondomain = whoami
    $username = $logondomain -replace ".*\\"
    $links.href -replace '.*=' -replace 'javascript:;' -replace '#' | out-file -filepath "C:\Users\$username\Documents\GitHub\Application-Availability\src\links.txt" -Force -width 200 #Review -replace on href 
}

export_CSV
export_TXT



