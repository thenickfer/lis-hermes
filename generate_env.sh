#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="$(dirname "$(realpath "$0")")/.env"

read -rp "Runner Host IP: " RUNNER_IP
RUNNER_IP="${RUNNER_IP:-10.50.0.20}"

HERMES_UID="$(id -u)"
HERMES_GID="$(id -g)"

HERMES_MEM_LIMIT="${HERMES_MEM_LIMIT:-4g}"
HERMES_CPUS="${HERMES_CPUS:-2}"

if ! command -v openssl >/dev/null 2>&1; then
    echo "Error: openssl is required."
    exit 1
fi

API_SERVER_KEY="$(openssl rand -hex 32)" 

cat > "$ENV_FILE" <<EOF
RUNNER_IP=$RUNNER_IP

HERMES_UID=$HERMES_UID 
HERMES_GID=$HERMES_GID

HERMES_MEM_LIMIT=$HERMES_MEM_LIMIT
HERMES_CPUS=$HERMES_CPUS

API_SERVER_KEY=$API_SERVER_KEY # AUTO-GENERATED RANDOM HEX KEY
EOF

chmod 600 "$ENV_FILE"

echo "Generated $ENV_FILE"