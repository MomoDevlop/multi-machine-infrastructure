#!/bin/bash
# filepath: e:\IBAM\Virtualisation\test-copilot\multi-machine-infrastructure\scripts\setup_db_master.sh

# Update package list and install MySQL server
sudo apt-get update
sudo apt-get install -y mysql-server

# Configure MySQL for replication and remote access
sudo sed -i "s/^#server-id.*/server-id=1/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#log_bin.*/log_bin=mysql-bin/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#binlog_do_db.*/binlog_do_db=virtualTp/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL service to apply changes
sudo systemctl restart mysql

# Create database and user
mysql -u root <<EOF
CREATE DATABASE virtualTp;
USE virtualTp;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(50)
);
CREATE USER 'momo'@'%' IDENTIFIED BY 'momo1234';
GRANT ALL PRIVILEGES ON virtualTp.* TO 'momo'@'%';
FLUSH PRIVILEGES;
EOF

# Create replication user
mysql -u root <<EOF
CREATE USER 'replica'@'%' IDENTIFIED BY 'replica1234';
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%';
FLUSH PRIVILEGES;
EOF

# Get the master status
MASTER_STATUS=$(mysql -u root -e "SHOW MASTER STATUS\G")
echo "$MASTER_STATUS" > /vagrant/master_status.txt