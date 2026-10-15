# Docker environment

Local MongoDB replica set and ActiveMQ broker via Docker Compose.

## Files

* `docker-compose.yml`: the MongoDB and ActiveMQ services.
* `scripts/config-mongo-db-container.sh`: configures the MongoDB replica set inside the container (run by Compose).
* `.env`: Compose variables (`COMPOSE_PROJECT_NAME`).
* `start-docker.ps1`: restarts the environment.

## `start-docker.ps1`

Runs at login (`startup_apps`, "Docker Compose"). It waits up to `-WaitSeconds` (default 300) for the
Docker engine, because Docker Desktop is still starting at login. Then it runs `docker compose down`
and `docker compose up --build -d`.

```powershell
.\start-docker.ps1              # keep data
.\start-docker.ps1 -ResetData   # also delete volumes (DATA IS LOST)
```

## Services

* **MongoDB**: replica set with three nodes on ports `27017`, `27018` and `27019`.
* **ActiveMQ**: ports `8161` (web console), `61616` (TCP) and `5672` (AMQP).
