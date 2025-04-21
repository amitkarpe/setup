#!/usr/bin/env bash

set -euo pipefail

errors=0
export PATH="$HOME/.local/bin:$PATH"

echo "--- Testing Nextflow Installation ---"
if [[ -x "$(command -v nextflow)" ]]; then
    echo "Nextflow found: $(command -v nextflow)"
    echo "Running nextflow -v:"
    nextflow -v || { echo "ERROR: nextflow -v failed"; errors=$((errors + 1)); }
else
    echo "ERROR: nextflow command not found!"
    errors=$((errors + 1))
fi

echo ""
echo "--- Testing nf-core Installation ---"
if [[ -x "$(command -v nf-core)" ]]; then
    echo "nf-core found: $(command -v nf-core)"
    echo "Running nf-core --version:"
    # nf-core --version exits with 1, so we check output presence
    nf_core_version=$(nf-core --version 2>&1)
    if [[ -n "$nf_core_version" ]]; then
        echo "$nf_core_version"
    else
        echo "ERROR: nf-core --version failed or produced no output"
        errors=$((errors + 1))
    fi
else
    echo "ERROR: nf-core command not found!"
    errors=$((errors + 1))
fi

echo ""
echo "--- Testing Apptainer Installation ---"
if [[ -x "$(command -v apptainer)" ]]; then
    echo "Apptainer found: $(command -v apptainer)"
    echo "Running apptainer --version:"
    apptainer --version || { echo "ERROR: apptainer --version failed"; errors=$((errors + 1)); }
else
    echo "ERROR: apptainer command not found!"
    errors=$((errors + 1))
fi

# --- Container Tools Tests --- 
echo ""
echo "--- Testing Docker Installation ---"
if [[ -x "$(command -v docker)" ]]; then
    echo "Docker found: $(command -v docker)"
    docker --version || { echo "ERROR: docker --version failed"; errors=$((errors + 1)); }
    # Check compose plugin
    docker compose version || { echo "ERROR: docker compose version failed"; errors=$((errors + 1)); }
    # Check buildx plugin
    docker buildx version || { echo "ERROR: docker buildx version failed"; errors=$((errors + 1)); }
else
    echo "ERROR: docker command not found!"
    errors=$((errors + 1))
fi

echo ""
echo "--- Testing Podman Installation ---"
if [[ -x "$(command -v podman)" ]]; then
    echo "Podman found: $(command -v podman)"
    podman --version || { echo "ERROR: podman --version failed"; errors=$((errors + 1)); }
else
    echo "ERROR: podman command not found!"
    errors=$((errors + 1))
fi

echo ""
echo "--- Testing Buildah Installation ---"
if [[ -x "$(command -v buildah)" ]]; then
    echo "Buildah found: $(command -v buildah)"
    buildah --version || { echo "ERROR: buildah --version failed"; errors=$((errors + 1)); }
else
    echo "ERROR: buildah command not found!"
    errors=$((errors + 1))
fi

echo ""
echo "--- Testing Skopeo Installation ---"
if [[ -x "$(command -v skopeo)" ]]; then
    echo "Skopeo found: $(command -v skopeo)"
    skopeo --version || { echo "ERROR: skopeo --version failed"; errors=$((errors + 1)); }
else
    echo "ERROR: skopeo command not found!"
    errors=$((errors + 1))
fi

echo ""
if [[ $errors -eq 0 ]]; then
    echo "All tests passed!"
    exit 0
else
    echo "$errors test(s) failed."
    exit 1
fi 