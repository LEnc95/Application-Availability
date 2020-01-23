$keys = "keys.txt"
$webhook = Get-Content $keys -ErrorAction SilentlyContinue 
$x = 0

$Result = @()

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
