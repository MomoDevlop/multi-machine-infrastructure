#!/bin/bash

# Update package list and install MySQL server
sudo apt-get update
sudo apt-get install -y mysql-server

# Ensure necessary directories exist
sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld

# Configure MySQL for replication and remote access
sudo sed -i "s/^#server-id.*/server-id=2/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#relay-log.*/relay-log=mysql-relay-bin/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#binlog_do_db.*/binlog_do_db=virtualTp/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL service to apply changes
sudo systemctl restart mysql

# Check if MySQL service is running
if ! sudo systemctl is-active --quiet mysql; then
  echo "MySQL service failed to start. Check the logs for details."
  exit 1
fi

# Import the database snapshot
mysql -u root -e "CREATE DATABASE IF NOT EXISTS virtualTp;"
mysql -u root virtualTp < /vagrant/virtualTp.sql

# Get master status from shared file
MASTER_LOG_FILE=$(grep 'File:' /vagrant/master_status.txt | awk '{print $2}')
MASTER_LOG_POS=$(grep 'Position:' /vagrant/master_status.txt | awk '{print $2}')

# Configure the slave to replicate from the master
mysql -u root <<EOF
STOP SLAVE;
CHANGE MASTER TO
    MASTER_HOST='192.168.56.13',
    MASTER_USER='replica',
    MASTER_PASSWORD='replica1234',
    MASTER_LOG_FILE='$MASTER_LOG_FILE',
    MASTER_LOG_POS=$MASTER_LOG_POS;
START SLAVE;
EOF

# Verify replication status
mysql -u root -e "SHOW SLAVE STATUS\G" | grep -E "Slave_IO_Running|Slave_SQL_Running"