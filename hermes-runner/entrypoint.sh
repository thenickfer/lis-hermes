#!/bin/sh
set -eu

mkdir -p /run/sshd
mkdir -p /home/hermes/.ssh

chmod 700 /home/hermes/.ssh

if [ ! -f /config/authorized_keys ]; then
    echo "Error: /config/authorized_keys not found" >&2
    exit 1
fi

cp /config/authorized_keys /home/hermes/.ssh/authorized_keys

chmod 600 /home/hermes/.ssh/authorized_keys
chown -R hermes:hermes /home/hermes/.ssh

# Generate host keys if they don't already exist.
ssh-keygen -A

# Validate configuration before starting.
sshd -t

exec /usr/sbin/sshd -D -e