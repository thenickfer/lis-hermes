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
    && mkdir -p /run/sshd /config /workspace \
    && chown hermes:hermes /workspace \
    && printf '%s\n' \
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
        > /etc/ssh/sshd_config.d/hermes.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]