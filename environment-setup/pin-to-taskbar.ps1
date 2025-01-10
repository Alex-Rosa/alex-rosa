function New-Shortcut {
    param (
        [string]$TargetPath,
        [string]$ShortcutPath
    )
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetPath
    $Shortcut.Save()
}

# Paths
$TargetPath = "C:\Windows\System32\notepad.exe"
$ShortcutPath = "$env:USERPROFILE\Desktop\notepad.lnk"

# Create shortcut
New-Shortcut -TargetPath $TargetPath -ShortcutPath $ShortcutPath

# Check if the shortcut file exists
if (-Not (Test-Path -Path $ShortcutPath)) {
    Write-Error "Shortcut creation failed. File not found: $ShortcutPath"
    exit 1
}

# Pin to taskbar
$shell = New-Object -ComObject Shell.Application
$folder = $shell.Namespace((Get-Item -Path $env:USERPROFILE\Desktop).FullName)
$shortcut = $folder.ParseName("notepad.lnk")

if ($shortcut -ne $null) {
    $shortcut.InvokeVerb("Pin to taskbar")
} else {
    Write-Error "Unable to find the shortcut to pin: $ShortcutPath"
}
