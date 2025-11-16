# Template Workflow Diagram

## Overview

This document visualizes how the template system works from start to finish.

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Template Repository                    │
│              (zero-to-prod/docker-wrapper-template)              │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ 1. Click "Use this template"
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     New User Repository                          │
│                  (yourusername/your-cli-tool)                    │
│                                                                   │
│  Contains:                                                        │
│  • .template.json (config schema)                                │
│  • setup.sh (setup script)                                       │
│  • *.template files                                              │
│  • Documentation                                                 │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ 2. git clone
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Local Machine                             │
│                                                                   │
│  User runs: ./setup.sh                                           │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ 3. Interactive prompts
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Setup Script Prompts                          │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ CLI Tool Name:        terraform                          │  │
│  │ Display Name:         Terraform CLI                      │  │
│  │ Download URL:         https://releases.hashicorp.com...  │  │
│  │ Docker Image:         myuser/terraform                   │  │
│  │ Auth Required:        no                                 │  │
│  │ Example Command:      version                            │  │
│  │ ...                                                      │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ 4. Variable substitution
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Template Processing                            │
│                                                                   │
│  Dockerfile.template          →  Dockerfile                      │
│    {{CLI_TOOL_NAME}}          →  terraform                       │
│    {{DOWNLOAD_URL}}           →  https://releases...             │
│    {{BINARY_NAME}}            →  terraform                       │
│                                                                   │
│  install.sh.template          →  install.sh                      │
│    {{DOCKER_IMAGE_NAME}}      →  myuser/terraform                │
│    {{AUTH_REQUIRED}}          →  false                           │
│                                                                   │
│  README.md.template           →  README.md                       │
│    Conditional blocks processed                                  │
│    All variables replaced                                        │
│                                                                   │
│  docker-compose.yml.template  →  docker-compose.yml              │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ 5. Cleanup
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Generated Repository                          │
│                                                                   │
│  Files removed:                                                  │
│  • .template.json           ✗                                   │
│  • setup.sh                 ✗                                   │
│  • *.template files         ✗                                   │
│                                                                   │
│  Files created:                                                  │
│  • Dockerfile               ✓                                   │
│  • install.sh               ✓                                   │
│  • docker-compose.yml       ✓                                   │
│  • README.md                ✓                                   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ 6. Build and test
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Docker Build                                │
│                                                                   │
│  $ docker build -t myuser/terraform .                           │
│  $ docker run --rm myuser/terraform --help                      │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ 7. Commit and push
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Published Repository                           │
│                                                                   │
│  • Working Docker image                                          │
│  • One-line installer                                            │
│  • Complete documentation                                        │
│  • Ready for end users                                           │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ 8. End users install
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      End User Installation                       │
│                                                                   │
│  $ curl -fsSL https://raw.githubusercontent.com/.../install.sh \ │
│      | bash                                                      │
│                                                                   │
│  $ terraform version                                             │
│  Terraform v1.6.0                                                │
└─────────────────────────────────────────────────────────────────┘
```

## File Transformation Flow

```
Before Setup (Template State)              After Setup (Generated State)
═══════════════════════════                ════════════════════════════

.template.json                             [DELETED]
setup.sh                                   [DELETED]

Dockerfile.template                        Dockerfile
┌────────────────────────┐                ┌────────────────────────┐
│ FROM {{BASE_IMAGE}}    │    ───→        │ FROM alpine/curl:8.11.1│
│ RUN curl {{DOWNLOAD_   │                │ RUN curl https://...   │
│   URL}}                │                │   releases.hashicorp...│
│ ENTRYPOINT ["{{BINARY_ │                │ ENTRYPOINT ["terraform"│
│   NAME}}"]             │                │   ]                    │
└────────────────────────┘                └────────────────────────┘

install.sh.template                        install.sh
┌────────────────────────┐                ┌────────────────────────┐
│ DOCKER_IMAGE="{{DOCKER_│    ───→        │ DOCKER_IMAGE="myuser/  │
│   IMAGE_NAME}}"        │                │   terraform:latest"    │
│ CONFIG_DIR="~/.config/ │                │ CONFIG_DIR="~/.config/ │
│   {{CONFIG_DIR_NAME}}" │                │   terraform.d"         │
└────────────────────────┘                └────────────────────────┘

README.md.template                         README.md
┌────────────────────────┐                ┌────────────────────────┐
│ # {{CLI_TOOL_SHORTNAME}}│    ───→       │ # TF - Terraform CLI   │
│ {{TOOL_DESCRIPTION}}   │                │ Infrastructure as Code │
│ {{#if AUTH_REQUIRED}}  │                │ [Section removed -     │
│   Auth steps...        │                │  no auth required]     │
│ {{/if}}                │                │                        │
└────────────────────────┘                └────────────────────────┘
```

## Variable Flow

```
User Input → setup.sh → Variables → Template Files → Generated Files
───────────────────────────────────────────────────────────────────

terraform  →  CLI_TOOL_NAME  →  {{CLI_TOOL_NAME}}  →  terraform
                                  in Dockerfile         in Dockerfile
                                  in install.sh         in install.sh
                                  in README.md          in README.md
                                  in compose.yml        in compose.yml
```

## Conditional Processing

```
Authentication Required Flow
════════════════════════════

AUTH_REQUIRED = true                  AUTH_REQUIRED = false
──────────────────                    ─────────────────────

README.md.template:                   README.md.template:
┌──────────────────┐                 ┌──────────────────┐
│ Before auth:     │                 │ Before auth:     │
│                  │                 │                  │
│ {{#if AUTH_      │                 │ {{#if AUTH_      │
│   REQUIRED}}     │                 │   REQUIRED}}     │
│ # Auth Setup     │  ───→  Keep     │ # Auth Setup     │  ───→  Delete
│ Step 1: Login    │                 │ Step 1: Login    │
│ ...              │                 │ ...              │
│ {{/if}}          │                 │ {{/if}}          │
│                  │                 │                  │
│ After auth:      │                 │ After auth:      │
└──────────────────┘                 └──────────────────┘
        │                                     │
        ▼                                     ▼
README.md:                            README.md:
┌──────────────────┐                 ┌──────────────────┐
│ Before auth:     │                 │ Before auth:     │
│                  │                 │                  │
│ # Auth Setup     │                 │ After auth:      │
│ Step 1: Login    │                 │                  │
│ ...              │                 │ [No auth section]│
│                  │                 │                  │
│ After auth:      │                 │                  │
└──────────────────┘                 └──────────────────┘
```

## Timeline

```
Day 0: Template Repository Created
  │
  ├─ Setup script developed
  ├─ Template files created
  ├─ Documentation written
  └─ Examples added

Day 1: User Creates Their Repository
  │
  ├─ Click "Use this template" (30 seconds)
  ├─ Clone repository (1 minute)
  ├─ Run setup script (3 minutes)
  ├─ Build Docker image (2 minutes)
  └─ Test and verify (2 minutes)

  Total time: ~8 minutes

Day 2: User Publishes
  │
  ├─ Push to GitHub (1 minute)
  ├─ Create release (1 minute)
  └─ Push to Docker Hub (optional)

Day 3+: End Users Benefit
  │
  └─ One-line installation
      curl ... | bash (30 seconds)
```

## Benefits Flow

```
┌──────────────┐
│   Template   │  → Saves setup time
│   Creator    │  → Standardizes approach
└──────────────┘  → Documents best practices
        │
        ▼
┌──────────────┐
│   Template   │  → Quick setup (5 min)
│   User       │  → Professional output
└──────────────┘  → Complete docs
        │
        ▼
┌──────────────┐
│    End       │  → One-line install
│    User      │  → No dependencies
└──────────────┘  → Consistent experience
```

## Success Path

```
Template Ready → User Configures → Wrapper Built → End Users Install → Success!
      ↓               ↓                 ↓                ↓               ↓
   ✓ Setup        ✓ Variables       ✓ Docker       ✓ Simple         ✓ Working
   ✓ Docs         ✓ Prompts         ✓ Compose      ✓ Fast           ✓ CLI Tool
   ✓ Examples     ✓ Validation      ✓ Readme       ✓ Clean          ✓ Documented
```

## Support Flow

```
Issue Detected
     │
     ├─ Template Issue?
     │    └─ Use template_issue.md
     │         └─ Report to template repo
     │
     └─ CLI Tool Issue?
          └─ Use bug_report.md
               └─ Report to wrapper repo
```

---

**Visual Guide Version**: 1.0.0
**Last Updated**: 2025-11-16
**Maintained by**: [ZeroToProd](https://github.com/zero-to-prod)