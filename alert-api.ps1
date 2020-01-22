$keys = "keys.txt"
$webhook = Get-Content $keys -ErrorAction SilentlyContinue 

$x = 0
Foreach($Entry in $Result) 
{ 
    if($Entry.StatusCode -ne "200") 
        { 
            Invoke-RestMethod -uri $webhook.IndexOf($x) -Method Post -body $body -ContentType 'application/json'
            $x++
            if ($x -eq 11){
            $x=0
        } 
    }
}
<#
catch(HttpOperationException ex) {
if (ex.Response != null && (uint)ex.Response.StatusCode ==  429)
    {
        //Perform retry of the above operation/Action method
    }
}
#>
