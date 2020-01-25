function Show-Menu  {
    param (
        [string]$Title = 'Menu'
    )
    Clear-Host
    Write-Host  "$Title" -ForegroundColor White -BackgroundColor Blue
    Write-Host "[e] Export Reports" -ForegroundColor Green
    Write-Host "[u] Update URL List" -ForegroundColor Green
    Write-Host "[k] Edit Keys" -ForegroundColor Yellow 
    Write-Host "[l] Edit URL" -ForegroundColor Yellow
}
do 
{
    Show-Menu -Title "Application Availability Setup"
    $userInput = Read-Host "Make a selection"
    switch ($userInput) {
        #update keys
        'e' { 

         }
         'u' {

         }
         'k'{

         }
         'l'{

         }
         'q' {
             exit 
         }

        Default {}
    }
    Pause
} 
until ($userInput -eq 'q')
