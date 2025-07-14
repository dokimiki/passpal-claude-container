FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    ca-certificates \
    gnupg \
    ripgrep \
    sudo \
    tmux \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Switch to root user
USER root
WORKDIR /root/workspace

# Add Flutter and npm global bin to PATH first
ENV PATH="/root/flutter/bin:/root/.npm-global/bin:/root/.local/bin:$PATH"

# Configure npm global directory and install Claude Code
RUN npm config set prefix '/root/.npm-global' && \
    npm install -g @anthropic-ai/claude-code

# Install claude monitor
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN uv tool install claude-monitor

CMD ["claude", "--dangerously-skip-permissions"]
