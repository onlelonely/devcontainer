#!/bin/bash

# Function to handle micromamba installations with retry logic
install_packages() {
    local max_attempts=3
    local attempt=1
    local delay=5

    while [ $attempt -le $max_attempts ]; do
        if micromamba install -y -n base "$@"; then
            return 0
        fi
        echo "Attempt $attempt failed to install: $*" >&2
        echo "Waiting ${delay} seconds before retry..."
        sleep "$delay"
        attempt=$((attempt + 1))
        delay=$((delay * 2))
    done
    echo "Failed to install after $max_attempts attempts." >&2
    return 1
}

# Function to handle micromamba removals with retry logic
remove_packages() {
    local max_attempts=3
    local attempt=1
    local delay=5

    while [ $attempt -le $max_attempts ]; do
        if micromamba remove -n base "$@"; then
            return 0
        fi
        echo "Attempt $attempt failed to remove: $*" >&2
        echo "Waiting ${delay} seconds before retry..."
        sleep "$delay"
        attempt=$((attempt + 1))
        delay=$((delay * 2))
    done
    echo "Failed to remove after $max_attempts attempts." >&2
    return 1
}

# Install core packages from a shared list (or keep these inline if they’re rarely changed)
micromamba clean --all --yes
sleep 2