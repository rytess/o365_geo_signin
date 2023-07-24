<#Get-AzureADAuditDirectoryLogs -Filter "result eq 'success'"
Get-AzureADAuditDirectoryLogs -Filter "result eq 'failure'" -All $true#>



Import-Module AzureADPreview

Connect-AzureAD



$founduserstats = Get-AzureADAuditSignInLogs -Filter "status/errorCode ne 0" | `
Select UserDisplayName, AppDisplayName, IpAddress, Status, DeviceDetail, Location, MfaDetail


$userstats = $userstats + $founduserstats


$userstats | Export-Csv -Path "C:\Users\jramphul\Desktop\signins.csv" -notype