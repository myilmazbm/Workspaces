$shares = Get-WmiObject -Class Win32_Share | Where-Object { $_.Name -ne 'IPC$' -and $_.Name -ne 'ADMIN$' -and $_.Name -ne 'C$' -and $_.Name -ne 'D$' -and $_.Name -ne 'E$' }

$result = @()

foreach ($share in $shares) {
    $ShareACL = $null
    $NTFSACL = $null
    $objShareSec = Get-WMIObject -Class Win32_LogicalShareSecuritySetting -Filter "name='$($share.Name)'" 
    $SD = $objShareSec.GetSecurityDescriptor().Descriptor
    foreach ($ace in $SD.DACL) {
        $UserName = $ace.Trustee.Name  
        If ($Null -ne $ace.Trustee.Domain) { $UserName = "$($ace.Trustee.Domain)\$UserName" }
        If ($Null -eq $ace.Trustee.Name) { $UserName = $ace.Trustee.SIDString }
        [Array]$ShareACL += New-Object Security.AccessControl.FileSystemAccessRule($UserName, $ace.AccessMask, $ace.AceType)
    }            
    $ACL = Get-Acl -Path $share.Path
    foreach ($access in $ACL.Access) {
        [Array]$NTFSACL += New-Object Security.AccessControl.FileSystemAccessRule($access.IdentityReference, $access.FileSystemRights, $access.InheritanceFlags, $access.PropagationFlags, $access.AccessControlType)
    }

    foreach ($ace in $NTFSACL) {
        $result += [PSCustomObject]@{
            Server = $share.__SERVER
            ShareName = $share.Name
            Path = $share.Path
            Description = $share.Description
            ShareType = $share.Type
            Account = $ace.IdentityReference
            FileSystemRights = $ace.FileSystemRights
            AccessControlType = $ace.AccessControlType
            IsInherited = $ace.IsInherited
            InheritanceFlags = $ace.InheritanceFlags
            PropagationFlags = $ace.PropagationFlags
            SecurityType = 'NTFS'
        }
    }

    foreach ($ace in $ShareACL) {
        $result += [PSCustomObject]@{
            Server = $share.__SERVER
            ShareName = $share.Name
            Path = $share.Path
            Description = $share.Description
            ShareType = $share.Type
            Account = $ace.IdentityReference
            FileSystemRights = $ace.FileSystemRights
            AccessControlType = $ace.AccessControlType
            IsInherited = $ace.IsInherited
            InheritanceFlags = $ace.InheritanceFlags
            PropagationFlags = $ace.PropagationFlags
            SecurityType = 'Share'
        }
    }
}

$result | Format-Table -AutoSize
