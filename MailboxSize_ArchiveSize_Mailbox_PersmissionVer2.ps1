# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName rajeev.gautam@mahajan.co.in

# Get all mailboxes including shared
$mailboxes = Get-Mailbox -ResultSize Unlimited -RecipientTypeDetails UserMailbox,SharedMailbox

$report = foreach ($mbx in $mailboxes) {
    try {
        # Use UPN to avoid ambiguity
        $upn = $mbx.UserPrincipalName

        # Mailbox statistics
        $mbxStats     = Get-MailboxStatistics -Identity $upn -ErrorAction Stop
        $archiveStats = Get-MailboxStatistics -Identity $upn -Archive -ErrorAction SilentlyContinue

        # Mailbox permissions (Full Access)
        $permissions = Get-MailboxPermission -Identity $upn -ErrorAction SilentlyContinue | 
                       Where-Object {($_.User -notlike "NT AUTHORITY\SELF") -and ($_.IsInherited -eq $false)} |
                       Select-Object -ExpandProperty User -Unique
        $permissionsString = if ($permissions) { $permissions -join "; " } else { "" }

        # Retention Policy
        $retentionPolicy = $mbx.RetentionPolicy

        # Mailbox Plan
        $mailboxPlan = $mbx.MailboxPlan

        # Role Assignment Policy
        $roleAssignmentPolicy = $mbx.RoleAssignmentPolicy

        [PSCustomObject]@{
            DisplayName          = $mbx.DisplayName
            UserPrincipalName    = $upn
            MailboxSize          = $mbxStats.TotalItemSize.Value.ToString()
            ArchiveTotalSize     = if ($archiveStats) { $archiveStats.TotalItemSize.Value.ToString() } else { "No Archive" }
            RetentionPolicy      = $retentionPolicy
            MailboxPlan          = $mailboxPlan
            RoleAssignmentPolicy = $roleAssignmentPolicy
            Permissions          = $permissionsString
        }
    }
    catch {
        Write-Warning "Skipping $($mbx.DisplayName) ($upn): $($_.Exception.Message)"
    }
}

# Export to CSV
$report | Export-Csv "c:\MailboxSize_ArchiveSize_MailboxPermission_Report.csv" -NoTypeInformation -Encoding UTF8

Write-Host "Report generated successfully: c:\MailboxSize_ArchiveSize_MailboxPermission_Report.csv"
