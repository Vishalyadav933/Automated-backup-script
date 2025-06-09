# ===========================
# 🔄 Automated Backup Script
# ===========================

# ======= CONFIGURATION =======
$ProjectName = "MyProject"
$ProjectDir = "C:\Users\Deadpool\backups\MyProject"  # Folder to backup
$BackupDir = "$HOME\backups\$ProjectName"
$KeepDaily = 7
$WebhookUrl = "https://webhook.site/970de43b-663a-4263-b930-053763d896b6"  # Your webhook
$SendNotification = $false  # Set $true to enable webhook notifications
$RclonePath = "gdrive:$ProjectName"  # rclone remote path (e.g., gdrive:MyProject)
# ==============================

# Create backup directory if it doesn't exist
if (-not (Test-Path -Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

# Generate timestamp and zip filename
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$ZipName = "$ProjectName" + "_" + $Timestamp + ".zip"
$ZipPath = Join-Path $BackupDir $ZipName

# Compress the project directory into a zip
Compress-Archive -Path $ProjectDir -DestinationPath $ZipPath -Force

# Remove old backups, keep only $KeepDaily most recent backups
$Backups = Get-ChildItem -Path $BackupDir -Filter "*.zip" | Sort-Object LastWriteTime -Descending
if ($Backups.Count -gt $KeepDaily) {
    $BackupsToRemove = $Backups[$KeepDaily..($Backups.Count - 1)]
    foreach ($backup in $BackupsToRemove) {
        Remove-Item -Path $backup.FullName -Force
    }
}

# Upload to Google Drive using rclone
Write-Host "☁️ Uploading $ZipName to Google Drive..."
rclone copyto $ZipPath "$RclonePath/$ZipName" --quiet

# Send webhook notification if enabled
if ($SendNotification -and $WebhookUrl) {
    $body = @{
        project = $ProjectName
        date = $Timestamp
        status = "BackupSuccessful"
    } | ConvertTo-Json

    Invoke-RestMethod -Uri $WebhookUrl -Method Post -ContentType "application/json" -Body $body
}

# Final status message
Write-Host "✅ Backup Completed: $ZipPath"

