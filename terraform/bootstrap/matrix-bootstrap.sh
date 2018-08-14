#!/usr/bin/env bash
set -e
echo "applying custom synapse homeserver configuration"
mkdir -p /etc/matrix-synapse/conf.d/
cp /tmp/bootstrap/homeserver.yaml /etc/matrix-synapse/conf.d/homeserver.yaml
systemctl restart matrix-synapse
