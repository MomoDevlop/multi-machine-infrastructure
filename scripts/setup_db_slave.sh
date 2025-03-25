#!/bin/bash
# filepath: e:\IBAM\Virtualisation\test-copilot\multi-machine-infrastructure\scripts\setup_db_slave.sh

# Update package list and install MySQL server
sudo apt-get update
sudo apt-get install -y mysql-server

# Configure MySQL for replication and remote access
sudo sed -i "s/^#server-id.*/server-id=2/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#relay-log.*/relay-log=mysql-relay-bin/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#binlog_do_db.*/binlog_do_db=virtualTp/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL service to apply changes
sudo systemctl restart mysql

# Get master status from shared file
MASTER_LOG_FILE=$(grep 'File:' /vagrant/master_status.txt | awk '{print $2}')
MASTER_LOG_POS=$(grep 'Position:' /vagrant/master_status.txt | awk '{print $2}')

# Stop slave IO thread
mysql -u root <<EOF
STOP SLAVE IO_THREAD;
CHANGE MASTER TO MASTER_HOST='192.168.56.13', MASTER_USER='replica', MASTER_PASSWORD='replica1234', MASTER_LOG_FILE='$MASTER_LOG_FILE', MASTER_LOG_POS=$MASTER_LOG_POS;
START SLAVE;
EOF
