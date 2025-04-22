#!/usr/bin/env bash

set -euo pipefail

# --- Colors and Emojis --- 
COLOR_GREEN=$(tput setaf 2)
COLOR_RED=$(tput setaf 1)
COLOR_YELLOW=$(tput setaf 3)
COLOR_RESET=$(tput sgr0)
EMOJI_SUCCESS="✅"
EMOJI_FAILURE="❌"
EMOJI_WARNING="⚠️"

errors=0
export PATH="$HOME/.local/bin:$PATH"

# Helper function for printing status
print_status() {
    local status_type=$1
    local message=$2
    local emoji=""
    local color=""

    case $status_type in
        success)
            emoji=$EMOJI_SUCCESS
            color=$COLOR_GREEN
            ;;
        failure)
            emoji=$EMOJI_FAILURE
            color=$COLOR_RED
            errors=$((errors + 1)) # Increment errors on failure
            ;;
        warning)
            emoji=$EMOJI_WARNING
            color=$COLOR_YELLOW
            ;;
        *) # Default to plain message
            printf "> %s\n" "$message"
            return
            ;;
    esac
    printf "%s%s %s%s\n" "$color" "$emoji" "$message" "$COLOR_RESET"
}

# --- Tests --- 

printf "--- Testing Nextflow Installation ---\n"
cmd_path=$(command -v nextflow)
if [[ -x "$cmd_path" ]]; then
    print_status success "Nextflow found: $cmd_path"
    printf "  Running nextflow -v:\n"
    if nextflow -v > /tmp/nf_version.txt 2>&1; then
        cat /tmp/nf_version.txt | sed 's/^/    /' # Indent output
        print_status success "nextflow -v check passed."
    else
        cat /tmp/nf_version.txt | sed 's/^/    /'
        print_status failure "nextflow -v failed."
    fi
    rm -f /tmp/nf_version.txt
else
    print_status failure "Nextflow command not found!"
fi

printf "\n--- Testing nf-core Installation ---\n"
cmd_path=$(command -v nf-core)
if [[ -x "$cmd_path" ]]; then
    print_status success "nf-core found: $cmd_path"
    printf "  Running nf-core --version:\n"
    nf_core_version=$(nf-core --version 2>&1)
    if [[ -n "$nf_core_version" ]]; then
        echo "$nf_core_version" | sed 's/^/    /' # Indent output
        # nf-core --version exits non-zero, so success is based on output existing
        print_status success "nf-core --version check passed (based on output)."
    else
        print_status failure "nf-core --version failed or produced no output."
    fi
else
    print_status failure "nf-core command not found!"
fi

printf "\n--- Testing Apptainer Installation ---\n"
cmd_path=$(command -v apptainer)
if [[ -x "$cmd_path" ]]; then
    print_status success "Apptainer found: $cmd_path"
    printf "  Running apptainer --version:\n"
    if apptainer --version > /tmp/app_version.txt 2>&1; then
        cat /tmp/app_version.txt | sed 's/^/    /'
        print_status success "apptainer --version check passed."
    else
        cat /tmp/app_version.txt | sed 's/^/    /'
        print_status failure "apptainer --version failed."
    fi
    rm -f /tmp/app_version.txt
else
    print_status failure "apptainer command not found!"
fi

# --- Container Tools Tests --- 
printf "\n--- Testing Docker Installation ---\n"
cmd_path=$(command -v docker)
if [[ -x "$cmd_path" ]]; then
    print_status success "Docker found: $cmd_path"
    if docker --version > /tmp/docker_version.txt 2>&1; then 
       cat /tmp/docker_version.txt | sed 's/^/    /'; print_status success "docker --version check passed.";
    else 
       cat /tmp/docker_version.txt | sed 's/^/    /'; print_status failure "docker --version failed.";
    fi
    if docker compose version > /tmp/compose_version.txt 2>&1; then 
       cat /tmp/compose_version.txt | sed 's/^/    /'; print_status success "docker compose version check passed.";
    else 
       cat /tmp/compose_version.txt | sed 's/^/    /'; print_status failure "docker compose version failed.";
    fi
     if docker buildx version > /tmp/buildx_version.txt 2>&1; then 
       cat /tmp/buildx_version.txt | sed 's/^/    /'; print_status success "docker buildx version check passed.";
    else 
       cat /tmp/buildx_version.txt | sed 's/^/    /'; print_status failure "docker buildx version failed.";
    fi
    rm -f /tmp/docker_version.txt /tmp/compose_version.txt /tmp/buildx_version.txt
else
    print_status failure "docker command not found!"
fi

printf "\n--- Testing Podman Installation ---\n"
cmd_path=$(command -v podman)
if [[ -x "$cmd_path" ]]; then
    print_status success "Podman found: $cmd_path"
    if podman --version > /tmp/pod_version.txt 2>&1; then 
       cat /tmp/pod_version.txt | sed 's/^/    /'; print_status success "podman --version check passed.";
    else 
       cat /tmp/pod_version.txt | sed 's/^/    /'; print_status failure "podman --version failed.";
    fi
    rm -f /tmp/pod_version.txt
else
    print_status failure "podman command not found!"
fi

printf "\n--- Testing Buildah Installation ---"
cmd_path=$(command -v buildah)
if [[ -x "$cmd_path" ]]; then
    print_status success "Buildah found: $cmd_path"
    if buildah --version > /tmp/bld_version.txt 2>&1; then 
       cat /tmp/bld_version.txt | sed 's/^/    /'; print_status success "buildah --version check passed.";
    else 
       cat /tmp/bld_version.txt | sed 's/^/    /'; print_status failure "buildah --version failed.";
    fi
    rm -f /tmp/bld_version.txt
else
    print_status failure "buildah command not found!"
fi

printf "\n--- Testing Skopeo Installation ---"
cmd_path=$(command -v skopeo)
if [[ -x "$cmd_path" ]]; then
    print_status success "Skopeo found: $cmd_path"
    if skopeo --version > /tmp/sko_version.txt 2>&1; then 
       cat /tmp/sko_version.txt | sed 's/^/    /'; print_status success "skopeo --version check passed.";
    else 
       cat /tmp/sko_version.txt | sed 's/^/    /'; print_status failure "skopeo --version failed.";
    fi
    rm -f /tmp/sko_version.txt
else
    print_status failure "skopeo command not found!"
fi

printf "\n--- Testing AWS CLI v2 Installation ---"
if [[ -x "$(command -v aws)" ]]; then
    print_status success "AWS CLI found: $(command -v aws)"
    printf "  Running aws --version:\n"
    aws_version_output=$(aws --version 2>&1)
    echo "$aws_version_output" | sed 's/^/    /'
    if echo "$aws_version_output" | grep -q 'aws-cli/2'; then
        print_status success "AWS CLI is version 2."
    else
        print_status failure "AWS CLI is NOT version 2."
    fi
else
    print_status failure "AWS CLI command not found!"
fi

printf "\n--- Testing SSM Agent Status ---"
# Check both snap and deb service names, prioritize active
if sudo systemctl is-active --quiet snap.amazon-ssm-agent.amazon-ssm-agent.service; then
    print_status success "SSM Agent (Snap) is active."
    sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service --no-pager | sed 's/^/    /'
elif sudo systemctl is-active --quiet amazon-ssm-agent; then
    print_status success "SSM Agent (.deb) is active."
    sudo systemctl status amazon-ssm-agent --no-pager | sed 's/^/    /'
elif command -v snap &> /dev/null && snap list amazon-ssm-agent &> /dev/null; then
    print_status failure "SSM Agent (Snap) is installed but NOT active."
elif systemctl list-units --all | grep -q amazon-ssm-agent.service; then 
    print_status failure "SSM Agent (.deb) is installed but NOT active."
else
    print_status failure "SSM Agent does not appear to be installed."
fi

printf "\n--- Summary ---\n"
if [[ $errors -eq 0 ]]; then
    print_status success "All tests passed!"
    exit 0
else
    print_status failure "$errors test(s) failed."
    exit 1
fi 