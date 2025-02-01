DOCKER_COMPOSE_FILE = docker/docker-compose.yml

help:
	@echo "Usage:"
	@echo "  make build   - Build the Docker image"
	@echo "  make up      - Start the container in detached mode"
	@echo "  make down    - Stop the container"

build:
	docker-compose -f docker/docker-compose.yml build

up:
	docker-compose -f docker/docker-compose.yml up -d

down:
	@echo "Using docker-compose file: $(DOCKER_COMPOSE_FILE)"
	@echo "Stopping and removing containers, networks, images, and volumes..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) down --rmi all --volumes --remove-orphans
	@echo "Removing dangling Docker resources..."
	docker system prune -f --volumes
