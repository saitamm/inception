# Inception

A 42 school system administration project that sets up a small WordPress infrastructure entirely with Docker, using custom-built images orchestrated through Docker Compose.

The stack is built from scratch on Debian base images — no pre-built application images from Docker Hub.

## Architecture

Three services run on an isolated bridge network (`wp-network`):

| Service   | Base image | Role                                          | Exposed |
|-----------|------------|-----------------------------------------------|---------|
| **nginx** | debian:12  | TLS termination (HTTPS only, self-signed)     | `443`   |
| **wordpress** | debian:12 | PHP-FPM 8.2 + WordPress + WP-CLI         | internal `9000` |
| **mariadb** | debian:12.4 | Database server                            | internal `3306` |

Persistent data is stored on the host under `~/data/wordpress` and `~/data/mariadb`, mounted into the containers as named volumes.

```
        ┌───────────┐    ┌────────────┐    ┌──────────┐
client ─►│  nginx   │───►│ wordpress  │───►│ mariadb  │
  443    │ (HTTPS)  │    │ (php-fpm)  │    │          │
        └───────────┘    └────────────┘    └──────────┘
                  shared volume: /var/www/html
```

## Project layout

```
.
├── Makefile
└── srcs/
    ├── .env                    # not committed — see below
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/   (Dockerfile + tools/script.sh + maria.conf)
        ├── nginx/     (Dockerfile + tools/nginx.conf)
        └── wordpress/ (Dockerfile + tools/script.sh)
```

## Prerequisites

- Docker Engine and the Docker Compose plugin
- GNU Make
- A hosts entry pointing the configured domain (e.g. `sait-amm.42.fr`) to `127.0.0.1`

## Configuration

Create `srcs/.env` with at least the following variables (referenced by the Compose file, the entrypoint scripts and the Makefile):

```env
# MariaDB
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=change_me

# WordPress → MariaDB
DB_HOST=mariadb
DB_HOST_PORT=3306

# WordPress admin (note: must NOT contain "admin")
ADMIN=siteboss
ADMIN_PASSWORD=change_me
ADMIN_EMAIL=admin@example.com

# Extra WordPress user
USER_WP=visitor
USER_WP_EMAIL=visitor@example.com
USER_WP_PASSWORD=change_me

# Host volume locations (used by the Makefile)
WP_VOLUME_DIR=${HOME}/data/wordpress
MDB_VOLUME_DIR=${HOME}/data/mariadb
```

## Usage

All commands are run from the project root.

```bash
make            # create host volume dirs + build & start the stack (detached)
make up         # same as `make`
make down       # stop and remove containers
make clean      # `down` + remove volumes
make re         # full clean rebuild
make fclean     # prune images/volumes/networks and wipe host data dirs
```

Once running, open: <https://sait-amm.42.fr> (replace with your configured domain). The certificate is self-signed, so your browser will show a warning the first time.

## How it works

- **mariadb** — `mysqld_safe` is started, the database and user defined in `.env` are created on first run (marked by an `Initialization` sentinel file), then the server is restarted in the foreground.
- **wordpress** — waits for MariaDB to accept connections, downloads WordPress via WP-CLI on first boot, generates `wp-config.php`, installs the site, creates an additional user, and finally hands off to `php-fpm8.2 -F`.
- **nginx** — generates a self-signed certificate at build time, serves HTTPS on port 443, and proxies PHP requests to the `wordpress` container on port 9000.

## Notes

- `.env` is intentionally gitignored — never commit credentials.
- The WordPress admin username must not contain the string `admin` (42 subject requirement).
- Host bind paths assume the project is run as a user with a writable `~/data` directory.
