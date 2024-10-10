#!/bin/bash

# Variables
DOCKER_SOCKET=/var/run/docker.sock
DOCKER_API_URL="http://localhost/v1.41"
BUILD_CONTEXT="build_context.tar" # This is the tarball of the Docker build context (Dockerfile + sources)
IMAGE_NAME="my-docker-image"

# Function to check if Docker is accessible via the API
check_docker_socket() {
    if [[ ! -S "$DOCKER_SOCKET" ]]; then
        echo "Docker socket not found at $DOCKER_SOCKET"
        exit 1
    fi
}

# Function to build the image using Docker's API
build_image() {
    echo "Building Docker image..."

    # Sending the tar archive via the API (multipart/form-data)
    response=$(curl -s --unix-socket "$DOCKER_SOCKET" -X POST \
        -H "Content-Type: application/x-tar" \
        --data-binary @"$BUILD_CONTEXT" \
        "$DOCKER_API_URL/build?t=$IMAGE_NAME")

    if [[ $? -ne 0 ]]; then
        echo "Failed to send build request."
        exit 1
    fi

    echo "$response" | jq '.'

    # Checking for build success
    if echo "$response" | grep -q "Successfully built"; then
        echo "Docker image '$IMAGE_NAME' built successfully!"
    else
        echo "Failed to build the Docker image. Check the output above for errors."
        exit 1
    fi
}

check_image() {
    echo "================================================"
    echo "================================================"
    echo "================================================"
    echo "Checking the content of the image..."
    echo "================================================"
    echo "================================================"
    docker run $IMAGE_NAME ls -lah /content
}

# Main function
main() {
    check_docker_socket
    build_image
    check_image
}

# Execute the script
main
