# this code simulates is used to move mailboxes with size and department information
# reads the mailbox information from exchange server and then moves the mailboxes to the target database
# reads mailbox database information from the exchange server and then moves the mailboxes to the target database
# also checks the size of the mailbox and the department information before moving the mailbox
# and checks the size of disk space of the target database before moving the mailbox

# Import the Exchange module
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

# Get the list of mailboxes to move
$mailboxes = Get-Mailbox -ResultSize Unlimited
# Get the target databases
$targetDatabases = Get-MailboxDatabase -ResultSize Unlimited | Where-Object { $_.Server -match "25" }

function Get-DepartmentAbbreviation {
    param (
        $user
    )
    if ($user.distinguishedName -match "Altyapi")
    {
        return "BIS"
    }
    else{
        return "BUS"
    }
}

# get disk space information of the target databases from their servers
$targetDatabaseDiskSpace = @{}
foreach ($targetDatabase in $targetDatabases) {
    $server = Get-ExchangeServer -Identity $targetDatabase.Server
    $diskSpace = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server.Name -Filter "DriveType=3" | where-object { $_.DeviceID -eq $targetDatabase.MountedOn } | Select-Object DeviceID, FreeSpace, Size
    $targetDatabaseDiskSpace[$targetDatabase.Identity] = $diskSpace
}

# the scenario is to move mailboxes with size and department information
foreach ($mailbox in $mailboxes) {
    $mailboxSize = (Get-MailboxStatistics -Identity $mailbox.Identity).TotalItemSize.Value.ToBytes()
    #$departmentAbbreviation = Get-DepartmentAbbreviation -user $mailbox
    $targetDatabase = $mailbox.Database | -replace "19", "25"

    if (-not $targetDatabaseDiskSpace[$targetDatabase]){
        $targetDatabase = $targetDatabaseDiskSpace.GetEnumerator() | Where-Object { $_.Key -match (Get-DepartmentAbbreviation -user $_.Value) } | Sort-Object -Property Value.FreeSpace -Descending | Select-Object -First 1 | Select-Object -ExpandProperty Name
    }

    $targetDatabaseDiskSpace[$targetDatabase] = $targetDatabaseDiskSpace[$targetDatabase] - $mailboxSize

    

}
