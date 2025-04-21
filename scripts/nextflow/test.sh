#!/usr/bin/env bash

set -euo pipefail

errors=0

echo "--- Testing Nextflow Installation ---"
if command -v nextflow &> /dev/null; then
    echo "Nextflow found: $(command -v nextflow)"
    echo "Running nextflow -v:"
    nextflow -v || { echo "ERROR: nextflow -v failed"; errors=$((errors + 1)); }
else
    echo "ERROR: nextflow command not found!"
    errors=$((errors + 1))
fi

echo ""
echo "--- Testing nf-core Installation ---"
if command -v nf-core &> /dev/null; then
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
if [[ $errors -eq 0 ]]; then
    echo "All tests passed!"
    exit 0
else
    echo "$errors test(s) failed."
    exit 1
fi 