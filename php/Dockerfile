FROM codercom/enterprise-base:ubuntu

ENV NODE_VERSION=22

USER root

RUN \
    # REPOS ####################################################################
    apt-get update && \
    apt-get install -y --no-install-recommends curl wget software-properties-common gpg && \
    # Node repo (needed for npm tools)
    curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash - && \
    # PHP repo
    add-apt-repository -y ppa:ondrej/php && \
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
        git jq ripgrep nodejs \
        # PHP
        php8.5-cli php8.5-common php8.5-curl php8.5-gd php8.5-imap php8.5-intl \
        php8.5-mailparse php8.5-mbstring php8.5-mysql php8.5-pgsql php8.5-phpdbg \
        php8.5-readline php8.5-redis php8.5-soap php8.5-sqlite3 php8.5-xml \
        php8.5-zip php8.5-bcmath php8.5-apcu php8.5-imagick \
        # GitHub CLI
        gh \
        # Chrome libs (agent-browser)
        libnspr4 libnss3 libatk-bridge2.0-0 libdrm2 libxkbcommon0 libatspi2.0-0 \
        libcups2t64 libxshmfence1 libgbm1 libpango-1.0-0 libpangocairo-1.0-0 \
        libasound2t64 libx11-xcb1 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
        libxi6 libgtk-3-0t64 libcairo2 libcairo-gobject2 libgdk-pixbuf-2.0-0 \
        libatk1.0-0 libxrender1 libfontconfig1 libdbus-1-3 libxcb1 libxext6 libx11-6 && \
    echo 'variables_order = "EGPCS"' > /etc/php/8.5/cli/conf.d/99-coder.ini && \
    # COMPOSER ##################################################################
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
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
    # OWNERSHIP ################################################################
    chown -R coder:coder /home/coder/.local /home/coder/.opencode 2>/dev/null || true && \
    # CLEANUP ###################################################################
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get remove -y wget software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/* \
           /root/.npm /root/.cache /root/.local /root/.opencode

WORKDIR /home/coder

USER coder
