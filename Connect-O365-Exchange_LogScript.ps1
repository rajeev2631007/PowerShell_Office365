<#
.SYNOPSIS
    Connects to Office 365 Exchange Online using the latest ExchangeOnlineManagement v3.9
    and Microsoft Graph for modern authentication.

.NOTES
    Author: Rajeev Gautam (adjusted for modern auth)
    Requires:
        - ExchangeOnlineManagement module v3.9+
        - Microsoft.Graph module
#>

# -------------------------------
# 1. PRE-CHECK & MODULE IMPORT
# -------------------------------

Write-Host "Checking required modules..." -ForegroundColor Cyan

# ExchangeOnlineManagement
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "Installing ExchangeOnlineManagement module..." -ForegroundColor Yellow
    Install-Module ExchangeOnlineManagement -Scope AllUsers -Force
}

# Microsoft Graph
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Installing Microsoft Graph module..." -ForegroundColor Yellow
    Install-Module Microsoft.Graph -Scope AllUsers -Force
}

Import-Module ExchangeOnlineManagement
Import-Module Microsoft.Graph

# -------------------------------
# 2. LOGIN TO MICROSOFT GRAPH
# -------------------------------
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "Mail.ReadWrite","Directory.Read.All","User.Read.All","MailboxSettings.ReadWrite"

# Verify Graph Connection
$graphUser = Get-MgUser -UserId (Get-MgContext).Account
Write-Host "Logged in as:" $graphUser.DisplayName -ForegroundColor Green

# -------------------------------
# 3. CONNECT TO EXCHANGE ONLINE
# -------------------------------
Write-Host "Connecting to Exchange Online..." -ForegroundColor Cyan
Connect-ExchangeOnline -UserPrincipalName $graphUser.UserPrincipalName -ShowProgress $true

Write-Host "✅ Connected to Exchange Online successfully." -ForegroundColor Green

# -------------------------------
# 4. OPTIONAL - TEST COMMAND
# -------------------------------
# Example: List first 10 mailboxes
Write-Host "Fetching sample mailboxes..." -ForegroundColor Cyan
Get-EXOMailbox -ResultSize 10 | Format-Table DisplayName,PrimarySmtpAddress

# -------------------------------
# 5. CLEAN UP / DISCONNECT
# -------------------------------
# When done, you can run:
# Disconnect-ExchangeOnline -Confirm:$false
# Disconnect-MgGraph
