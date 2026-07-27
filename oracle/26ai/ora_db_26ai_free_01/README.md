# ora_db_26ai_free_01

Docker Compose setup for a local Oracle Database 26ai Free container.

## Usage

1. Create a `.env` file in this directory with `ORACLE_PDB_SID_PWD`, `ORACLE_PDB_LOCAL_PORT`, `ORACLE_PDB_LOCAL_OEM_PORT`, and `ORACLE_PDB` (see `.env.example` and `compose.yaml` for how each is used). `.env` is gitignored and never committed.
2. Copy `scripts/setup/02-create-oracle-sample-pdb.sql.example` to `scripts/setup/02-create-oracle-sample-pdb.sql` in the same directory, then replace `<CHANGE_ME_PASSWORD>` with a real password. This file creates the `ORACLE_SAMPLE` user/schema and is gitignored (it holds a real password), which is why only the `.example` template is committed.
3. Run `docker compose up -d` from this directory.

Oracle data is bind-mounted from `./oradata` on the host into `/opt/oracle/oradata` in the container. That local `oradata/` directory is gitignored (its contents are live database files), but a `.gitkeep` placeholder is committed so the empty directory still exists after cloning the repo.

The `scripts/setup` and `scripts/startup` directories are bind-mounted into the container's `/opt/oracle/scripts/setup` and `/opt/oracle/scripts/startup`. The Oracle image runs the `.sql` files there (in filename order) on first startup / on every startup, respectively.
