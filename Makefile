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
	docker-compose -f docker/docker-compose.yml down
