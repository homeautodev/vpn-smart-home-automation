#!/bin/bash
ISO_PATH="/backup/debian_backup_$(date +%F_%H-%M).iso"
log="/var/log/backup_to_iso.log"
echo "[INFO] Starting ISO backup..." >> $log
dd if=/dev/sda of=$ISO_PATH bs=4M status=progress
echo "[DONE] Backup saved to $ISO_PATH" >> $log
