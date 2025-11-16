#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

success() { echo -e "${GREEN}✓${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
info() { echo -e "${BLUE}ℹ${NC} $1"; }

prompt() {
    local var_name=$1
    local prompt_text=$2
    local example=$3
    local required=$4

    while true; do
        echo ""
        echo -e "${YELLOW}${prompt_text}${NC}"
        if [ -n "$example" ]; then
            echo -e "  ${BLUE}Example:${NC} ${example}"
        fi

        if [ "$required" = "true" ]; then
            echo -n "  Enter value (required): "
        else
            echo -n "  Enter value (optional, press Enter to skip): "
        fi

        read -r value

        if [ -n "$value" ]; then
            eval "$var_name='$value'"
            break
        elif [ "$required" = "false" ]; then
            eval "$var_name=''"
            break
        else
            error "This field is required. Please enter a value."
        fi
    done
}

confirm() {
    local prompt_text=$1
    echo ""
    echo -n -e "${YELLOW}${prompt_text}${NC} (y/n): "
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

replace_in_file() {
    local file=$1
    local search=$2
    local replace=$3

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|${search}|${replace}|g" "$file"
    else
        sed -i "s|${search}|${replace}|g" "$file"
    fi
}

# Main script
print_header "CLI Docker Wrapper Template Setup"

info "This script will help you configure the template for your CLI tool."
info "You'll be prompted to enter information about the CLI tool you want to wrap."

echo ""
if ! confirm "Continue with setup?"; then
    error "Setup cancelled."
    exit 0
fi

# Collect user input
print_header "CLI Tool Information"

prompt CLI_TOOL_NAME "What is the name of the CLI tool?" "glab" "true"
prompt CLI_TOOL_DISPLAY_NAME "What is the display name?" "GitLab CLI" "true"
prompt CLI_TOOL_SHORTNAME "What is the short name/acronym?" "GLAB" "true"
prompt TOOL_DESCRIPTION "Brief description of the tool:" "A GitLab CLI tool bringing GitLab to your command line" "true"

print_header "Download Configuration"

prompt DOWNLOAD_URL "What is the download URL for the CLI binary?" "https://gitlab.com/gitlab-org/cli/-/releases/v1.46.1/downloads/glab_1.46.1_Linux_x86_64.tar.gz" "true"

# Archive type selection
echo ""
echo -e "${YELLOW}What format is the download?${NC}"
echo "  ${BLUE}1)${NC} Direct binary (no extraction needed)"
echo "  ${BLUE}2)${NC} tar.gz archive"
echo "  ${BLUE}3)${NC} zip archive"
echo ""
echo -n "  Enter choice (1-3): "
read -r archive_choice

case $archive_choice in
    1)
        ARCHIVE_TYPE="binary"
        info "Selected: Direct binary download"
        ;;
    2)
        ARCHIVE_TYPE="tar.gz"
        info "Selected: tar.gz archive"
        ;;
    3)
        ARCHIVE_TYPE="zip"
        info "Selected: zip archive"
        ;;
    *)
        error "Invalid choice. Defaulting to binary."
        ARCHIVE_TYPE="binary"
        ;;
esac

# Ask for extract path if archive type
if [ "$ARCHIVE_TYPE" != "binary" ]; then
    prompt EXTRACT_PATH "Path to binary within archive (or press Enter if in root):" "bin/glab" "false"
else
    EXTRACT_PATH=""
fi

prompt BINARY_NAME "What is the binary command name?" "glab" "true"
prompt BASE_IMAGE "Docker base image for build stage:" "alpine/curl:8.11.1" "true"
prompt RUNTIME_IMAGE "Docker runtime image:" "alpine:3.21" "true"

print_header "Docker Configuration"

prompt DOCKER_IMAGE_NAME "Docker Hub image name (e.g., username/toolname):" "yourusername/glab" "true"
prompt CONFIG_DIR_NAME "Configuration directory name (relative to ~/.config/):" "glab" "true"

print_header "Repository Information"

prompt SOURCE_REPO "Source repository (owner/repo format):" "yourusername/your-cli-wrapper" "true"
prompt DOCS_URL "Official documentation URL:" "https://docs.gitlab.com/cli/" "true"

print_header "Authentication Configuration"

if confirm "Does the tool require authentication?"; then
    AUTH_REQUIRED="true"
    prompt AUTH_COMMAND "What is the authentication command?" "auth login" "true"
else
    AUTH_REQUIRED="false"
    AUTH_COMMAND=""
fi

print_header "Example Command"

prompt EXAMPLE_COMMAND "Provide an example command for documentation:" "issue list" "true"

# Summary
print_header "Configuration Summary"
echo ""
echo "CLI Tool Name:        ${CLI_TOOL_NAME}"
echo "Display Name:         ${CLI_TOOL_DISPLAY_NAME}"
echo "Short Name:           ${CLI_TOOL_SHORTNAME}"
echo "Description:          ${TOOL_DESCRIPTION}"
echo "Download URL:         ${DOWNLOAD_URL}"
echo "Archive Type:         ${ARCHIVE_TYPE}"
if [ -n "$EXTRACT_PATH" ]; then
    echo "Extract Path:         ${EXTRACT_PATH}"
fi
echo "Binary Name:          ${BINARY_NAME}"
echo "Docker Image:         ${DOCKER_IMAGE_NAME}"
echo "Config Directory:     ~/.config/${CONFIG_DIR_NAME}"
echo "Source Repo:          ${SOURCE_REPO}"
echo "Documentation:        ${DOCS_URL}"
echo "Auth Required:        ${AUTH_REQUIRED}"
if [ "$AUTH_REQUIRED" = "true" ]; then
    echo "Auth Command:         ${AUTH_COMMAND}"
fi
echo "Example Command:      ${EXAMPLE_COMMAND}"
echo "Base Image:           ${BASE_IMAGE}"
echo "Runtime Image:        ${RUNTIME_IMAGE}"

echo ""
if ! confirm "Proceed with these settings?"; then
    error "Setup cancelled. No files were modified."
    exit 0
fi

# Apply replacements
print_header "Applying Configuration"

info "Updating Dockerfile..."
replace_in_file "Dockerfile.template" "{{BASE_IMAGE}}" "$BASE_IMAGE"
replace_in_file "Dockerfile.template" "{{DOWNLOAD_URL}}" "$DOWNLOAD_URL"
replace_in_file "Dockerfile.template" "{{ARCHIVE_TYPE}}" "$ARCHIVE_TYPE"
replace_in_file "Dockerfile.template" "{{EXTRACT_PATH}}" "$EXTRACT_PATH"
replace_in_file "Dockerfile.template" "{{BINARY_NAME}}" "$BINARY_NAME"
replace_in_file "Dockerfile.template" "{{RUNTIME_IMAGE}}" "$RUNTIME_IMAGE"
replace_in_file "Dockerfile.template" "{{CLI_TOOL_SHORTNAME}}" "$CLI_TOOL_SHORTNAME"
replace_in_file "Dockerfile.template" "{{CLI_TOOL_DISPLAY_NAME}}" "$CLI_TOOL_DISPLAY_NAME"
replace_in_file "Dockerfile.template" "{{TOOL_DESCRIPTION}}" "$TOOL_DESCRIPTION"
replace_in_file "Dockerfile.template" "{{SOURCE_REPO}}" "$SOURCE_REPO"
replace_in_file "Dockerfile.template" "{{DOCS_URL}}" "$DOCS_URL"
replace_in_file "Dockerfile.template" "{{DOCKER_IMAGE_NAME}}" "$DOCKER_IMAGE_NAME"
replace_in_file "Dockerfile.template" "{{CONFIG_DIR_NAME}}" "$CONFIG_DIR_NAME"
mv Dockerfile.template Dockerfile
success "Dockerfile configured"

info "Updating install.sh..."
replace_in_file "install.sh.template" "{{DOCKER_IMAGE_NAME}}" "$DOCKER_IMAGE_NAME"
replace_in_file "install.sh.template" "{{CONFIG_DIR_NAME}}" "$CONFIG_DIR_NAME"
replace_in_file "install.sh.template" "{{SOURCE_REPO}}" "$SOURCE_REPO"
replace_in_file "install.sh.template" "{{CLI_TOOL_NAME}}" "$CLI_TOOL_NAME"
replace_in_file "install.sh.template" "{{AUTH_REQUIRED}}" "$AUTH_REQUIRED"
replace_in_file "install.sh.template" "{{AUTH_COMMAND}}" "$AUTH_COMMAND"
replace_in_file "install.sh.template" "{{EXAMPLE_COMMAND}}" "$EXAMPLE_COMMAND"
replace_in_file "install.sh.template" "{{DOCS_URL}}" "$DOCS_URL"
mv install.sh.template install.sh
chmod +x install.sh
success "install.sh configured"

info "Updating docker-compose.yml..."
replace_in_file "docker-compose.yml.template" "{{CLI_TOOL_NAME}}" "$CLI_TOOL_NAME"
replace_in_file "docker-compose.yml.template" "{{CONFIG_DIR_NAME}}" "$CONFIG_DIR_NAME"
replace_in_file "docker-compose.yml.template" "{{BINARY_NAME}}" "$BINARY_NAME"
mv docker-compose.yml.template docker-compose.yml
success "docker-compose.yml configured"

info "Updating README.md..."
cp README.md.template README.md.tmp

# Handle conditional blocks for AUTH_REQUIRED
if [ "$AUTH_REQUIRED" = "true" ]; then
    # Remove conditional markers but keep content
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' '/{{#if AUTH_REQUIRED}}/d' README.md.tmp
        sed -i '' '/{{\/if}}/d' README.md.tmp
    else
        sed -i '/{{#if AUTH_REQUIRED}}/d' README.md.tmp
        sed -i '/{{\/if}}/d' README.md.tmp
    fi
else
    # Remove entire conditional blocks including content
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' '/{{#if AUTH_REQUIRED}}/,/{{\/if}}/d' README.md.tmp
    else
        sed -i '/{{#if AUTH_REQUIRED}}/,/{{\/if}}/d' README.md.tmp
    fi
fi

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Replace all variables
replace_in_file "README.md.tmp" "{{CLI_TOOL_NAME}}" "$CLI_TOOL_NAME"
replace_in_file "README.md.tmp" "{{CLI_TOOL_DISPLAY_NAME}}" "$CLI_TOOL_DISPLAY_NAME"
replace_in_file "README.md.tmp" "{{CLI_TOOL_SHORTNAME}}" "$CLI_TOOL_SHORTNAME"
replace_in_file "README.md.tmp" "{{TOOL_DESCRIPTION}}" "$TOOL_DESCRIPTION"
replace_in_file "README.md.tmp" "{{DOCKER_IMAGE_NAME}}" "$DOCKER_IMAGE_NAME"
replace_in_file "README.md.tmp" "{{CONFIG_DIR_NAME}}" "$CONFIG_DIR_NAME"
replace_in_file "README.md.tmp" "{{SOURCE_REPO}}" "$SOURCE_REPO"
replace_in_file "README.md.tmp" "{{DOCS_URL}}" "$DOCS_URL"
replace_in_file "README.md.tmp" "{{AUTH_COMMAND}}" "$AUTH_COMMAND"
replace_in_file "README.md.tmp" "{{EXAMPLE_COMMAND}}" "$EXAMPLE_COMMAND"
replace_in_file "README.md.tmp" "{{CURRENT_DATE}}" "$CURRENT_DATE"

mv README.md.tmp README.md
success "README.md configured"

# Clean up template files
info "Cleaning up template files..."
rm -f .template.json
rm -f setup.sh
success "Template files removed"

print_header "Setup Complete!"
echo ""
success "Your CLI wrapper has been configured successfully!"
echo ""
info "Next steps:"
echo ""
echo "1. Review the generated files:"
echo "   - Dockerfile"
echo "   - install.sh"
echo "   - docker-compose.yml"
echo "   - README.md"
echo ""
echo "2. Build and test your Docker image:"
echo -e "   ${GREEN}docker build -t ${DOCKER_IMAGE_NAME} .${NC}"
echo -e "   ${GREEN}docker run --rm ${DOCKER_IMAGE_NAME} --help${NC}"
echo ""
echo "3. Customize the documentation as needed"
echo ""
echo "4. Push to GitHub and share your CLI wrapper!"
echo ""