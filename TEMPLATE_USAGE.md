# CLI Docker Wrapper Template Usage Guide

This repository is a GitHub template for creating Docker-wrapped CLI tools. It provides a standardized approach to containerizing any command-line tool with minimal configuration.

## What This Template Provides

- **Dockerized CLI wrapper** - Package any CLI tool in a Docker container
- **Automated setup script** - Interactive configuration for your specific CLI tool
- **Installation script** - One-line installation for end users
- **Complete documentation** - Pre-configured README with all necessary sections
- **Docker Compose support** - Optional compose configuration
- **Security best practices** - Proper volume mounts and permissions

## Quick Start

### Step 1: Use This Template

1. Click "Use this template" on GitHub
2. Create your new repository
3. Clone your new repository locally

### Step 2: Run the Setup Script

```bash
cd your-new-repo
chmod +x setup.sh
./setup.sh
```

The setup script will interactively prompt you for:

- **CLI Tool Name**: The command name (e.g., `glab`, `terraform`, `kubectl`)
- **Display Name**: Full name of the tool (e.g., `GitLab CLI`, `Terraform CLI`)
- **Short Name**: Acronym or short identifier (e.g., `GLAB`, `TF`)
- **Tool Description**: Brief description of what the tool does
- **Download URL**: Where to download the CLI binary
- **Archive Type**: Format of the download (direct binary, tar.gz, or zip)
- **Extract Path**: Path to binary within archive (if applicable)
- **Binary Name**: Name of the binary command
- **Docker Configuration**: Image name and configuration directory
- **Repository Info**: Source repo and documentation URLs
- **Authentication**: Whether the tool requires authentication and auth commands
- **Example Command**: Sample command for documentation

### Step 3: Build and Test

After setup completes, test your Docker image:

```bash
# Build the image
docker build -t your-docker-image .

# Test the image
docker run --rm your-docker-image --help
```

### Step 4: Customize (Optional)

Review and customize the generated files:

- `Dockerfile` - Docker image configuration
- `install.sh` - End-user installation script
- `docker-compose.yml` - Docker Compose configuration
- `README.md` - Complete documentation

### Step 5: Publish

1. Push to GitHub
2. Create a release
3. Optionally push to Docker Hub

## Configuration Variables

The setup script uses the following variables (defined in `.template.json`):

| Variable | Description | Example |
|----------|-------------|---------|
| `CLI_TOOL_NAME` | Command name | `glab` |
| `CLI_TOOL_DISPLAY_NAME` | Full display name | `GitLab CLI` |
| `CLI_TOOL_SHORTNAME` | Acronym | `GLAB` |
| `DOWNLOAD_URL` | Binary download URL | `https://gitlab.com/...` |
| `ARCHIVE_TYPE` | Download format | `binary`, `tar.gz`, or `zip` |
| `EXTRACT_PATH` | Path within archive | `bin/glab` (optional) |
| `DOCKER_IMAGE_NAME` | Docker Hub image | `username/glab` |
| `BINARY_NAME` | Binary filename | `glab` |
| `CONFIG_DIR_NAME` | Config directory | `glab` |
| `SOURCE_REPO` | Repository path | `user/repo` |
| `DOCS_URL` | Official docs | `https://docs.example.com` |
| `AUTH_REQUIRED` | Needs auth? | `true` or `false` |
| `AUTH_COMMAND` | Auth command | `login` |
| `EXAMPLE_COMMAND` | Example usage | `version` |
| `BASE_IMAGE` | Build stage image | `alpine/curl:8.11.1` |
| `RUNTIME_IMAGE` | Runtime image | `alpine:3.21` |

## Template Structure

```
.
├── .template.json           # Configuration schema
├── setup.sh                 # Interactive setup script
├── Dockerfile.template      # Parameterized Dockerfile
├── install.sh.template      # Parameterized install script
├── docker-compose.yml.template  # Parameterized compose file
├── README.md.template       # Parameterized documentation
├── TEMPLATE_USAGE.md        # This file (delete after setup)
└── [other standard files]   # LICENSE, CONTRIBUTING, etc.
```

## How It Works

1. **Template Files**: All `.template` files contain placeholders like `{{CLI_TOOL_NAME}}`
2. **Setup Script**: Prompts for values and performs search-replace operations
3. **File Generation**: Creates final files by replacing all placeholders
4. **Cleanup**: Removes template files and setup script after completion

## Archive Type Support

The template supports three download formats:

### 1. Direct Binary (Option 1)
- Download is a single executable file
- No extraction needed
- Example: kubectl, doctl
- **Configuration:**
  - Archive Type: `binary`
  - Extract Path: (not applicable)
  - Example: kubectl, doctl

### 2. tar.gz Archive (Option 2)
- Download is a compressed tarball
- May contain subdirectories
- Example: glab (GitLab CLI), Helm
- **Configuration:**
  - Archive Type: `tar.gz`
  - Extract Path: `bin/glab` (if binary is in subdirectory) or empty (if in root)

### 3. Zip Archive (Option 3)
- Download is a zip file
- May contain subdirectories
- Example: Terraform, AWS CLI
- **Configuration:**
  - Archive Type: `zip`
  - Extract Path: Path to binary or empty if in root

**The Dockerfile automatically handles extraction based on your selection!**

## Examples

### Example 1: Wrapping GitLab CLI (glab)

```bash
./setup.sh

# Prompts and responses:
CLI Tool Name: glab
Display Name: GitLab CLI
Short Name: GLAB
Download URL: https://gitlab.com/gitlab-org/cli/-/releases/v1.46.1/downloads/glab_1.46.1_Linux_x86_64.tar.gz
Archive Type: 2 (tar.gz)
Extract Path: bin/glab
Binary Name: glab
Docker Image: myusername/glab
Config Directory: glab
Source Repo: myusername/glab-docker
Docs URL: https://docs.gitlab.com/cli/
Auth Required: yes
Auth Command: auth login
Example Command: issue list
```

### Example 2: Wrapping Terraform CLI

```bash
./setup.sh

# Prompts and responses:
CLI Tool Name: terraform
Display Name: Terraform CLI
Short Name: TF
Download URL: https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
Archive Type: 3 (zip)
Extract Path: (press Enter - binary is in root)
Binary Name: terraform
Docker Image: myusername/terraform
Config Directory: terraform.d
Source Repo: myusername/terraform-docker
Docs URL: https://www.terraform.io/docs
Auth Required: no
Example Command: version
```

### Example 3: Wrapping Direct Binary (kubectl)

```bash
./setup.sh

# Prompts and responses:
CLI Tool Name: kubectl
Display Name: Kubernetes CLI
Short Name: KUBECTL
Download URL: https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl
Archive Type: 1 (binary)
Binary Name: kubectl
Docker Image: myusername/kubectl
Config Directory: kube
Source Repo: myusername/kubectl-docker
Docs URL: https://kubernetes.io/docs/reference/kubectl/
Auth Required: no
Example Command: version --client
```

## Advanced Customization

### Custom Dockerfile Logic

If your CLI tool requires additional dependencies or setup:

1. Let the setup script create the base `Dockerfile`
2. Manually edit the generated `Dockerfile` to add:
   - Additional RUN commands
   - Environment variables
   - Extra packages

### Multi-Architecture Support

To support multiple architectures (amd64, arm64):

1. Update the `Dockerfile` to use multi-arch base images
2. Use `docker buildx` for building
3. Update GitHub Actions for multi-platform builds

### Custom Volume Mounts

Some tools may need additional volume mounts:

1. Edit the generated `install.sh` to add more `-v` flags
2. Update the README with documentation for additional volumes
3. Modify `docker-compose.yml` to include extra volumes

## Publishing to Docker Hub

After setup:

1. **Build for your platform:**
   ```bash
   docker build -t username/toolname:latest .
   ```

2. **Tag versions:**
   ```bash
   docker tag username/toolname:latest username/toolname:1.0.0
   docker tag username/toolname:latest username/toolname:1.0
   ```

3. **Push to Docker Hub:**
   ```bash
   docker push username/toolname:latest
   docker push username/toolname:1.0.0
   docker push username/toolname:1.0
   ```

4. **Set up automated builds** (optional):
   - Configure GitHub Actions
   - Use the included workflow templates

## Troubleshooting

### Setup script fails with "command not found"

Ensure the script is executable:
```bash
chmod +x setup.sh
```

### Docker build fails to download binary

- Verify the `DOWNLOAD_URL` is correct and accessible
- Check if the download requires authentication
- Consider using a different base image with required tools

### Permission denied errors

Set proper permissions on config directory:
```bash
chmod 700 ~/.config/your-tool-name
```

## Support

For issues with:
- **This template**: Open an issue in the template repository
- **Your generated wrapper**: Open an issue in your wrapper repository
- **The wrapped CLI tool**: Refer to the tool's official documentation

## License

This template is licensed under the MIT License. Generated projects inherit this license by default, but you can change it to fit your needs.

---

**Template Maintained by**: [ZeroToProd](https://github.com/zero-to-prod)