FROM codercom/enterprise-base:ubuntu

ENV DENO_INSTALL=/usr/local
ENV BUN_INSTALL=/usr/local
ENV NODE_VERSION=24
ENV GO_VERSION=1.26.5
ENV GLAB_VERSION=1.108.0
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/coder/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Rootless Docker (docker-in-docker without privileged root)
ENV XDG_RUNTIME_DIR=/run/user/1000
ENV DOCKER_HOST=unix:///run/user/1000/docker.sock

USER root

# Helper to bring up the rootless Docker daemon at workspace start
COPY --chmod=0755 dockerd-rootless-start.sh /usr/local/bin/dockerd-rootless-start

RUN \
    # REPOS ####################################################################
    # Add all package repos first, then do a single apt-get update
    apt-get update && \
    apt-get install -y --no-install-recommends curl wget software-properties-common gpg && \
    # Node repo
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
        git jq ripgrep \
        # Node
        nodejs \
        # PHP
        php8.5-cli php8.5-common php8.5-curl php8.5-gd php8.5-imap php8.5-intl \
        php8.5-mailparse php8.5-mbstring php8.5-mysql php8.5-pgsql php8.5-phpdbg \
        php8.5-readline php8.5-redis php8.5-soap php8.5-sqlite3 php8.5-xml \
        php8.5-zip php8.5-bcmath php8.5-apcu php8.5-imagick \
        php8.5-xdebug php8.5-pcov \
        php8.5-igbinary php8.5-gmp php8.5-ldap \
        php8.5-amqp php8.5-memcache php8.5-memcached php8.5-xsl php8.5-yaml \
        # Python
        python3 python3-pip python3-venv \
        # Rootless Docker (docker-ce is already in the base image)
        docker-ce-rootless-extras uidmap dbus-user-session fuse-overlayfs slirp4netns \
        # GitHub CLI
        gh \
        # Chrome libs (agent-browser)
        libnspr4 libnss3 libatk-bridge2.0-0 libdrm2 libxkbcommon0 libatspi2.0-0 \
        libcups2t64 libxshmfence1 libgbm1 libpango-1.0-0 libpangocairo-1.0-0 \
        libasound2t64 libx11-xcb1 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
        libxi6 libgtk-3-0t64 libcairo2 libcairo-gobject2 libgdk-pixbuf-2.0-0 \
        libatk1.0-0 libxrender1 libfontconfig1 libdbus-1-3 libxcb1 libxext6 libx11-6 && \
    echo 'variables_order = "EGPCS"' > /etc/php/8.5/cli/conf.d/99-coder.ini && \
    # GOLANG ####################################################################
    ARCH=$(dpkg --print-architecture) && \
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz" -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz && \
    mkdir -p /home/coder/go && \
    # COMPOSER ##################################################################
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # GLAB (GitLab CLI) ########################################################
    curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_$(dpkg --print-architecture).deb" -o /tmp/glab.deb && \
    dpkg -i /tmp/glab.deb && \
    rm -f /tmp/glab.deb && \
    # DENO ######################################################################
    curl -fsSL https://deno.land/install.sh | sh && \
    # BUN #######################################################################
    curl -fsSL https://bun.sh/install | bash && \
    # CLAUDE ####################################################################
    # Install into /usr/local/bin (image layer) so the binary survives the
    # persistent /home/coder volume that Coder mounts over the home dir at runtime.
    (curl -fsSL https://claude.ai/install.sh | bash || true) && \
    if [ -f /root/.local/bin/claude ]; then cp /root/.local/bin/claude /usr/local/bin/claude; fi && \
    if [ -f /root/bin/claude ]; then cp /root/bin/claude /usr/local/bin/claude; fi && \
    chmod 0755 /usr/local/bin/claude && \
    # OPENCODE ##################################################################
    (curl -fsSL https://opencode.ai/install | bash || true) && \
    if [ -f /root/.opencode/bin/opencode ]; then cp /root/.opencode/bin/opencode /usr/local/bin/opencode; fi && \
    chmod 0755 /usr/local/bin/opencode && \
    # NPM: CODEX, COPILOT #######################################################
    npm install -g @openai/codex @github/copilot && \
    # PNPM ######################################################################
    npm install -g pnpm && \
    # AGENT-BROWSER ##############################################################
    npm install -g agent-browser && \
    runuser -u coder -- agent-browser install && \
    # PROFILE (DENO, BUN PATH) ##################################################
    echo '' >> /etc/profile && \
    echo '# Go' >> /etc/profile && \
    echo 'export GOROOT=/usr/local/go' >> /etc/profile && \
    echo 'export GOPATH="$HOME/go"' >> /etc/profile && \
    echo 'export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"' >> /etc/profile && \
    echo '' >> /etc/profile && \
    echo '# Deno, Bun' >> /etc/profile && \
    echo 'export DENO_INSTALL="${DENO_INSTALL:-/usr/local}"' >> /etc/profile && \
    echo 'export BUN_INSTALL="${BUN_INSTALL:-/usr/local}"' >> /etc/profile && \
    echo '[ -d "$DENO_INSTALL/bin" ] && export PATH="$DENO_INSTALL/bin:$PATH"' >> /etc/profile && \
    echo '[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"' >> /etc/profile && \
    echo '' >> /etc/profile && \
    echo '# Rootless Docker' >> /etc/profile && \
    echo 'export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"' >> /etc/profile && \
    echo 'export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"' >> /etc/profile && \
    # OWNERSHIP (coder can upgrade tools) ######################################
    chown coder:coder /usr/local/bin/claude /usr/local/bin/opencode 2>/dev/null || true && \
    chown -R coder:coder /home/coder/go 2>/dev/null || true && \
    # CLEANUP ###################################################################
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get remove -y wget software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/* \
           /root/.npm /root/.cache /root/.local /root/.opencode /root/.bun

WORKDIR /home/coder

USER coder
