# Automated Backup Script

**Author:** Vishal Yadav  
**Email:** devops.vishal8227@gmail.com  
**Phone:** 7841048227

---

## Project Overview

This PowerShell backup script automates the process of compressing a project folder, uploading the backup to Google Drive using `rclone`, maintaining a rotational backup strategy by keeping only a specified number of recent backups, and optionally sending a webhook notification upon successful backup.

---

## Features

- Compress project directory into a timestamped ZIP archive
- Upload backup to Google Drive using `rclone`
- Retain only the last *N* backups (configurable)
- Optional webhook notification on success
- Configurable project folder path, backup folder, and retention count
- Safe deletion of old backups
- Option to enable/disable webhook notifications for testing

---

## Configuration

Edit the script variables to customize:

- `$ProjectName`: Name of your project
- `$ProjectDir`: Full path of the folder to backup
- `$BackupDir`: Where backups will be stored locally
- `$KeepDaily`: Number of backups to retain
- `$WebhookUrl`: URL for webhook notifications
- `$SendNotification`: `$true` or `$false` to enable/disable webhook

---

## Prerequisites

- PowerShell 5.1 or later
- `rclone` installed and configured with your Google Drive account
- Internet connection for uploading backups and sending notifications

---

## How to Use

1. Configure the script variables as needed.
2. Run the script manually or schedule it using Windows Task Scheduler.
3. The script will create a zipped backup, upload it to Google Drive, rotate old backups, and optionally send a notification.

---

## Rotational Backup Strategy

The script keeps only the most recent `$KeepDaily` backups. Older backups beyond this count are securely deleted from the local backup folder, ensuring efficient storage use.

Example:  
If `$KeepDaily = 7`, only the latest 7 backup ZIP files will be kept, older files will be removed automatically.

---

## Google Drive Upload via `rclone`

The script uses the `rclone` CLI tool to push the backups to your configured Google Drive remote. Ensure `rclone` is installed and authenticated properly before running the script.

---

## Webhook Notification

To enable webhook notifications, set `$SendNotification = $true` and configure your `$WebhookUrl`. The script sends a JSON payload with the project name, timestamp, and backup status upon success.

---

## Contact

If you have any questions or need help, please contact:  
**Vishal Yadav**  
Email: devops.vishal8227@gmail.com  
Phone: 7841048227

---

Thank you for using this backup automation script!
