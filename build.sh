#!/usr/bin/env bash
# Automated Build Script via Docker

IMAGE_NAME="ps5-payload-sdk"

# 1. Build the SDK Docker image if it doesn't exist
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "--- Docker image $IMAGE_NAME not found. Building... ---"
    docker build -t $IMAGE_NAME -f Dockerfile.sdk .
    if [ $? -ne 0 ]; then
        echo "!!! Docker image build FAILED!"
        exit 1
    fi
    echo "--- Docker image built successfully. ---"
fi

# 2. Build the native ELF via Docker
echo "--- Building elfldr-ps5.elf via Docker ---"
docker run --rm -v "$(pwd)":/src -w /src $IMAGE_NAME make clean all

if [ $? -ne 0 ]; then
    echo "!!! Build FAILED! Check source errors."
    exit 1
fi

echo "--- Build successful! elfldr-ps5.elf generated. ---"
