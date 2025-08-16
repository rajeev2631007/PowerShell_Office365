# Connect to Exchange Online
Connect-ExchangeOnline -ShowProgress $true

# Get mailbox and email app settings
$mailboxAppSettings = Get-CASMailbox -ResultSize Unlimited | Select-Object `
    DisplayName,
    PrimarySmtpAddress,
    OWAEnabled,
    MAPIEnabled,
    EwsEnabled,
    ActiveSyncEnabled,
    IMAPEnabled,
    POPEnabled,
    SmtpClientAuthenticationDisabled

# Display results in table
$mailboxAppSettings | Format-Table -AutoSize

# If you want to export to CSV, uncomment the line below:
 $mailboxAppSettings | Export-Csv -Path "C:\MailboxAppPermissions.csv" -NoTypeInformation -Encoding UTF8

# Disconnect session
Disconnect-ExchangeOnline -Confirm:$false
