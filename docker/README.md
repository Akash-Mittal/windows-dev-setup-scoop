# Docker Environment Setup

This folder contains the necessary files to set up a local development environment using Docker Compose. The environment includes a MongoDB replica set and an ActiveMQ broker.

## Files

*   `docker-compose.yml`: The main Docker Compose file that defines the MongoDB and ActiveMQ services.
*   `start-docker-compose.ps1`: A PowerShell script to manage the Docker Compose environment.
*   `config-mongo-db-container.sh`: A shell script that configures the MongoDB replica set within the container. This script is typically executed automatically as part of the MongoDB service startup defined in `docker-compose.yml`.
*   `.env`: An environment file for Docker Compose. You can use this file to customize environment variables used in `docker-compose.yml`.

## `start-docker-compose.ps1`

The `start-docker-compose.ps1` script is designed to manage your Docker Compose environment. It can pull the latest images, stop and remove existing containers, and then start the Docker Compose environment in detached mode.

### Parameters

*   `-ResetData`: A switch parameter. If present, the script will remove existing Docker volumes for MongoDB and ActiveMQ before starting, effectively resetting their data. Use with caution as this will delete all persistent data for these services.

### How to run

1.  **Via `fire.ps1`**:
    The `fire.ps1` script (located in the repository root) is configured to call `start-docker-compose.ps1` as part of its startup sequence, typically without the `-ResetData` flag (e.g., `-ResetData:$false`).

2.  **Manually from PowerShell**:
    Open a PowerShell terminal, navigate to this `docker` directory, and execute:

    *   **To start the environment without resetting data**:
        ```powershell
        .\start-docker-compose.ps1
        ```
        or
        ```powershell
        .\start-docker-compose.ps1 -ResetData:$false
        ```

    *   **To start the environment and reset all data**:
        ```powershell
        .\start-docker-compose.ps1 -ResetData
        ```

## Services

*   **MongoDB**: A MongoDB replica set with three nodes, accessible on ports `27017`, `27018`, and `27019`.
*   **ActiveMQ**: An ActiveMQ message broker accessible on ports `8161` (web console), `61616` (TCP), and `5672` (AMQP).
