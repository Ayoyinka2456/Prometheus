#!/bin/bash

sudo apt update
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
sudo mkdir /var/lib/node
sudo tar xvf node_exporter-1.7.0.linux-amd64.tar.gz
cd node_exporter-1.7.0.linux-amd64/
sudo mv node_exporter /var/lib/node
sudo tee /etc/systemd/system/node.service<<EOF
[Unit]
Description=Prometheus Node Exporter
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/var/lib/node/node_exporter

SyslogIdentifier=prometheus_node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo chown -R prometheus:prometheus /var/lib/node
sudo chown -R prometheus:prometheus /var/lib/node/*
sudo chmod -R 775 /var/lib/node
sudo chmod -R 775 /var/lib/node/*
sudo systemctl daemon-reload
sudo systemctl enable node
sudo systemctl start node
sudo systemctl status node
curl ifconfig.io

