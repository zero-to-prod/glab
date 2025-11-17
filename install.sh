#!/usr/bin/env bash

set -eu

# Usage: curl -fsSL https://raw.githubusercontent.com/zero-to-prod/glab/main/install.sh | bash

DOCKER_IMAGE="davidsmith3/glab:latest"
CONFIG_DIR="${HOME}/.config/glab-cli"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

error() { echo -e "${RED}✗${NC} $1"; }

if ! command -v docker > /dev/null 2>&1; then
    error "Docker is not installed."
    echo ""
    echo "Install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
    error "Docker daemon is not running."
    echo ""
    echo "Please start Docker and try again."
    exit 1
fi

echo "Pulling Docker image..."
docker pull "${DOCKER_IMAGE}" || { error "Failed to pull Docker image"; exit 1; }

mkdir -p "${CONFIG_DIR}"
chmod 700 "${CONFIG_DIR}"

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo ""

# Conditional authentication steps
if [ "true" = "true" ]; then
    echo "1. Authenticate:"
    echo ""
    echo "   Then run:"
    echo -e "   ${GREEN}docker run -it --rm -v ~/.config/glab-cli:/root/.config/glab-cli ${DOCKER_IMAGE} auth login${NC}"
    echo ""
    echo "2. Run an example command (in a git repository):"
else
    echo "1. Run an example command (in a git repository):"
fi

echo -e "   ${GREEN}docker run --rm -v ~/.config/glab-cli:/root/.config/glab-cli -v \$(pwd):/workspace -w /workspace ${DOCKER_IMAGE} issue list${NC}"
echo ""
echo "Documentation:"
echo "   - Source: https://github.com/zero-to-prod/glab"
echo "   - Official Docs: https://gitlab.com/docs/editor_extensions/gitlab_cli/"
echo ""
echo "Run Directly:"
echo -e "   ${GREEN}docker run --rm -v ~/.config/glab-cli:/root/.config/glab-cli -v \$(pwd):/workspace -w /workspace ${DOCKER_IMAGE} [COMMAND] [OPTIONS]${NC}"
echo ""
echo "Alias:"
echo -e "   ${GREEN}alias glab='docker run --rm -v ~/.config/glab-cli:/root/.config/glab-cli -v \$(pwd):/workspace -w /workspace ${DOCKER_IMAGE}'${NC}"
echo ""
echo "Note: The alias omits -it flags to work in both interactive and non-interactive contexts."
echo "      For interactive commands like 'auth login', add -it manually to the docker run command."
echo ""