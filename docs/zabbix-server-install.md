# Zabbix 7.2 server installation (Ubuntu 22.04, LAMP)

The project report describes four steps: add the Zabbix 7.2 repository, install the packages (server, frontend, agent, SQL scripts), configure the MySQL database, then start the services and finish setup in the web interface.

> The commands below follow the official Zabbix 7.2 documentation for Ubuntu 22.04 with Apache + MySQL. Check the repository package name and version on the official download page before running them.

```bash
# 1. Repository
wget https://repo.zabbix.com/zabbix/7.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.2-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_7.2-1+ubuntu22.04_all.deb
apt update

# 2. Packages
apt install -y mysql-server zabbix-server-mysql zabbix-frontend-php \
               zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# 3. Database
mysql -uroot -p <<'SQL'
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '<DB_PASSWORD>';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
SQL
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | \
  mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
mysql -uroot -p -e "SET GLOBAL log_bin_trust_function_creators = 0;"

# 4. Server configuration: set DBPassword=<DB_PASSWORD> in /etc/zabbix/zabbix_server.conf

# 5. Start services
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
```

Then open `http://<server-ip>/zabbix` and complete the web installer.

Next steps in this project: [add devices over SNMPv3](../configs/cisco/), [install the agent](../configs/linux/zabbix-agent-install.sh), [enable PDF reports](../configs/zabbix/web-service-install.sh).
