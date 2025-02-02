# File Structure Overview

## Table of Contents

- [Project Structure](#project-structure)
    - [/](#root-directory)
    - [`src/`](#src-directory)
        - [`main.cr`](#main)
        - [`scraper/`](#scraper)
            - [Scraper Architecture](#scraper-architecture)
        - [`routes/`](#routes)
        - [`structs/`](#structs)
        - [`views/`](#views)
        - [`public/`](#public)
        - [`utils/`](#utils)
    - [`db/migrations/`](#dbmigrations)
    - [`spec/`](#spec)
    - [`.github/`](#github)

## Project Structure

### Root Directory

- **`docker/`**: Holds Docker related configurations, including the `Dockerfile` for building the Docker image and `docker-compose.yml` for orchestrating multiple Docker services.

- **`data/` & `lib/`**: these directories are mounted as Docker volumes to give the ability to manage dependencies outside the container.

- **`Makefile`**: Automates typical actions like building, running, testing the application.

- **`shard.yml`**:Contains the Project's dependencies.
---

## `src/` Directory

The `src/` directory contains the core source code for the application. It's organized into subdirectories based on functionality. 

### `main`

- This is entrypoint of the application. It's core responsibility are:
    - Initialize the application, set up the database connection and checking if migrations need to be ran.
    - Configures and starts the HTTP server.
    - Instantiates web scrapers to begin periodically scraping products based on which sites are active in the `sites` table.

### `scraper/`

#### Scraper Architecture

- **Purpose**: Manages the logic for scraping product data from the web.

- **Structure**:
    - **`base_scraper`**: A subclass of the interface that provides some shared functionality and default properties. Should make adding new scrapers in the future easier while helping conform the logic between different sites. 
    - **`scraper_interface`**: Is the interface for all scraper logic workflows.

### `routes/`

- **Purpose**: Sets up http routes for the Kemal web framework.

- **Functionality**:
    - **Routing**: Defines the endpoints for the web application
    - **API Endpoints**:
        - **GET `/`**: Retrieves stored product pricing data and passes it to the frontend.
        - **POST `/scrape`**: Triggers a manual price scrape.

### `structs/`

- **Purpose**: Contains the database models representing the application's database tables. Contains structs for:
    - `products`
    - `product_history`
    - `site`

### `views/`

- **Purpose**: Manages the frontend view components. Uses Crystal language's templating engine to pass data into the html components.

### `public/`

- **Purpose**: frontend assets.

- **Contents**:
    - **js Files**: Contains the app.js script for creating the chart and triggering a new price value based.
    - **images**: Stores images and icons for the frontend.

### `utils/`

- **Purpose**: general library modules that can be used throughout the application. 

- **Contents**:
    - **`logger.cr`**: Implements a static logger to standardize logging across the system.
---

### `db/migrations/`

- **Purpose**: Manages database schema change files. `UP` method to make new changes to the database, tables, and data. `DOWN` to rollback the changes from the UP functionality.

---

## `docs/`

- **Purpose**: Contains the documentation for explaining the architecture and some of the decision making that went into building the application.

---

## `spec/`

- **Purpose**: Contains the unit tests for portions of the web application. 

- **Contents**:
    - **Unit Tests**: Tests individual components and modules to ensure they function correctly in isolation.

---

## `.github/`

- **Purpose**: contains the workflows and github actions yml files that will be necessary for future ci/cd processes. 

- **Contents**:
    - **`workflows/`**: Defines GitHub Actions workflows that automate tasks such as testing, building, and deploying the application. Right now it's just running the tests when a pull request is created and targetted at the `main` branch using `pull_request.yml`

---