#!/bin/bash

# Stop and disable the service
sudo systemctl stop node_exporter 2>/dev/null || true
sudo systemctl disable node_exporter 2>/dev/null || true

# Check if the systemd service file exists before attempting to remove it
if [ -f /etc/systemd/system/node_exporter.service ]; then
  sudo rm /etc/systemd/system/node_exporter.service
fi

# Check if the binary exists before attempting to remove it
if [ -f /usr/local/bin/node_exporter ]; then
  sudo rm /usr/local/bin/node_exporter
fi

# Reload systemd to apply changes
sudo systemctl daemon-reload
