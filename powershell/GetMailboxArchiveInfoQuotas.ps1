$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$Mailboxes = Get-Content "$ReportsLoc\OLMUsers-Sorted.csv"
$report = @()

foreach ($Mailbox in $Mailboxes)
    {
        $mailboxonly = Get-Mailbox $Mailbox
        $mailboxstate = Get-Mailbox $Mailbox | Get-MailboxStatistics
        $mailboxstateA = Get-Mailbox $Mailbox | Get-MailboxStatistics -archive

        $inpObj = New-Object PSObject
        $inpObj | Add-Member -MemberType NoteProperty -Name "Display Name" -Value $mailboxstate.DisplayName 
        $inpObj | Add-Member -MemberType NoteProperty -Name "PrimarySmtpAddress" -Value $mailboxonly.PrimarySmtpAddress
        $inpObj | Add-Member -MemberType NoteProperty -Name "Database" -Value $mailboxstate.Database
        $inpObj | Add-Member -MemberType NoteProperty -Name "MailboxSize" -Value $mailboxstate.totalitemsize
        $inpObj | Add-Member -MemberType NoteProperty -Name "StorageLimitStaus" -Value $mailboxstate.StorageLimitStatus
        $inpObj | Add-Member -MemberType NoteProperty -Name "ProhibitSendQuota" -Value $mailboxonly.ProhibitSendQuota
        $inpObj | Add-Member -MemberType NoteProperty -Name "ArchiveDatabase" -Value $mailboxonly.ArchiveDatabase
        $inpObj | Add-Member -MemberType NoteProperty -Name "ArchiveSize" -Value $mailboxstateA.TotalItemSize
        $inpObj | Add-Member -MemberType NoteProperty -Name "ArchiveQuota" -Value $mailboxonly.ArchiveQuota
        $inpObj | Add-Member -MemberType NoteProperty -Name "ArchiveStorageLimitStaus" -Value $mailboxstateA.StorageLimitStatus
        $report += $inpObj
    }

$report 