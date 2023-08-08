
$AllSiginLogs = Get-AzureADAuditSignInLogs -All $true
$role = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Global Administrator'}
$admins = @(Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | select DisplayName, UserPrincipalName)

$results = @()
Foreach ($admin in $admins){

    $LoginRecord = $AllSiginLogs | Where-Object{ $_.UserId -eq $admin.ObjectId  } | Sort-Object CreatedDateTime -Descending
    if($LoginRecord.Count -gt 0){
        $lastLogin = $LoginRecord[0].CreatedDateTime
    }else{
        $lastLogin = 'no login record'
    }
    $item = @{
        userUPN=$admin.UserPrincipalName
        userDisplayName = $admin.DisplayName
        lastLogin = $lastLogin
        accountEnabled = $admin.AccountEnabled
    }
    $results += New-Object PSObject -Property $item  

    Write-Output $results
    
}
$results | export-csv -Path d:\result.csv -NoTypeInformation 





update


$role = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Global Administrator'}
$admins = @(Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | select DisplayName, UserPrincipalName)

$results = @()
Foreach ($admin in $admins){
     $upn = $admin.UserPrincipalName


      $LoginRecord = Get-AzureADAuditSignInLogs -Filter "UserPrincipalName eq '$upn'" -Top 1
      Start-Sleep -Seconds 2
      if($LoginRecord.Count -gt 0){
          $lastLogin = $LoginRecord.CreatedDateTime
          }
          else{
          $lastLogin = 'no login record'
         }
        $item = @{
            userUPN=$admin.UserPrincipalName
            userDisplayName = $admin.DisplayName
            lastLogin = $lastLogin
           
         }

       
       $results += New-Object PSObject -Property $item
      
  }

$results | export-csv -Path c:\result.csv -NoTypeInformation -Encoding UTF8 









$SetDate = (Get-Date).AddDays(-30);
$SetDate = Get-Date($SetDate) -format yyyy-MM-dd
$array = Get-AzureADAuditSignInLogs -Filter "createdDateTime gt $SetDate" | select userDisplayName, userPrincipalName, appDisplayName, ipAddress, clientAppUsed, @{Name = 'DeviceOS'; Expression = {$_.DeviceDetail.OperatingSystem}},@{Name = 'Location'; Expression = {$_.Location.City}}
$array | Export-Csv "C:\PS\AzureUserSigninLogs.csv" –NoTypeInformation 



# Fetches the last month's Azure Active Directory sign-in data
CLS; $StartDate = (Get-Date).AddDays(-30); $StartDate = Get-Date($StartDate) -format yyyy-MM-dd
Write-Host "Fetching data from Azure Active Directory..."
$Records = Get-AzureADAuditSignInLogs -Filter "createdDateTime gt $StartDate" -all:$True
$Report = [System.Collections.Generic.List[Object]]::new()
ForEach ($Rec in $Records) {
    Switch ($Rec.Status.ErrorCode) {
      "0" {$Status = "Success"}
      default {$Status = $Rec.Status.FailureReason}
    }
    $ReportLine = [PSCustomObject] @{
           TimeStamp   = Get-Date($Rec.CreatedDateTime) -format g
           User        = $Rec.UserPrincipalName
           Name        = $Rec.UserDisplayName
           IPAddress   = $Rec.IpAddress
           ClientApp   = $Rec.ClientAppUsed
           Device      = $Rec.DeviceDetail.OperatingSystem
           Location    = $Rec.Location.City + ", " + $Rec.Location.State + ", " + $Rec.Location.CountryOrRegion
           Appname     = $Rec.AppDisplayName
           Resource    = $Rec.ResourceDisplayName
           Status      = $Status
           Correlation = $Rec.CorrelationId
           Interactive = $Rec.IsInteractive }
      $Report.Add($ReportLine) }
Write-Host $Report.Count "sign-in audit records processed."








$Report | Group Location|Sort Count -Descending | Format-Table Count, Name

300 Togrenda, Akershus, NO

200 Washington, Virginia, US

167 Kleinpestitz/Mockritz, Sachsen, DE

89  Oxford, Oxfordshire, GB

70  Sofiya, Sofiya-Grad, BG

#Obtains sign-in records from Washington
Get-AzureADAuditSignInLogs -Filter "location/city eq 'Virginia' and location/state eq 'Washington' and location/countryOrRegion eq 'US'"



