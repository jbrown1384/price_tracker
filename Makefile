DOCKER_COMPOSE_FILE = docker/docker-compose.yml
IMAGE_NAME = my-precision_scraper-app:latest

help:
	@echo "Usage:"
	@echo "  make build   - Build the Docker image"
	@echo "  make up      - Start the container in detached mode"
	@echo "  make down    - Stop the container"
	@echo "  make tests   - Running tests"

build:
	docker-compose -f docker/docker-compose.yml build

up:
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	@echo "Using docker-compose file: $(DOCKER_COMPOSE_FILE)"
	@echo "Stopping and removing containers, networks, and volumes related to the project..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) down --rmi local --volumes --remove-orphans

format-check:
	@echo "Running crystal format check..."
	docker run --rm $(IMAGE_NAME) crystal tool format --check

test: build
	@echo "Running tests inside Docker container..."
	docker run --rm $(IMAGE_NAME) crystal spec

