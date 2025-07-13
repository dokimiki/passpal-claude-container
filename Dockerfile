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
# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Create user with sudo privileges
RUN useradd -m -s /bin/bash claude && \
    echo 'claude ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to claude user
USER claude
WORKDIR /home/claude/workspace

# Install claude monitor
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN uv tool install claude-monitor

# Add Flutter and npm global bin to PATH first
ENV PATH="/home/claude/flutter/bin:/home/claude/.npm-global/bin:$PATH"

# Configure npm global directory and install Claude Code
RUN npm config set prefix '/home/claude/.npm-global' && \
    npm install -g @anthropic-ai/claude-code

CMD ["claude", "--dangerously-skip-permissions"]
