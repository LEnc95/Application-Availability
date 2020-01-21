#SetExecutionPolicy -Unrestricted

function export_CSV {
    Clear-Host
    $geturl=Invoke-WebRequest http://gecentral/Pages/ViewAllApplications.aspx -UseDefaultCredentials
    Start-Sleep -Seconds 1.5
    $links = ($geturl.Links <#|Where href -match '\url=http\d+' | where class -NotMatch '+'#>)
    #$links.outertext + $links.href #| Select-Object -First 6 #Need to filter out recents
    $links | Export-Csv 'C:\Users\914476\Documents\Scripts\URLstatus\GE_Links.csv' 
}

function export_TXT {
    Clear-Host
    $geturl=Invoke-WebRequest http://gecentral/Pages/ViewAllApplications.aspx -UseDefaultCredentials
    $links = ($geturl.Links)
    #$links | export-txt 'C:\Users\914476\Documents\Scripts\URLstatus\GEURLs.txt' 
    $links.href | out-file -filepath C:\Users\914476\Documents\Scripts\URLstatus\GEURLs.txt -append -width 200
}

function check_status {
    #for($link in $links){
    #}
    $uri = http://gecentral/Pages/ViewAllApplications.aspx
    $site = Invoke-WebRequest -Uri $uri -UseDefaultCredentials
    $results = $site.statusCode
    $results
}

export_CSV
export_TXT
check_status