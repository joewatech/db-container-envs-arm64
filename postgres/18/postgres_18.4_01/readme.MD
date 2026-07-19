# postgres_18.4_01

Docker Compose setup for a local Postgres 18.4 container.

## Usage

1. Create a `.env` file in this directory with `POSTGRES_USER_SU`, `POSTGRES_USER_SU_PWD`, `POSTGRES_DB`, `POSTGRES_LOCAL_PORT`, and `POSTGRES_LOCAL_DATA_VOL` (see `docker-compose.yaml` for how each is used). `.env` is gitignored and never committed.
2. Run `docker compose up -d` from this directory.

Postgres data is bind-mounted from `./postgresql` on the host into `/var/lib/postgresql` in the container. That local `postgresql/` directory is gitignored (its contents are live database files), but a `.gitkeep` placeholder is committed so the empty directory still exists after cloning the repo.

## Cloning to a new machine

After `git clone`, before your first `docker compose up`, be aware of one thing:

**File permissions on the bind-mounted data directory.** Postgres runs as UID 999 inside the container and needs write access to `./postgresql`. A fresh clone normally gives you a normal user-owned directory, which is usually fine — but if the container fails to start or errors out on first run, check permissions on `./postgresql` first. This is unrelated to the `.gitkeep` file, which Postgres's entrypoint script ignores since it lives outside the actual data directory it initializes (`postgresql/18/docker/`).
