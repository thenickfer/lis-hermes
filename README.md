# lis-hermes

** This is a simple boilerplate for initializing a version-controlled hermes agent container with remote ssh terminal backends, feel free to fork this repository. This is supposed to be a simple setup, if you had more sophisticated requirements, you probably wouldn't be here.

This setup uses a single Hermes container with multiple profiles. Each profile connects over SSH to its own runner container.

```text
Hermes
├── coder profile    ──SSH──> runner-coder
├── personal profile ──SSH──> runner-personal
└── ...
```

### Create SSH keys

From the Hermes host:

```sh
mkdir -p data/ssh 
chmod 700 data/ssh
```

Generate a key:

```sh
ssh-keygen -t ed25519 \
 -f data/ssh/hermes_ed25519 \
 -N "" \
 -C "hermes"
```

The resulting structure should be:
```
data/ 
└── ssh/ 
    ├── hermes_ed25519 
    └── hermes_ed25519.pub 
```

Keep the private key (*_ed25519) private. They are mounted into the Hermes container.

Copy the public key to the runner machine

```scp data/ssh/hermes_ed25519.pub root@runner:PATH_TO_DIR/lis-hermes/hermes-runner/ssh/authorized_keys```


### Set up the runner
The runner must be configured before setting up Hermes.

On the runner machine:

```sh
cd hermes-runner 
docker compose up -d
```

Verify that the profile containers are running:

```docker compose ps```

For example:
```
runner-coder       0.0.0.0:2201->22/tcp
runner-personal    0.0.0.0:2202->22/tcp
```

Each runner container must:

- have an hermes user;
- have sshd running;
- allow public-key authentication;
- expose SSH through its assigned port;
- provide the /workspace directory.

### Configure hermes
Create the Hermes data directory:
``` mkdir -p data ```

Create an initial environment file with:
``` ./generate_env.sh ```

### Initialize hermes

```sh
docker compose up -d

docker compose exec hermes hermes setup # Initial setup
docker compose exec hermes hermes profile create PROFILE_NAME # Create additional profiles

# Optional but recommended: Enable gateway multiplexing so the gateway serves every profile through one listener
docker compose exec hermes hermes config set gateway.multiplex_profiles true
docker compose restart hermes
# When multiplexing is active, the gateway routes traffic to each profile via a `/p/<profile>/` prefix.

# If you want to disable the default profile:
docker compose exec hermes hermes skills opt-out --remove 
docker compose exec hermes hermes profile use <NEW_DEFAULT_PROFILE> # Makes hermes use the specified profile by default

```


Hermes stores the resulting configuration under:

```text
data/
├── config.yaml
├── .env
├── profiles/
│   └── lisa/
│       ├── config.yaml
│       ├── SOUL.md
│       └── ...
└── ssh/
    └── hermes_ed25519
```

## 5. Configure each profile's SSH backend

Inside `data/profiles/lisa`:

```yaml
terminal:
  backend: ssh
  ssh_host: runner
  ssh_port: 2201
  ssh_user: hermes
  ssh_key: /opt/data/ssh/hermes_ed25519
  cwd: /workspace
```