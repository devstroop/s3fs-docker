# S3FS Docker

This repository contains a Docker setup to mount an S3 bucket using `mount-s3`.

## Prerequisites

- Docker
- Docker Compose

## Setup

1. Clone this repository:
    ```sh
    git clone <repository-url>
    cd s3fs-docker
    ```

2. Create and edit the `stack.env` file with your AWS credentials and configuration:
    ```sh
    cp stack.env.example stack.env
    ```

    Update the `stack.env` file with your AWS details:
    ```plaintext
    AWS_ENDPOINT_URL=<your-aws-or-compatible-endpoint-url> # Optional
    AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
    AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
    AWS_REGION=<your-aws-region>
    AWS_BUCKET=<your-aws-bucket>
    LOCAL_PATH=<your-local-path>
    ```

## Running the Container

1. Build and start the Docker container:
    ```sh
    docker-compose up --build -d
    ```

2. The S3 bucket will be mounted to the local path specified in the `stack.env` file.

## Stopping the Container

To stop the container, run:
```sh
docker-compose down