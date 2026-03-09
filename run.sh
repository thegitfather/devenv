#!/bin/bash

set -e

COMPOSE_FILE="container/compose.yml"
DOCKERFILE="container/Dockerfile"
IMAGE_NAME="devenv"
CONTAINER_NAME="devenv"

show_help() {
    echo "Usage: ./run.sh <command>"
    echo ""
    echo "Commands:"
    echo "  build          Build the Docker image"
    echo "  up             Start the container"
    echo "  down           Remove the container"
    echo "  stop           Stop the container"
    echo "  attach         Attach to the running container"
    echo "  exec <cmd>     Execute a command in the container"
    echo ""
    echo "Examples:"
    echo "  ./run.sh build"
    echo "  ./run.sh up"
    echo "  ./run.sh down"
    echo "  ./run.sh stop"
    echo "  ./run.sh attach"
    echo "  ./run.sh exec zsh"
    echo "  ./run.sh exec ls -la"
}

cmd_build() {
    echo "Building image: ${IMAGE_NAME}"
    docker build \
        --build-arg USER_ID="$(id -u)" \
        --build-arg GROUP_ID="$(id -g)" \
        -t "${IMAGE_NAME}" \
        -f "${DOCKERFILE}" .
}

cmd_up() {
    echo "Starting container: ${CONTAINER_NAME}"
    env UID="$(id -u)" GID="$(id -g)" docker compose -f "${COMPOSE_FILE}" up -d
}

cmd_down() {
    echo "Removing container: ${CONTAINER_NAME}"
    docker compose -f "${COMPOSE_FILE}" down
}

cmd_stop() {
    echo "Stopping container: ${CONTAINER_NAME}"
    docker compose -f "${COMPOSE_FILE}" stop
}

cmd_attach() {
    docker exec -it "${CONTAINER_NAME}" /bin/zsh
}

cmd_exec() {
    if [ -z "$2" ]; then
        echo "Error: missing command argument"
        echo "Usage: ./run.sh exec <command>"
        exit 1
    fi
    shift 1
    docker exec -it "${CONTAINER_NAME}" "$@"
}

case "${1:-}" in
    build)
        cmd_build
        ;;
    up)
        cmd_up
        ;;
    down)
        cmd_down
        ;;
    stop)
        cmd_stop
        ;;
    attach)
        cmd_attach
        ;;
    exec)
        cmd_exec "$@"
        ;;
    -h|--help|help|"")
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac