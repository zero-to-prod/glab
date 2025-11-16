# GLAB - GitLab CLI Docker Wrapper

[![Docker Pulls](https://img.shields.io/docker/pulls/davidsmith3/glab?style=flat-square&logo=docker)](https://hub.docker.com/r/davidsmith3/glab)
[![Docker Image Size](https://img.shields.io/docker/image-size/davidsmith3/glab/latest?style=flat-square&logo=docker)](https://hub.docker.com/r/davidsmith3/glab)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](./LICENSE.md)
[![GitHub Release](https://img.shields.io/github/v/release/zero-to-prod/glab?style=flat-square)](https://github.com/zero-to-prod/glab/releases)

A GitLab CLI tool bringing GitLab to your command line

> **Note**: Check the [official documentation](https://gitlab.com/docs/editor_extensions/gitlab_cli/) for the latest supported features and commands.

## Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
  - [Authentication Setup](#authentication-setup-required)
  - [Environment Variables](#environment-variables)
  - [Volume Mounts](#volume-mounts)
- [Usage](#usage)
  - [Basic Commands](#basic-command-structure)
  - [Common Use Cases](#common-use-cases)
  - [Shell Aliases](#creating-shell-aliases)
- [LLM/AI Assistant Usage](#llmai-assistant-usage)
- [Image Information](#image-information)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Quick Start

### One-Line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/zero-to-prod/glab/main/install.sh | bash

# Get the LLM Guide
curl https://raw.githubusercontent.com/zero-to-prod/glab/main/LLM_USAGE.md
```

### Manual Setup

```bash
# Pull the image
docker pull davidsmith3/glab:latest

# Authenticate (one-time setup)
docker run -it --rm -v ~/.config/glab-cli:/root/.config/glab-cli davidsmith3/glab auth login

# Run a command (example - requires a git repository)
docker run --rm -v ~/.config/glab-cli:/root/.config/glab-cli -v $(pwd):/workspace -w /workspace davidsmith3/glab issue list
```

### Creating Shell Aliases

For convenience, create an alias in your shell configuration (`.bashrc`, `.zshrc`):

```bash
alias glab='docker run --rm -v ~/.config/glab-cli:/root/.config/glab-cli -v $(pwd):/workspace -w /workspace davidsmith3/glab'
```

> **Note**: The alias omits `-it` flags to work in both interactive and non-interactive contexts. Add `-it` manually when needed for interactive commands like `auth login`.

## Prerequisites

Before using this Docker image, ensure you have:

- **Docker**: Version 20.10+ or **Docker Desktop** (Windows/Mac)
- **Docker Compose** (optional): Version 1.29+

## Installation

### Option 1: Using Docker Run (Recommended)

Pull the latest image from Docker Hub:

```bash
docker pull davidsmith3/glab:latest
```

### Option 2: Using Docker Compose

Create a `docker-compose.yml`:

```yaml
services:
  glab:
    image: davidsmith3/glab:latest
    container_name: glab
    volumes:
      - ~/.config/glab-cli:/root/.config/glab-cli
    environment:
      - TZ=UTC
```

Run with:
```bash
docker-compose run --rm glab --help
```

### Available Tags

- `latest` - Current stable release (recommended)
- `{X.Y.Z}` - Specific versions (e.g., `1.1.3`)
- `{X.Y}` - Major.minor versions (e.g., `1.1`)

## Configuration

### Authentication Setup (Required)

GLAB requires authentication to connect to your instance.

#### Step 1: Create Local Configuration

Configure GLAB with your credentials:

```bash
docker run -it --rm -v ~/.config/glab-cli:/root/.config/glab-cli davidsmith3/glab auth login
```

Follow the interactive prompts to complete authentication.

### Environment Variables

Optional environment variables you can set:

```bash
docker run --rm \
  -e TZ=UTC \
  -v ~/.config/glab-cli:/root/.config/glab-cli \
  -v $(pwd):/workspace \
  -w /workspace \
  davidsmith3/glab [COMMAND]
```

> **Note**: Add `-it` flag for interactive commands like `auth login`.

### Volume Mounts

**Essential volumes:**

| Volume                                                        | Purpose                     | Required |
|---------------------------------------------------------------|-----------------------------|----------|
| `~/.config/glab-cli:/root/.config/glab-cli` | Configuration & credentials | Yes      |
| `$(pwd):/workspace`                                           | Current directory access    | Optional |

**Example with workspace mount (recommended for most commands):**

```bash
docker run --rm \
  -v ~/.config/glab-cli:/root/.config/glab-cli \
  -v $(pwd):/workspace \
  -w /workspace \
  davidsmith3/glab [COMMAND]
```

Most glab commands require git repository context and should use the workspace mount pattern above.

### Security Considerations

- Configuration files are stored in `~/.config/glab-cli` on your host machine
- Never commit `.config/glab-cli` to version control
- Ensure file permissions are restrictive: `chmod 700 ~/.config/glab-cli`
- Use API tokens instead of passwords for authentication

## Usage

### Basic Command Structure

```bash
# For commands that need git repository context
docker run --rm \
  -v ~/.config/glab-cli:/root/.config/glab-cli \
  -v $(pwd):/workspace \
  -w /workspace \
  davidsmith3/glab [COMMAND] [OPTIONS]

# For interactive commands (like auth login)
docker run -it --rm \
  -v ~/.config/glab-cli:/root/.config/glab-cli \
  davidsmith3/glab [COMMAND] [OPTIONS]
```

### Quick Reference

Display help:
```bash
# General help
docker run --rm davidsmith3/glab --help

# Command-specific help
docker run --rm davidsmith3/glab [COMMAND] --help
```

### Common Use Cases

**Example commands:**
```bash
# List issues in current repository
docker run --rm \
  -v ~/.config/glab-cli:/root/.config/glab-cli \
  -v $(pwd):/workspace \
  -w /workspace \
  davidsmith3/glab issue list

# View repository information
docker run --rm \
  -v ~/.config/glab-cli:/root/.config/glab-cli \
  -v $(pwd):/workspace \
  -w /workspace \
  davidsmith3/glab repo view
```

After adding the alias (see [Creating Shell Aliases](#creating-shell-aliases)), restart your shell or run `source ~/.bashrc`. Then you can use:

```bash
# Use the alias for simpler commands
glab issue list
glab repo view

# For interactive commands, add -it manually
docker run -it --rm -v ~/.config/glab-cli:/root/.config/glab-cli davidsmith3/glab auth login
```

### Using Docker Compose

```bash
# Run a command
docker-compose run --rm glab issue list

# Interactive mode
docker-compose run --rm glab
```

## LLM/AI Assistant Usage

This Docker wrapper includes comprehensive documentation for Large Language Models and AI assistants to help users interact with GitLab.

### For AI Assistants

A complete guide is available in [`LLM_USAGE.md`](./LLM_USAGE.md) which includes:

- Complete command patterns with all required volume mounts
- Common use cases and workflows
- Error troubleshooting guide
- Environment variable usage
- Best practices for suggesting glab commands to users

### Quick Access

**View the LLM guide:**
```bash
curl https://raw.githubusercontent.com/zero-to-prod/glab/main/LLM_USAGE.md
```

### Key Points for AI Assistants

When helping users with glab commands, always:
1. Include both volume mounts: config (`~/.config/glab-cli`) and workspace (`$(pwd):/workspace`)
2. Use `-it` only for interactive commands (like `auth login`)
3. Verify user is in a git repository before suggesting repository commands
4. Check authentication status before suggesting authenticated operations
5. Suggest setting up the alias for frequent users

Example complete command:
```bash
docker run --rm \
  -v ~/.config/glab-cli:/root/.config/glab-cli \
  -v $(pwd):/workspace \
  -w /workspace \
  davidsmith3/glab issue list
```

## Image Information

### Docker Hub

- **Repository**: [davidsmith3/glab](https://hub.docker.com/r/davidsmith3/glab)
- **Pull Command**: `docker pull davidsmith3/glab`

### Updating the Image

```bash
# Pull the latest version
docker pull davidsmith3/glab:latest

# Verify the update
docker run --rm davidsmith3/glab --version
```

## Development

For development or custom builds, see [Image Development](./IMAGE_DEVELOPMENT.md).

### Project Links

- **Source Repository**: [zero-to-prod/glab](https://github.com/zero-to-prod/glab)
- **Docker Hub**: [davidsmith3/glab](https://hub.docker.com/r/davidsmith3/glab)
- **Official Docs**: [Documentation](https://gitlab.com/docs/editor_extensions/gitlab_cli/)

## Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check the [issues](https://github.com/zero-to-prod/glab/issues) page if you want to contribute.

Please read our:
- [Contributing Guide](./CONTRIBUTING.md) - Contribution guidelines
- [Code of Conduct](./CODE_OF_CONDUCT.md) - Community standards
- [Security Policy](./SECURITY.md) - Vulnerability reporting

### How to Contribute

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Make your changes
4. Commit changes (`git commit -m 'Add some feature'`)
5. Push to the branch (`git push origin feature-branch`)
6. Create a Pull Request

## License

This project is licensed under the MIT License - see [LICENSE.md](./LICENSE.md) for details.

---

**Maintained by**: [zero-to-prod](https://github.com/zero-to-prod)
**Last Updated**: 2025-11-16