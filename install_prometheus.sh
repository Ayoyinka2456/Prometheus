#!/bin/bash

sudo apt update
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.49.1/prometheus-2.49.1.linux-amd64.tar.gz
sudo tar xvf prometheus-2.49.1.linux-amd64.tar.gz
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
sudo mkdir /var/lib/prometheus
sudo mkdir -p /etc/prometheus/rules
sudo mkdir -p /etc/prometheus/rules.s
sudo mkdir -p /etc/prometheus/files_sd
sudo mv prometheus-2.49.1.linux-amd64/prometheus prometheus-2.49.1.linux-amd64/promtool /usr/local/bin/
sudo mv prometheus-2.49.1.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
sudo tee /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/*
sudo chmod -R 775 /etc/prometheus
sudo chmod -R 775 /etc/prometheus/*
sudo chown -R prometheus:prometheus /var/lib/prometheus/
sudo chmod -R 755 /etc/prometheus/*
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus


# after installing node exporter on the application server we want to monitor,
# then we will come back to the prometheus server

# sudo vi /etc/prometheus/prometheus.yml
# then  append this 
#   - job_name: "appserver"
#     static_configs:
#       - targets: [" ${Private IP of the app server}:9100"]
