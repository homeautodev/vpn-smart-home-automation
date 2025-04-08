#!/bin/bash
LOG_FILE="/var/log/wg-monitor.log"
if ! ping -c 1 -I wg0 192.168.178.1 &> /dev/null; then
    echo "$(date) - No response, restarting WireGuard" >> $LOG_FILE
    systemctl restart wg-quick@wg0
else
    echo "$(date) - VPN OK" >> $LOG_FILE
fi
