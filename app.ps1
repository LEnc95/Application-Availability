<######################################  
SYNOPSIS  
     Checks availability of URL's
DESCRIPTION 
    Checks URLs from URLList.txt for availability and reports detailed statistics, alerting to a MS Teams channel if the status is an error.  
    Generates a report to report.htm which can be served to a web server.
    Alerts to MS Team via webhooks if error is found.
NOTES  
    File Name  : app.ps1  
    Author     : Luke Encrapera
    Email      : luke.encrapera@gianteagle.com
    Requires   : PowerShell V2+  
Documentation can be found in About.txt     
######################################>
$URLListFile = "URLList.txt"  
$URLList = Get-Content $URLListFile -ErrorAction SilentlyContinue 
  $Result = @() 
$openHTMfile = "report.htm"
$openHTM = Get-Content $openHTMfile -Include $openHTMfile
  Foreach($Uri in $URLList) { 
  $time = try{ 
  $request = $null 
  $result1 = Measure-Command { $request = Invoke-WebRequest -Uri $uri -UseDefaultCredentials} 
  $result1.TotalMilliseconds 
  }  
  catch 
  { 
   $request = $_.Exception.Response 
   $time = -1 
  }   
  $result += [PSCustomObject] @{ 
  Time = Get-Date; 
  Uri = $uri; 
  StatusCode = [int] $request.StatusCode; 
  StatusDescription = $request.StatusDescription; 
  ResponseLength = $request.RawContentLength; 
  TimeTaken =  $time;  
  } 
} 
if($result -ne $null) 
{ 
    $Outputreport = "<HTML>
    <link href='https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO' crossorigin='anonymous'>
    <TITLE>Website Availability Report</TITLE>
        <BODY>
            <H2> Website Availability Report </H2>
            <Table class='table table-striped'>
                <THEAD>
                    <TR class=bg-secondary>
                        <TH scope='col'><B>URL</B></TH>
                        <TH scope='col'><B>StatusCode</B></TH>
                        <TH scope='col'><B>StatusDescription</B></TH>
                        <TH scope='col'><B>ResponseLength</B></TH>
                        <TH scope='col'><B>TimeTaken</B></TH
                    </TR>
                </THEAD>"
    Foreach($Entry in $Result) 
    { 
        if($Entry.StatusCode -ne "200") 
        { 
            $Outputreport += "<TR class=bg-danger>" 
        } 
        else 
        { 
            $Outputreport += "<TR>" 
        } 
        $Outputreport += "
            <TD>$($Entry.uri)</TD>
            <TD>$($Entry.StatusCode)</TD>
            <TD>$($Entry.StatusDescription)</TD>
            <TD>$($Entry.ResponseLength)</TD>
            <TD>$($Entry.timetaken)</TD>
        </TR>"
    } 
    $Outputreport += "</Table></BODY></HTML>" 
} 
### Path can be changed to represent the directory you would like to serve the report from.
$Outputreport | out-file "report.htm" 
### $webhook value can be changed to represent the MS Teams channel you would like to be alearted.
$webhook = 'https://outlook.office.com/webhook/07047aaa-2a8f-44d8-b2d6-bf2f76d6d42a@fe7b0418-5142-4fcf-9440-7a0163adca0d/IncomingWebhook/618b6e4f1956497f955b782c46a5cbb2/d99e4d67-ba3c-4ed5-88dd-8a7c94174b29'
### Need to add support for < 12TPS | Create multiple keys to interate request (12TPS/((export.txt).length)+1))
#$webhookkeys = 'https://outlook.office.com/webhook/07047aaa-2a8f-44d8-b2d6-bf2f76d6d42a@fe7b0418-5142-4fcf-9440-7a0163adca0d/IncomingWebhook/618b6e4f1956497f955b782c46a5cbb2/d99e4d67-ba3c-4ed5-88dd-8a7c94174b29', 
$body = ConvertTo-Json -Depth 4 @{
    title = 'Phone App Availability'
    text = "A test completed @ $uri"
    sections = @(
        @{
            activityTitle = '1 Test Failed'
            activitySubtitle = 'automated availability check'
            activityText = 'A change was evaluated and new results are available.'
            activityImage = 'http://g-shock.monacocorp.co.nz/assets/img/404.png'
        },
        @{
            title = 'Details'
            facts = @(
                @{
                name = 'Status Code'
                value = $Entry.StatusCode
                },
                @{
                name = 'Description'
                value = $Entry.StatusDescription
                }
            )
        }
    )
}
<# Webhook message delivery failed with error: Microsoft Teams endpoint returned HTTP error 429
Foreach($Entry in $Result) 
    { 
        if($Entry.StatusCode -ne "200") 
        { 
          Invoke-RestMethod -uri $webhook -Method Post -body $body -ContentType 'application/json'
        } 
    }
#>
