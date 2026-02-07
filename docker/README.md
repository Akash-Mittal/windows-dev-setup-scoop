# Docker Environment Setup

This folder contains the necessary files to set up a local development environment using Docker Compose. The environment includes a MongoDB replica set and an ActiveMQ broker.

## Files

*   `docker-compose.yml`: The main Docker Compose file that defines the MongoDB and ActiveMQ services.
*   `start-docker-compose.ps1`: A PowerShell script to start the Docker Compose environment.
*   `config-mongo-db-container.sh`: A shell script that configures the MongoDB replica set within the container.
*   `.env`: An environment file for Docker Compose. You can use this file to customize the environment variables used in the `docker-compose.yml` file.

## `start-docker-compose.ps1`

The `start-docker-compose.ps1` script pulls the latest changes from Git, stops and removes any existing containers, and then starts the Docker Compose environment in detached mode.

### How to run

To run the `start-docker-compose.ps1` script, open a PowerShell terminal, navigate to this directory, and execute:

```powershell
.\start-docker-compose.ps1
```

## Services

*   **MongoDB**: A MongoDB replica set with three nodes, accessible on ports `27017`, `27018`, and `27019`.
*   **ActiveMQ**: An ActiveMQ message broker accessible on ports `8161` (web console), `61616` (TCP), and `5672` (AMQP).
