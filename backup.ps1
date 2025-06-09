# Backup Script for MyProject

# ======= CONFIGURATION =======
$ProjectName = "MyProject"
$ProjectDir = "C:\Users\Deadpool\backups\MyProject"  # my folder path
$BackupDir = "$HOME\backups\$ProjectName"
$KeepDaily = 7
$WebhookUrl = "https://webhook.site/970de43b-663a-4263-b930-053763d896b6" # my webhook url
$SendNotification = $false # Change to $true if you want to send webhook notifications
# ==============================

# Create backup directory if not exists
if (-not (Test-Path -Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

# Generate timestamp and zip filename
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$ZipName = "$ProjectName" + "_" + $Timestamp + ".zip"
$ZipPath = Join-Path $BackupDir $ZipName

# Compress the project directory into zip
Compress-Archive -Path $ProjectDir -DestinationPath $ZipPath -Force

# Remove old backups, keep only $KeepDaily most recent backups
$Backups = Get-ChildItem -Path $BackupDir -Filter "*.zip" | Sort-Object LastWriteTime -Descending
if ($Backups.Count -gt $KeepDaily) {
    $BackupsToRemove = $Backups[$KeepDaily..($Backups.Count - 1)]
    foreach ($backup in $BackupsToRemove) {
        Remove-Item -Path $backup.FullName -Force
    }
}

# Send notification if enabled
if ($SendNotification -and $WebhookUrl) {
    $body = @{
        project = $ProjectName
        date = $Timestamp
        status = "BackupSuccessful"
    } | ConvertTo-Json

    Invoke-RestMethod -Uri $WebhookUrl -Method Post -ContentType "application/json" -Body $body
}

Write-Host "✅ Backup Completed: $ZipPath"
