# GitLab CLI (glab) Docker Wrapper - LLM Usage Guide

This guide is for LLMs and AI assistants helping users with the glab CLI Docker wrapper.

## Quick Reference

**Docker Image**: `davidsmith3/glab`
**GitHub**: `zero-to-prod/glab`
**Base Command**: `docker run --rm -v ~/.config/glab-cli:/root/.config/glab-cli -v $(pwd):/workspace -w /workspace davidsmith3/glab`

## Prerequisites Check

Before suggesting glab commands, verify:
1. Docker is installed and running
2. User is in a git repository
3. User has authenticated with GitLab

## Command Patterns

### Standard Format
```bash
docker run --rm \
  -v ~/.config/glab-cli:/root/.config/glab-cli \
  -v $(pwd):/workspace -w /workspace \
  davidsmith3/glab [COMMAND] [OPTIONS]
```

### Interactive Format (auth only)
```bash
docker run -it --rm -v ~/.config/glab-cli:/root/.config/glab-cli davidsmith3/glab auth login
```

### Using Alias (Recommended)
```bash
alias glab='docker run --rm -v ~/.config/glab-cli:/root/.config/glab-cli -v $(pwd):/workspace -w /workspace davidsmith3/glab'
```

## Common Commands

### Authentication
```bash
glab auth login    # First-time setup (use -it flag)
glab auth status   # Check auth status
```

### Issues
```bash
glab issue list
glab issue create --title "Title" --description "Description"
glab issue view ISSUE_NUMBER
glab issue close ISSUE_NUMBER
```

### Merge Requests
```bash
glab mr list
glab mr create
glab mr view MR_NUMBER
glab mr approve MR_NUMBER
glab mr merge MR_NUMBER
```

### Repository & Pipelines
```bash
glab repo view
glab repo clone GROUP/PROJECT
glab pipeline list
glab pipeline status
glab pipeline ci trace
```

## Critical Notes for LLMs

### Volume Mounts Are Critical

1. **Config volume** (`-v ~/.config/glab-cli:/root/.config/glab-cli`): Authentication credentials
2. **Workspace volume** (`-v $(pwd):/workspace -w /workspace`): Git repository context

**Always include both volumes** unless command is purely config-related (like `auth login`).

### When to Use `-it`

- **Use `-it`**: Interactive commands (`auth login`, `issue create` without flags, `mr create` without flags)
- **Omit `-it`**: Standard commands that don't require user input

### Common Errors

**"not a git repository"**
- Missing workspace volume or not in git repo
- Solution: Include `-v $(pwd):/workspace -w /workspace`

**"401 Unauthorized"**
- User hasn't authenticated
- Solution: Run `glab auth login` with `-it` flag

**"xdg-open: executable file not found"**
- Using `--web` flag from container
- Solution: Omit `--web` or manually open URL

**"pull access denied"**
- Wrong image name
- Solution: Use `davidsmith3/glab`, not `zero-to-prod/glab`

### Environment Variables

```bash
# Self-hosted GitLab
docker run --rm -e GITLAB_HOST=gitlab.example.com [volumes] davidsmith3/glab [COMMAND]

# Direct token (less secure)
docker run --rm -e GITLAB_TOKEN=your_token [volumes] davidsmith3/glab [COMMAND]
```

## Best Practices

1. Always provide complete commands with full volume mounts
2. Explain what the command does before suggesting it
3. Check prerequisites (Docker, git repo, auth)
4. Suggest the alias for frequent users
5. Provide context about volume mounts
6. Offer alternatives when commands might fail
7. Show expected output when helpful

## Help Commands

```bash
docker run --rm davidsmith3/glab --help              # General help
docker run --rm davidsmith3/glab [COMMAND] --help    # Command help
```

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/zero-to-prod/glab/main/install.sh | bash
```

Or manually: `docker pull davidsmith3/glab:latest`

---

**Resources:**
- Docker Hub: https://hub.docker.com/r/davidsmith3/glab
- GitHub: https://github.com/zero-to-prod/glab
- Official Docs: https://gitlab.com/docs/editor_extensions/gitlab_cli/
