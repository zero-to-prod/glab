# Example CLI Tools to Wrap

This document provides configuration examples for popular CLI tools you might want to wrap using this template.

## GitLab CLI (glab)

**Configuration:**
```
CLI Tool Name: glab
Display Name: GitLab CLI
Short Name: GLAB
Tool Description: A GitLab CLI tool bringing GitLab to your command line
Download URL: https://gitlab.com/gitlab-org/cli/-/releases/v1.46.1/downloads/glab_1.46.1_Linux_x86_64.tar.gz
Archive Type: tar.gz (select option 2)
Extract Path: bin/glab
Binary Name: glab
Docker Image: yourusername/glab
Config Directory: glab
Source Repo: yourusername/glab-docker
Docs URL: https://docs.gitlab.com/cli/
Auth Required: yes
Auth Command: auth login
Example Command: issue list
Base Image: alpine/curl:8.11.1
Runtime Image: alpine:3.21
```

**Notes:**
- glab downloads as a tar.gz archive with subdirectories
- The binary is located at `bin/glab` within the archive
- Requires authentication via `glab auth login`
- Configuration stored in `~/.config/glab`
- Check https://gitlab.com/gitlab-org/cli/-/releases for latest version
- **Template handles this automatically** with archive type selection!

## Terraform CLI

**Configuration:**
```
CLI Tool Name: terraform
Display Name: Terraform CLI
Short Name: TF
Tool Description: Infrastructure as Code tool for building, changing, and versioning infrastructure
Download URL: https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
Archive Type: zip (select option 3)
Extract Path: (leave empty - binary is in root)
Binary Name: terraform
Docker Image: yourusername/terraform
Config Directory: terraform.d
Source Repo: yourusername/terraform-docker
Docs URL: https://www.terraform.io/docs
Auth Required: no
Example Command: version
Base Image: alpine/curl:8.11.1
Runtime Image: alpine:3.21
```

**Notes:**
- Terraform downloads as a zip file
- **Template handles extraction automatically** with archive type selection!
- Common volume mounts: `-v $(pwd):/workspace` for working with local terraform files

## AWS CLI

**Configuration:**
```
CLI Tool Name: aws
Display Name: AWS CLI
Short Name: AWS
Tool Description: Official Amazon AWS command-line interface for managing AWS services
Download URL: https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
Binary Name: aws
Docker Image: yourusername/aws-cli
Config Directory: aws
GitHub Repo: yourusername/aws-cli-docker
Docs URL: https://docs.aws.amazon.com/cli/
Auth Required: yes
Auth Command: configure
Example Command: s3 ls
Base Image: alpine:3.21
Runtime Image: alpine:3.21
```

**Notes:**
- AWS CLI requires Python runtime
- May need to adjust base image to include Python
- Credentials stored in `~/.aws/`

## kubectl (Kubernetes CLI)

**Configuration:**
```
CLI Tool Name: kubectl
Display Name: Kubernetes CLI
Short Name: K8S
Tool Description: Command-line tool for controlling Kubernetes clusters
Download URL: https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl
Binary Name: kubectl
Docker Image: yourusername/kubectl
Config Directory: kube
GitHub Repo: yourusername/kubectl-docker
Docs URL: https://kubernetes.io/docs/reference/kubectl/
Auth Required: yes
Auth Command: config view
Example Command: get pods
Base Image: alpine/curl:8.11.1
Runtime Image: alpine:3.21
```

**Notes:**
- Kubeconfig typically stored in `~/.kube/config`
- Volume mount: `-v ~/.kube:/root/.kube`

## GitHub CLI (gh)

**Configuration:**
```
CLI Tool Name: gh
Display Name: GitHub CLI
Short Name: GH
Tool Description: GitHub's official command-line tool for interacting with GitHub
Download URL: https://github.com/cli/cli/releases/download/v2.40.0/gh_2.40.0_linux_amd64.tar.gz
Binary Name: gh
Docker Image: yourusername/gh
Config Directory: gh
GitHub Repo: yourusername/gh-docker
Docs URL: https://cli.github.com/manual/
Auth Required: yes
Auth Command: auth login
Example Command: repo list
Base Image: alpine/curl:8.11.1
Runtime Image: alpine:3.21
```

**Notes:**
- Download is a tar.gz, adjust Dockerfile to extract
- Auth tokens stored in `~/.config/gh/`

## Docker CLI

**Configuration:**
```
CLI Tool Name: docker
Display Name: Docker CLI
Short Name: Docker
Tool Description: Command-line interface for Docker container platform
Download URL: https://download.docker.com/linux/static/stable/x86_64/docker-24.0.0.tgz
Binary Name: docker
Docker Image: yourusername/docker-cli
Config Directory: docker
GitHub Repo: yourusername/docker-cli-wrapper
Docs URL: https://docs.docker.com/engine/reference/commandline/cli/
Auth Required: no
Example Command: version
Base Image: alpine/curl:8.11.1
Runtime Image: alpine:3.21
```

**Notes:**
- Requires Docker socket mount: `-v /var/run/docker.sock:/var/run/docker.sock`
- Special considerations for Docker-in-Docker

## Helm

**Configuration:**
```
CLI Tool Name: helm
Display Name: Helm CLI
Short Name: Helm
Tool Description: Package manager for Kubernetes applications
Download URL: https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz
Binary Name: helm
Docker Image: yourusername/helm
Config Directory: helm
GitHub Repo: yourusername/helm-docker
Docs URL: https://helm.sh/docs/
Auth Required: no
Example Command: version
Base Image: alpine/curl:8.11.1
Runtime Image: alpine:3.21
```

**Notes:**
- Often used with kubectl, may want kubeconfig mount
- Download is tar.gz with subdirectories

## gcloud CLI

**Configuration:**
```
CLI Tool Name: gcloud
Display Name: Google Cloud CLI
Short Name: GCLOUD
Tool Description: Command-line interface for Google Cloud Platform
Download URL: https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
Binary Name: gcloud
Docker Image: yourusername/gcloud
Config Directory: gcloud
GitHub Repo: yourusername/gcloud-docker
Docs URL: https://cloud.google.com/sdk/docs
Auth Required: yes
Auth Command: auth login
Example Command: version
Base Image: python:3.11-alpine
Runtime Image: python:3.11-alpine
```

**Notes:**
- Requires Python runtime
- Large download, may take time to build
- Config in `~/.config/gcloud/`

## Ansible CLI

**Configuration:**
```
CLI Tool Name: ansible
Display Name: Ansible CLI
Short Name: Ansible
Tool Description: IT automation tool for configuration management
Download URL: N/A (install via pip)
Binary Name: ansible
Docker Image: yourusername/ansible
Config Directory: ansible
GitHub Repo: yourusername/ansible-docker
Docs URL: https://docs.ansible.com/
Auth Required: no
Example Command: --version
Base Image: python:3.11-alpine
Runtime Image: python:3.11-alpine
```

**Notes:**
- Installed via pip, not direct binary download
- Dockerfile needs: `RUN pip install ansible`
- SSH keys may need mounting

## vault (HashiCorp Vault CLI)

**Configuration:**
```
CLI Tool Name: vault
Display Name: Vault CLI
Short Name: Vault
Tool Description: Tool for secrets management, encryption as a service
Download URL: https://releases.hashicorp.com/vault/1.15.0/vault_1.15.0_linux_amd64.zip
Binary Name: vault
Docker Image: yourusername/vault
Config Directory: vault
GitHub Repo: yourusername/vault-docker
Docs URL: https://developer.hashicorp.com/vault/docs
Auth Required: yes
Auth Command: login
Example Command: status
Base Image: alpine/curl:8.11.1
Runtime Image: alpine:3.21
```

**Notes:**
- Download is a zip file
- Token authentication via environment or file

## Tips for Custom Tools

### Handling Different Archive Types

**Zip files:**
```dockerfile
RUN apk add --no-cache unzip && \
    curl -LO "{{DOWNLOAD_URL}}" && \
    unzip archive.zip && \
    chmod +x {{BINARY_NAME}}
```

**Tar.gz files:**
```dockerfile
RUN curl -LO "{{DOWNLOAD_URL}}" && \
    tar -xzf archive.tar.gz && \
    chmod +x {{BINARY_NAME}}
```

**Tar.gz with subdirectories:**
```dockerfile
RUN curl -LO "{{DOWNLOAD_URL}}" && \
    tar -xzf archive.tar.gz --strip-components=1 && \
    chmod +x {{BINARY_NAME}}
```

### Tools Requiring Runtime Dependencies

If your CLI tool needs Python, Node.js, or other runtimes:

**Python:**
```
Base Image: python:3.11-alpine
Runtime Image: python:3.11-alpine
```

**Node.js:**
```
Base Image: node:20-alpine
Runtime Image: node:20-alpine
```

### Tools Installed via Package Managers

For tools available via pip, npm, apt, etc., modify the Dockerfile:

```dockerfile
FROM python:3.11-alpine

RUN pip install --no-cache-dir your-tool-name

ENTRYPOINT ["your-tool-name"]
CMD ["--help"]
```

## Contributing Examples

Have a working configuration for a popular CLI tool? Please contribute by:

1. Testing your configuration
2. Adding it to this document
3. Submitting a pull request

Include any special notes or gotchas you encountered!