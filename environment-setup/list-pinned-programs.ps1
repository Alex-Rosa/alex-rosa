# Registry path for taskbar settings
$RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband'

# Get the pinned items
$PinnedItems = (Get-ItemProperty -Path $RegPath).PinnedItems

# Display the pinned items
Write-Output "Pinned Programs"
foreach ($Item in $PinnedItems) {

	Write-Output $Item
}
