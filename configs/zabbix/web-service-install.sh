#!/usr/bin/env bash
# Scheduled PDF reports in Zabbix 7.2 need Zabbix Web Service + headless Google Chrome.
# Run as root on the Zabbix server (Ubuntu).
set -euo pipefail

# 1. Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# 2. Zabbix Web Service
apt install -y zabbix-web-service

# 3. Enable report writers in /etc/zabbix/zabbix_server.conf (see zabbix_server.conf.snippet),
#    then restart:  systemctl restart zabbix-server zabbix-web-service
#
# 4. In the web UI: Administration > General > Other
#      Frontend URL = http://12.0.0.2/zabbix
