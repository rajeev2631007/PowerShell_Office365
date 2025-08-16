###########################################################################################################
# Script to export Distribution Group Members in Office 365 using Cloud Shell
# Compatible with PowerShell Core in Azure Cloud Shell
###########################################################################################################

# Output file in Cloud Shell home directory
$OutputFile = "$HOME/DistributionGroupMembers.csv"

# Prepare CSV header
"Distribution Group DisplayName,Distribution Group Email,Member DisplayName,Member Email,Member Type" | Out-File -FilePath $OutputFile -Encoding UTF8

# Connect to Exchange Online (uses authenticated Cloud Shell context)
Connect-ExchangeOnline

# Get all Distribution Groups
$distributionGroups = Get-DistributionGroup -ResultSize Unlimited

# Loop through each group and export members
foreach ($group in $distributionGroups) {
    Write-Host "Processing group: $($group.DisplayName)"
    $members = Get-DistributionGroupMember -Identity $group.PrimarySmtpAddress

    foreach ($member in $members) {
        "$($group.DisplayName),$($group.PrimarySmtpAddress),$($member.DisplayName),$($member.PrimarySmtpAddress),$($member.RecipientType)" | Out-File -FilePath $OutputFile -Encoding UTF8 -Append
    }
}

Write-Host "`n✅ Export complete. File saved to: $OutputFile"
