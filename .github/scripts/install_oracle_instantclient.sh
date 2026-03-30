#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y wget unzip

# Ubuntu 24 may ship libaio as libaio1t64 only. Instant Client expects libaio.so.1.
if ! sudo apt-get install -y libaio1; then
  sudo apt-get install -y libaio1t64
fi

if [ ! -e /usr/lib/x86_64-linux-gnu/libaio.so.1 ] && [ -e /usr/lib/x86_64-linux-gnu/libaio.so.1t64 ]; then
  sudo ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1
fi

sudo mkdir -p /opt/oracle
wget -q https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-basiclite-linux.x64-21.6.0.0.0dbru.zip -P /tmp
sudo unzip -o /tmp/instantclient-basiclite-linux.x64-21.6.0.0.0dbru.zip -d /opt/oracle
sudo mkdir -p /opt/tns_admin
echo "DISABLE_OOB=ON" | sudo tee /opt/tns_admin/sqlnet.ora > /dev/null
