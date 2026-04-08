FROM codercom/enterprise-base:ubuntu

ENV NODE_VERSION=22
ENV GO_VERSION=1.24.2
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/coder/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

USER root

RUN \
    # REPOS ####################################################################
    apt-get update && \
    apt-get install -y --no-install-recommends curl wget gpg && \
    # Node repo (needed for npm tools)
    curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash - && \
    # GitHub CLI repo
    wget -qO /tmp/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
    mkdir -p -m 755 /etc/apt/keyrings && \
    install -D -m 644 /tmp/githubcli-archive-keyring.gpg /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    rm -f /tmp/githubcli-archive-keyring.gpg && \
    # SINGLE UPDATE + INSTALL ##################################################
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
        git jq ripgrep nodejs gh \
        # Chrome libs (agent-browser)
        libnspr4 libnss3 libatk-bridge2.0-0 libdrm2 libxkbcommon0 libatspi2.0-0 \
        libcups2t64 libxshmfence1 libgbm1 libpango-1.0-0 libpangocairo-1.0-0 \
        libasound2t64 libx11-xcb1 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
        libxi6 libgtk-3-0t64 libcairo2 libcairo-gobject2 libgdk-pixbuf-2.0-0 \
        libatk1.0-0 libxrender1 libfontconfig1 libdbus-1-3 libxcb1 libxext6 libx11-6 && \
    # GOLANG ####################################################################
    ARCH=$(dpkg --print-architecture) && \
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz" -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz && \
    mkdir -p /home/coder/go && \
    # CLAUDE ####################################################################
    (curl -fsSL https://claude.ai/install.sh | bash || true) && \
    mkdir -p /home/coder/.local/bin && \
    if [ -f /root/.local/bin/claude ]; then cp /root/.local/bin/claude /home/coder/.local/bin/claude; fi && \
    if [ -f /root/bin/claude ]; then cp /root/bin/claude /home/coder/.local/bin/claude; fi && \
    chmod +x /home/coder/.local/bin/claude 2>/dev/null || true && \
    ln -sf /home/coder/.local/bin/claude /usr/local/bin/claude && \
    # OPENCODE ##################################################################
    (curl -fsSL https://opencode.ai/install | bash || true) && \
    mkdir -p /home/coder/.opencode/bin && \
    if [ -f /root/.opencode/bin/opencode ]; then cp /root/.opencode/bin/opencode /home/coder/.opencode/bin/opencode; fi && \
    chmod +x /home/coder/.opencode/bin/opencode 2>/dev/null || true && \
    ln -sf /home/coder/.opencode/bin/opencode /usr/local/bin/opencode && \
    # NPM: CODEX, COPILOT #######################################################
    npm install -g @openai/codex @github/copilot && \
    # AGENT-BROWSER ##############################################################
    npm install -g agent-browser && \
    runuser -u coder -- agent-browser install && \
    # PROFILE ##################################################################
    echo '' >> /etc/profile && \
    echo '# Go' >> /etc/profile && \
    echo 'export GOROOT=/usr/local/go' >> /etc/profile && \
    echo 'export GOPATH="$HOME/go"' >> /etc/profile && \
    echo 'export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"' >> /etc/profile && \
    # OWNERSHIP ################################################################
    chown -R coder:coder /home/coder/.local /home/coder/.opencode /home/coder/go 2>/dev/null || true && \
    # CLEANUP ###################################################################
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/* \
           /root/.npm /root/.cache /root/.local /root/.opencode

WORKDIR /home/coder

USER coder
