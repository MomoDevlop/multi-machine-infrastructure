#!/bin/bash
# filepath: e:\IBAM\Virtualisation\test-copilot\multi-machine-infrastructure\scripts\setup_monitoring.sh

# Mettre à jour la liste des paquets
sudo apt-get update

# Installer les dépendances nécessaires
sudo apt-get install -y wget tar libfontconfig1 ufw

# Installer Prometheus
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

# Créer le service systemd pour Prometheus
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

# Démarrer et activer le service Prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Vérifier que Prometheus fonctionne
if systemctl is-active --quiet prometheus; then
  echo "Prometheus est actif."
else
  echo "Erreur : Prometheus ne fonctionne pas." >&2
  exit 1
fi

# Installer Grafana
wget https://dl.grafana.com/oss/release/grafana_7.5.7_amd64.deb
sudo dpkg -i grafana_7.5.7_amd64.deb || sudo apt-get install -f -y

# Démarrer et activer le service Grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Vérifier que Grafana fonctionne
if systemctl is-active --quiet grafana-server; then
  echo "Grafana est actif."
else
  echo "Erreur : Grafana ne fonctionne pas." >&2
  exit 1
fi

# Configurer Prometheus pour surveiller le cluster
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

# Redémarrer Prometheus pour appliquer la nouvelle configuration
sudo systemctl restart prometheus

# Vérifier que Prometheus collecte les métriques
if curl -s http://localhost:9090/targets | grep -q "UP"; then
  echo "Prometheus collecte les métriques avec succès."
else
  echo "Erreur : Prometheus ne collecte pas les métriques." >&2
  exit 1
fi

# Configurer                                                                                                                                                                                                                                                           le pare-feu pour autoriser le trafic HTTP
sudo ufw allow 3000/tcp  # Grafana
sudo ufw allow 9090/tcp  # Prometheus
sudo ufw --force enable
# Vérifier que les ports sont accessibles
if nc -zv localhost 9090 && nc -zv localhost 3000; then
  echo "Les ports 9090 (Prometheus) et 3000 (Grafana) sont accessibles."
else
  echo "Erreur : Les ports 9090 ou 3000 ne sont pas accessibles." >&2
  exit 1
fi