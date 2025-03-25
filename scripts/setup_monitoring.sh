#!/bin/bash
# filepath: e:\IBAM\Virtualisation\test-copilot\multi-machine-infrastructure\scripts\setup_monitoring.sh

# Update package list
sudo apt-get update

# Install Prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

PROMETHEUS_VERSION="2.26.0"
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
sudo cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-${PROMETHEUS_VERSION}.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-${PROMETHEUS_VERSION}.linux-amd64/console_libraries /etc/prometheus
sudo cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Create Prometheus service
cat <<EOL | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/

[Install]
WantedBy=multi-user.target
EOL

# Start Prometheus service
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Install Grafana
wget https://dl.grafana.com/oss/release/grafana_7.5.7_amd64.deb
sudo dpkg -i grafana_7.5.7_amd64.deb

# Start Grafana service
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Configure Prometheus to monitor the cluster
cat <<EOL | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'nodes'
    static_configs:
      - targets: ['192.168.56.10:9100', '192.168.56.11:9100', '192.168.56.12:9100', '192.168.56.13:9100', '192.168.56.14:9100', '192.168.56.15:9100', '192.168.56.16:9100']
EOL

# Restart Prometheus to apply the new configuration
sudo systemctl restart prometheus

# Allow HTTP traffic through the firewall
sudo ufw allow 3000/tcp  # Grafana
sudo ufw allow 9090/tcp  # Prometheus