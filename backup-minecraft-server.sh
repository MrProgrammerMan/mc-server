#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/var/lib/minecraft"
DEST="remote:mc-backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
TMP_BACKUP="/tmp/minecraft-backup-$TIMESTAMP.tar.gz"

trap 'systemctl start minecraft-server; rm -f "$TMP_BACKUP"' EXIT

systemctl stop minecraft-server
tar -czf "$TMP_BACKUP" -C "$BACKUP_DIR" .
systemctl start minecraft-server
rclone copy "$TMP_BACKUP" "$DEST"