FROM python:3.11-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        git \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd \
        --create-home \
        --shell /bin/bash \
        hermes \
    && mkdir -p \
        /run/sshd \
        /config \
        /workspace \
        /etc/ssh/hostkeys \
    && chown hermes:hermes /workspace

RUN printf '%s\n' \
    'Port 22' \
    'PermitRootLogin no' \
    'PasswordAuthentication no' \
    'KbdInteractiveAuthentication no' \
    'PubkeyAuthentication yes' \
    'AllowUsers hermes' \
    'X11Forwarding no' \
    'AllowTcpForwarding no' \
    'AllowAgentForwarding no' \
    'PermitTunnel no' \
    'HostKey /etc/ssh/hostkeys/ssh_host_ed25519_key' \
    > /etc/ssh/sshd_config.d/hermes.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]