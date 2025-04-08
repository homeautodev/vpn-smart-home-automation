#!/bin/bash
tar xzvf vps_config_backup.tar.gz -C /
systemctl daemon-reexec
