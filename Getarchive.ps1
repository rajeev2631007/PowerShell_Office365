# Connect to Exchange Online
Connect-ExchangeOnline -ShowProgress $true

# Get Archive details
$results = Get-Mailbox -ResultSize Unlimited | ForEach-Object {
    $stats = Get-MailboxStatistics -Archive -Identity $_.UserPrincipalName -ErrorAction SilentlyContinue

    $sizeText  = "No Archive"
    $itemCount = 0
    $sizeBytes = 0

    if ($stats) {
        $sizeText = $stats.TotalItemSize.ToString()
        $itemCount = $stats.ItemCount

        if ($sizeText -match '\((\d+)\sbytes\)') {
            $sizeBytes = [int64]$matches[1]
        }
    }

    [PSCustomObject]@{
        DisplayName          = $_.DisplayName
        UserPrincipalName    = $_.UserPrincipalName
        ArchiveStatus        = $_.ArchiveStatus
        ArchiveTotalItemSize = $sizeText
    }
} | Sort-Object ArchiveTotalBytes -Descending

# Display as table
$results | Format-Table -AutoSize

# If you want to export to CSV, uncomment this:
 $results | Export-Csv -Path "C:\MailboxArchiveReport.csv" -NoTypeInformation -Encoding UTF8

# Disconnect session
Disconnect-ExchangeOnline -Confirm:$false

