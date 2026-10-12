#!/usr/bin/env bash
# Install and enable the Zabbix 7.2 agent on Ubuntu 24.04 (DMZ web server).
# Run as root. Zabbix server IP in this lab: 12.0.0.2
set -euo pipefail

# 1. Download the Zabbix repository package for Ubuntu 24.04
wget https://repo.zabbix.com/zabbix/7.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.2-1+ubuntu24.04_all.deb

# 2. Install the repository configuration package
dpkg -i zabbix-release_7.2-1+ubuntu24.04_all.deb

# 3. Update and install the agent
apt update
apt install -y zabbix-agent

# 4. Point the agent to the Zabbix server
#    (/etc/zabbix/zabbix_agentd.conf  ->  Server=12.0.0.2)
sed -i 's/^Server=.*/Server=12.0.0.2/' /etc/zabbix/zabbix_agentd.conf

# 5. Start the service and enable it at boot
systemctl restart zabbix-agent
systemctl enable zabbix-agent
systemctl status zabbix-agent --no-pager
