# Installation Guide

## Table of Contents

- [Prerequisites](#prerequisites)
- [Docker Install](#run-with-docker)

## Prerequisites

Before you begin, ensure that you have the following tools installed on your system:

1. **Make**
    - [Get Make](https://www.gnu.org/software/make/)

2. **Docker**
    - [Get Docker](https://docs.docker.com/get-started/get-docker/)

## Run with Docker
### 1. Build the Docker Image

Run the following command to build the Docker image for the application:

```bash
make build
```

- **What It Does:**  
  The `make build` command utilizes the `docker-compose.yml` file to build the Docker image. This process will install all necessary dependencies and compile the application into a runnable binary within a container.

### 2. Start the Application

After successfully building the Docker image, start the application by running:

```bash
make up
```

- **What It Does:**  
  The `make up` command launches the Docker containers using the `docker-compose.yml` file. This sets up the environment and starts the HTTP web server.

- **Application:**  
  Once the containers are up and running, you can access the **AW SuperFast Roadster Price Tracker** application by navigating to [http://localhost:3000](http://localhost:3000) in your web browser.

### Available Make Commands

The project includes a `Makefile` that simplifies common tasks. Below is an overview of the available commands:

| Command | Description |
| ------- | ----------- |
| `make build` | Builds the Docker image for the application using `docker-compose`. |
| `make up` | Starts the container and runs the application. |
| `make down` | Stops and removes the Docker's containers, images, and volumes. |
| `make tests` | Runs the unit tests inside the Docker container. |
