#!/bin/bash

# Check if node_exporter is already installed and running
if pgrep -x "node_exporter" > /dev/null; then
    echo "Node Exporter is already running. No need to install."
    exit 0
fi

# Create the node_exporter user if it doesn't exist
id -u node_exporter &>/dev/null || sudo useradd --system --shell /bin/false node_exporter

# Install package
sudo cp node_exporter /usr/local/bin/
sudo chmod +x /usr/local/bin/node_exporter
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Add service
sudo tee /etc/systemd/system/node_exporter.service <<"EOF"
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
Group=node_exporter
Environment=OPTIONS=
EnvironmentFile=-/etc/sysconfig/node_exporter
ExecStart=/usr/local/bin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
EOF

# Enable and run service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter
