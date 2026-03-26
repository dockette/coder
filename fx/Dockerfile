FROM codercom/enterprise-base:ubuntu

ENV DENO_INSTALL=/usr/local
ENV BUN_INSTALL=/usr/local
ENV NODE_VERSION=22

USER root

RUN apt update && apt dist-upgrade -y && \
    mkdir -p -m 755 /etc/apt/keyrings && \
    apt install -y curl git wget htop jq && \
    # NODE ######################################################################
    curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash - && \
    apt install -y nodejs && \
    # PHP #######################################################################
    add-apt-repository -y ppa:ondrej/php && \
    apt update -y && \
    apt install -y --no-install-recommends \
        php8.5-cli php8.5-common php8.5-curl php8.5-gd php8.5-imap php8.5-intl \
        php8.5-mailparse php8.5-mbstring php8.5-mysql php8.5-pgsql php8.5-phpdbg \
        php8.5-readline php8.5-redis php8.5-soap php8.5-sqlite3 php8.5-xml \
        php8.5-zip php8.5-bcmath php8.5-apcu php8.5-imagick && \
    echo 'variables_order = "EGPCS"' > /etc/php/8.5/cli/conf.d/99-coder.ini && \
    # COMPOSER ##################################################################
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # GITHUB CLI ################################################################
    wget -qO /tmp/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
    install -D -m 644 /tmp/githubcli-archive-keyring.gpg /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    apt update -y && \
    apt install -y --no-install-recommends gh && \
    # DENO ######################################################################
    curl -fsSL https://deno.land/install.sh | sh && \
    # BUN #######################################################################
    curl -fsSL https://bun.sh/install | bash && \
    # CLAUDE ####################################################################
    (curl -fsSL https://claude.ai/install.sh | bash || true) && \
    if [ -f /root/.local/bin/claude ]; then cp /root/.local/bin/claude /usr/local/bin/claude && chmod +x /usr/local/bin/claude; fi && \
    if [ -f /root/bin/claude ]; then cp /root/bin/claude /usr/local/bin/claude && chmod +x /usr/local/bin/claude; fi && \
    # OPENCODE ##################################################################
    (curl -fsSL https://opencode.ai/install | bash || true) && \
    if [ -f /root/.opencode/bin/opencode ]; then cp /root/.opencode/bin/opencode /usr/local/bin/opencode && chmod +x /usr/local/bin/opencode; fi && \
    # NPM: CODEX, COPILOT #######################################################
    npm install -g @openai/codex @github/copilot && \
    # CHROME LIBS (AGENT-BROWSER) ###############################################
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libnspr4 libnss3 libatk-bridge2.0-0 libdrm2 libxkbcommon0 libatspi2.0-0 \
        libcups2t64 libxshmfence1 libgbm1 libpango-1.0-0 libpangocairo-1.0-0 \
        libasound2t64 libx11-xcb1 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
        libxi6 libgtk-3-0t64 libcairo2 libcairo-gobject2 libgdk-pixbuf-2.0-0 \
        libatk1.0-0 libxrender1 libfontconfig1 libdbus-1-3 libxcb1 libxext6 libx11-6 && \
    npm install -g agent-browser && \
    agent-browser install && \
    # PROFILE (DENO, BUN PATH) ##################################################
    echo '' >> /etc/profile && \
    echo '# Deno, Bun' >> /etc/profile && \
    echo 'export DENO_INSTALL="${DENO_INSTALL:-/usr/local}"' >> /etc/profile && \
    echo 'export BUN_INSTALL="${BUN_INSTALL:-/usr/local}"' >> /etc/profile && \
    echo '[ -d "$DENO_INSTALL/bin" ] && export PATH="$DENO_INSTALL/bin:$PATH"' >> /etc/profile && \
    echo '[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"' >> /etc/profile && \
    # CLEANUP ###################################################################
    apt clean -y && \
    apt autoclean -y && \
    apt remove -y wget && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

WORKDIR /home/coder

USER coder

RUN agent-browser install
