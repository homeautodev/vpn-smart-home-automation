#!/bin/bash
tar czvf vps_config_backup.tar.gz /etc/wireguard /etc/ufw /etc/systemd/system/wg-monitor* /opt/wg-monitor.sh
