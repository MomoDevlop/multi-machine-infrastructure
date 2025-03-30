#!/bin/bash

# Update package list and install MySQL server
sudo apt-get update
sudo apt-get install -y mysql-server

# Ensure necessary directories exist
sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld

# Configure MySQL for replication and remote access
sudo sed -i "s/^#server-id.*/server-id=1/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#log_bin.*/log_bin=mysql-bin/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#binlog_do_db.*/binlog_do_db=virtualTp/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL service to apply changes
sudo systemctl restart mysql

# Check if MySQL service is running
if ! sudo systemctl is-active --quiet mysql; then
  echo "MySQL service failed to start. Check the logs for details."
  exit 1
fi

# Create the database and user for replication
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS virtualTp;
CREATE USER IF NOT EXISTS 'replica'@'192.168.56.14' IDENTIFIED WITH mysql_native_password BY 'replica1234';
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'192.168.56.14';
FLUSH PRIVILEGES;
EOF

# Lock the database and retrieve the master status
MASTER_STATUS=$(mysql -u root <<EOF
FLUSH TABLES WITH READ LOCK;
SHOW MASTER STATUS\G
EOF
)

# Save the master status to a shared file
echo "$MASTER_STATUS" > /vagrant/master_status.txt

# Create a database snapshot using mysqldump
sudo mysqldump -u root virtualTp > /vagrant/virtualTp.sql

# Unlock the database
mysql -u root <<EOF
UNLOCK TABLES;
EOF