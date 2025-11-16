# Quick Start Guide - CLI Docker Wrapper Template

This guide will have you up and running with your own CLI wrapper in under 5 minutes.

## For Template Users

### Step 1: Create Your Repository

Click **"Use this template"** on GitHub or visit:
```
https://github.com/zero-to-prod/docker-wrapper-template/generate
```

### Step 2: Clone and Setup

```bash
# Clone your new repository
git clone https://github.com/yourusername/your-cli-wrapper.git
cd your-cli-wrapper

# Run the setup script
chmod +x setup.sh
./setup.sh
```

### Step 3: Answer the Prompts

The setup script will ask you:

1. **CLI Tool Name**: The command (e.g., `terraform`, `kubectl`)
2. **Display Name**: Full name (e.g., `Terraform CLI`)
3. **Short Name**: Acronym (e.g., `TF`)
4. **Description**: Brief description of the tool
5. **Download URL**: Where to get the binary
6. **Binary Name**: Filename after download
7. **Docker Config**: Image name and settings
8. **GitHub Info**: Repository and docs URLs
9. **Authentication**: Does it need auth?
10. **Example Command**: Sample usage

### Step 4: Build and Test

```bash
# Build the Docker image
docker build -t your-image-name .

# Test it
docker run --rm your-image-name --help
```

### Step 5: Push and Share

```bash
# Commit the generated files
git add .
git commit -m "Configure wrapper for [tool name]"
git push origin main

# Tag a release
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

## For End Users (Installing a Wrapper)

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/owner/repo/main/install.sh | bash
```

### Manual Install

```bash
# Pull the image
docker pull username/toolname:latest

# Run a command
docker run --rm username/toolname --help

# Create an alias
alias toolname='docker run -it --rm -v ~/.config/toolname:/root/.config/toolname username/toolname'
```

## Common Scenarios

### Scenario 1: Direct Binary (No Archive)

**Example: kubectl**

```bash
./setup.sh

# Enter when prompted:
CLI Tool Name: kubectl
Display Name: Kubernetes CLI
Short Name: KUBECTL
Download URL: https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl
Archive Type: 1 (binary)
Binary Name: kubectl
Docker Image: myuser/kubectl
Auth Required: no
Example Command: version --client
```

### Scenario 2: tar.gz with Subdirectories

**Example: GitLab CLI**

```bash
./setup.sh

# Enter when prompted:
CLI Tool Name: glab
Display Name: GitLab CLI
Short Name: GLAB
Download URL: https://gitlab.com/gitlab-org/cli/-/releases/v1.46.1/downloads/glab_1.46.1_Linux_x86_64.tar.gz
Archive Type: 2 (tar.gz)
Extract Path: bin/glab
Binary Name: glab
Docker Image: myuser/glab
Auth Required: yes
Auth Command: auth login
Example Command: issue list
```

### Scenario 3: Zip Archive

**Example: Terraform**

```bash
./setup.sh

# Enter when prompted:
CLI Tool Name: terraform
Display Name: Terraform CLI
Short Name: TF
Download URL: https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
Archive Type: 3 (zip)
Extract Path: (press Enter - binary in root)
Binary Name: terraform
Docker Image: myuser/terraform
Auth Required: no
Example Command: version
```

### Scenario 4: CLI Requiring Python

**Example: AWS CLI**

```bash
./setup.sh

# Enter when prompted:
CLI Tool Name: aws
Base Image: python:3.11-alpine
Runtime Image: python:3.11-alpine
# ... other prompts
```

Then edit the generated `Dockerfile` to install AWS CLI via pip.

## Troubleshooting

### Setup script permission denied
```bash
chmod +x setup.sh
./setup.sh
```

### Docker build fails
- Check the `DOWNLOAD_URL` is accessible
- Verify the `BINARY_NAME` matches the downloaded file
- For compressed files (zip/tar.gz), you may need to update the Dockerfile

### Tool requires additional dependencies
Edit the generated `Dockerfile` and add:
```dockerfile
RUN apk add --no-cache package-name
```

### Config directory permissions
```bash
chmod 700 ~/.config/your-tool-name
```

## Next Steps

1. **Customize**: Edit generated files as needed
2. **Document**: Add tool-specific usage examples
3. **Test**: Verify all commands work
4. **Publish**: Push to Docker Hub
5. **Share**: Let others know about your wrapper!

## Getting Help

- Template Issues: https://github.com/zero-to-prod/docker-wrapper-template/issues
- Examples: See [EXAMPLE_TOOLS.md](./EXAMPLE_TOOLS.md)
- Detailed Guide: See [TEMPLATE_USAGE.md](./TEMPLATE_USAGE.md)

---

**Template by**: [ZeroToProd](https://github.com/zero-to-prod)