# Docker Environment Setup

This folder contains the necessary files to set up a local development environment using Docker Compose. The environment includes a MongoDB replica set and an ActiveMQ broker.

## Files

*   `docker-compose.yml`: The main Docker Compose file that defines the MongoDB and ActiveMQ services.
*   `start-docker-compose.ps1`: A PowerShell script to pull the latest changes from Git, stop and remove any existing containers, and then start the Docker Compose environment in detached mode.
*   `config-mongo-db-container.sh`: A shell script that configures the MongoDB replica set within the container.
*   `.env`: An environment file for Docker Compose (if needed).

## Usage

1.  Make sure you have Docker Desktop installed and running.
2.  Run the `start-docker-compose.ps1` script to start the environment.
3.  The script will:
    *   Change to the script's directory (or a specified working directory).
    *   Bring down and remove any existing Docker Compose services.
    *   Remove any containers with conflicting names.
    *   Start the services in detached mode.

## Services

*   **MongoDB**: A MongoDB replica set with three nodes, accessible on ports `27017`, `27018`, and `27019`.
*   **ActiveMQ**: An ActiveMQ message broker accessible on ports `8161` (web console), `61616` (TCP), and `5672` (AMQP).
