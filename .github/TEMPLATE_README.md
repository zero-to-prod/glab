# CLI Docker Wrapper GitHub Template

This is a GitHub template repository for creating Docker-wrapped CLI tools. It provides a complete, production-ready setup with:

- Interactive setup script
- Parameterized Dockerfile
- One-line installation for end users
- Comprehensive documentation
- Security best practices

## For Template Users

If you're using this template to create your own CLI wrapper:

1. **Click "Use this template"** on GitHub to create your repository
2. **Clone your new repository** locally
3. **Run the setup script**: `./setup.sh`
4. **Follow the prompts** to configure your CLI tool
5. **Test and customize** as needed
6. **Push to GitHub** and share!

For detailed instructions, see [TEMPLATE_USAGE.md](../TEMPLATE_USAGE.md)

## For Contributors

Contributions to improve this template are welcome! Please:

1. Test your changes with multiple CLI tool types
2. Ensure cross-platform compatibility (macOS/Linux)
3. Update documentation for any new features
4. Add examples to EXAMPLE_TOOLS.md

## Template Features

### Automated Setup
- Interactive configuration script
- Variable substitution in all template files
- Conditional content based on authentication requirements
- Cross-platform support (macOS/Linux)

### Generated Files
- `Dockerfile` - Containerized CLI tool
- `install.sh` - One-line installation script
- `docker-compose.yml` - Compose configuration
- `README.md` - Complete documentation

### Best Practices
- Minimal base images (Alpine)
- Proper volume mounts for configuration
- Security considerations documented
- Shell aliases for convenience

## Structure

```
.
├── .github/
│   └── TEMPLATE_README.md    # This file
├── .template.json            # Configuration schema
├── setup.sh                  # Setup script
├── Dockerfile.template       # Parameterized Dockerfile
├── install.sh.template       # Parameterized installer
├── docker-compose.yml.template
├── README.md.template        # Parameterized docs
├── TEMPLATE_USAGE.md         # Usage guide
├── EXAMPLE_TOOLS.md          # Example configurations
└── [Standard files]          # LICENSE, CONTRIBUTING, etc.
```

## Template Variables

See `.template.json` for the complete list of configurable variables.

Key variables:
- `CLI_TOOL_NAME` - Command name
- `DOWNLOAD_URL` - Binary download location
- `DOCKER_IMAGE_NAME` - Docker Hub image name
- `AUTH_REQUIRED` - Whether authentication is needed

## Maintenance

This template is maintained by [ZeroToProd](https://github.com/zero-to-prod).

### Reporting Issues

- Template bugs: Open issue in template repository
- Generated wrapper issues: Check your configuration first

### Suggesting Improvements

We welcome suggestions for:
- Additional CLI tool examples
- Documentation improvements
- Setup script enhancements
- New template variables

## License

MIT License - See LICENSE.md for details.