#!/bin/sh

claude-docker() {
    IMAGE="claude"
    DOCKERFILE_DIR="$HOME/repos/my-dockerfiles/claude"

    # 1. Check if image exists
    if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
        echo "[*] Docker image '$IMAGE' not found. Building..."
        docker build -t "$IMAGE" "$DOCKERFILE_DIR" || return 1
    fi

    # 2. Check for running container
    CONTAINER_ID=$(docker ps -q --filter "ancestor=$IMAGE")

    if [ -z "$CONTAINER_ID" ]; then
        echo "[*] No running '$IMAGE' container found. Starting one..."
        docker run -it --net=host -v "$HOME/.claude:/home/ubuntu/.claude" -v "$HOME/.claude.json:/home/ubuntu/.claude.json" -v "$(pwd)":/home/ubuntu/app "$IMAGE"
    else
        echo "[*] Attaching to running container..."
        docker exec -it "$CONTAINER_ID" /bin/zsh
    fi
}
