#!/bin/sh

pwn() {
    IMAGE="pwntainer"
    DOCKERFILE_DIR="$HOME/repos/my-dockerfiles/pwn"

    # 1. Check if image exists
    if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
        echo "[*] Docker image '$IMAGE' not found. Building..."
        docker build -t "$IMAGE" "$DOCKERFILE_DIR" || return 1
    fi

    # 2. Check for running container
    CONTAINER_ID=$(docker ps -q --filter "ancestor=$IMAGE")

    if [ -z "$CONTAINER_ID" ]; then
        echo "[*] No running '$IMAGE' container found. Starting one..."
        docker run -it --net=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v "$(pwd)":/home/ubuntu/chall "$IMAGE"
    else
        echo "[*] Attaching to running container..."
        docker exec -it "$CONTAINER_ID" /bin/zsh
    fi
}
