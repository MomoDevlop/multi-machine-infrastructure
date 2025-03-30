#!/bin/bash
# Update package list and install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Configure Nginx as a Load Balancer
cat <<EOL | sudo tee /etc/nginx/sites-available/load_balancer
upstream backend {
    least_conn;
    server 192.168.56.11;  # web1
    server 192.168.56.12;  # web2
}

server {
    listen 80;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOL

# Enable the Load Balancer configuration
if [ ! -L /etc/nginx/sites-enabled/load_balancer ]; then
    sudo ln -s /etc/nginx/sites-available/load_balancer /etc/nginx/sites-enabled/
fi

# Remove the default Nginx configuration
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Restart Nginx to apply changes
sudo systemctl restart nginx

# Allow HTTP traffic through the firewall
sudo ufw allow 'Nginx Full'