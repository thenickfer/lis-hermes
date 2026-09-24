#!/bin/sh
set -eu

mkdir -p /run/sshd
mkdir -p /home/hermes/.ssh

if [ ! -f /etc/ssh/hostkeys/ssh_host_ed25519_key ]; then
    ssh-keygen \
        -t ed25519 \
        -f /etc/ssh/hostkeys/ssh_host_ed25519_key \
        -N ""
fi

if [ ! -f /config/authorized_keys ]; then
    echo "Error: /config/authorized_keys not found" >&2
    exit 1
fi

cp /config/authorized_keys /home/hermes/.ssh/authorized_keys

chmod 700 /home/hermes/.ssh
chmod 600 /home/hermes/.ssh/authorized_keys
chown -R hermes:hermes /home/hermes/.ssh

sshd -t

exec /usr/sbin/sshd -D -e