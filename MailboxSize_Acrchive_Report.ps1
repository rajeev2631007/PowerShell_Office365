# Connect to Exchange Online
Connect-ExchangeOnline -ShowProgress $true

# Collect mailbox data
$results = Get-Mailbox -ResultSize Unlimited | ForEach-Object {
    # Primary mailbox statistics
    $mbStats = Get-MailboxStatistics -Identity $_.UserPrincipalName -ErrorAction SilentlyContinue
    $mailboxSize = if ($mbStats) { $mbStats.TotalItemSize.ToString() } else { "N/A" }

    # Archive mailbox statistics
    $archStats = Get-MailboxStatistics -Archive -Identity $_.UserPrincipalName -ErrorAction SilentlyContinue
    $archiveSize = if ($archStats) { $archStats.TotalItemSize.ToString() } else { "No Archive" }

    # Output object
    [PSCustomObject]@{
        DisplayName          = $_.DisplayName
        UserPrincipalName    = $_.UserPrincipalName
        MailboxSize          = $mailboxSize
        ArchiveTotalItemSize = $archiveSize
    }
}

# Show result in proper table
$results | Select-Object DisplayName, UserPrincipalName, MailboxSize, ArchiveTotalItemSize | Format-Table -AutoSize

# Optional: export to CSV (uncomment if needed)
 $results | Export-Csv -Path "C:\Mailbox_Archive_Report.csv" -NoTypeInformation -Encoding UTF8

# Disconnect session
Disconnect-ExchangeOnline -Confirm:$false
