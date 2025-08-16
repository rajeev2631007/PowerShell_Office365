<#
.SYNOPSIS
    Lightweight PowerShell ISE script to connect to Exchange Online and Microsoft Graph
    using modern authentication.
#>

# -------------------------------
# 1. Import required modules
# -------------------------------
Import-Module ExchangeOnlineManagement
Import-Module Microsoft.Graph

# -------------------------------
# 2. Connect to Microsoft Graph
# -------------------------------
Connect-MgGraph -Scopes "Mail.ReadWrite","Directory.Read.All","User.Read.All","MailboxSettings.ReadWrite"

# Optional: verify connection
$graphUser = Get-MgUser -UserId (Get-MgContext).Account
Write-Host "Logged in as:" $graphUser.DisplayName -ForegroundColor Green

# -------------------------------
# 3. Connect to Exchange Online
# -------------------------------
Connect-ExchangeOnline -UserPrincipalName $graphUser.UserPrincipalName -ShowProgress $true

Write-Host "✅ Connected to Exchange Online successfully." -ForegroundColor Green

# -------------------------------
# 4. Quick test command (optional)
# -------------------------------
# List first 10 mailboxes
Get-EXOMailbox -ResultSize 10 | Format-Table DisplayName,PrimarySmtpAddress


