FROM alpine/curl:8.11.1 AS builder

WORKDIR /builder

# Download and extract based on archive type
# ARCHIVE_TYPE: tar.gz
# EXTRACT_PATH: bin/glab

RUN if [ "tar.gz" = "binary" ]; then \
        curl -LO "https://gitlab.com/gitlab-org/cli/-/releases/v1.77.0/downloads/glab_1.77.0_linux_amd64.tar.gz" && \
        mv $(basename "https://gitlab.com/gitlab-org/cli/-/releases/v1.77.0/downloads/glab_1.77.0_linux_amd64.tar.gz") glab && \
        chmod +x ./glab; \
    elif [ "tar.gz" = "tar.gz" ]; then \
        curl -LO "https://gitlab.com/gitlab-org/cli/-/releases/v1.77.0/downloads/glab_1.77.0_linux_amd64.tar.gz" && \
        tar -xzf *.tar.gz && \
        if [ -n "bin/glab" ]; then \
            chmod +x ./bin/glab && \
            mv ./bin/glab ./glab; \
        else \
            chmod +x ./glab; \
        fi; \
    elif [ "tar.gz" = "zip" ]; then \
        apk add --no-cache unzip && \
        curl -LO "https://gitlab.com/gitlab-org/cli/-/releases/v1.77.0/downloads/glab_1.77.0_linux_amd64.tar.gz" && \
        unzip -q *.zip && \
        if [ -n "bin/glab" ]; then \
            chmod +x ./bin/glab && \
            mv ./bin/glab ./glab; \
        else \
            chmod +x ./glab; \
        fi; \
    fi

FROM alpine:3.21

RUN apk add --no-cache git

WORKDIR /app

LABEL org.opencontainers.image.title="GLAB - GitLab CLI"
LABEL org.opencontainers.image.description="A GitLab CLI tool bringing GitLab to your command line"
LABEL org.opencontainers.image.url="https://github.com/zerotoprod/glab"
LABEL org.opencontainers.image.documentation="https://gitlab.com/docs/editor_extensions/gitlab_cli/"
LABEL org.opencontainers.image.source="https://github.com/zerotoprod/glab"
LABEL org.opencontainers.image.vendor="ZeroToProd"
LABEL org.opencontainers.image.licenses="MIT"
LABEL usage="docker run --rm -v ~/.config/glab-cli:/root/.config/glab-cli -v \$(pwd):/workspace -w /workspace zerotoprod/glab [COMMAND] [OPTIONS]"

COPY --from=builder /builder/glab /usr/local/bin/glab

ENTRYPOINT ["glab"]
CMD ["--help"]
