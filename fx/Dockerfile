FROM codercom/example-node:ubuntu

USER root

# Apt: mc, nano, PHP 8.5 (Ondrej), GitHub CLI
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    apt-get install -y --no-install-recommends mc nano software-properties-common ca-certificates && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        php8.5-cli php8.5-common php8.5-curl php8.5-intl php8.5-mbstring php8.5-readline php8.5-xml php8.5-zip && \
    mkdir -p -m 755 /etc/apt/keyrings && \
    (out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
     cat "$out" > /etc/apt/keyrings/githubcli-archive-keyring.gpg && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg) && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends gh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer (system-wide)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Deno (system-wide)
ENV DENO_INSTALL=/usr/local
RUN curl -fsSL https://deno.land/install.sh | sh

# Bun (system-wide)
ENV BUN_INSTALL=/usr/local
RUN curl -fsSL https://bun.sh/install | bash

# Claude CLI (install script may use $HOME; we copy binary to /usr/local/bin)
RUN curl -fsSL https://claude.ai/install.sh | bash || true && \
    if [ -f /root/.local/bin/claude ]; then cp /root/.local/bin/claude /usr/local/bin/claude && chmod +x /usr/local/bin/claude; fi && \
    if [ -f /root/bin/claude ]; then cp /root/bin/claude /usr/local/bin/claude && chmod +x /usr/local/bin/claude; fi

# OpenCode (same: install then ensure binary in PATH)
RUN curl -fsSL https://opencode.ai/install | bash || true && \
    if [ -f /root/.local/bin/opencode ]; then cp /root/.local/bin/opencode /usr/local/bin/opencode && chmod +x /usr/local/bin/opencode; fi && \
    if [ -f /root/bin/opencode ]; then cp /root/bin/opencode /usr/local/bin/opencode && chmod +x /usr/local/bin/opencode; fi

# Cursor Agent CLI (https://cursor.com/docs/cli)
RUN curl -fsSL https://cursor.com/install | bash || true && \
    if [ -f /root/.local/bin/cursor-agent ]; then cp /root/.local/bin/cursor-agent /usr/local/bin/cursor-agent && chmod +x /usr/local/bin/cursor-agent; fi && \
    if [ -f /root/bin/cursor-agent ]; then cp /root/bin/cursor-agent /usr/local/bin/cursor-agent && chmod +x /usr/local/bin/cursor-agent; fi

# npm global tools
RUN npm install -g @openai/codex @github/copilot

# PATH and env for all users (Deno, Bun) — append to bash profile
RUN echo '' >> /etc/profile && \
    echo '# coder-env: Deno, Bun' >> /etc/profile && \
    echo 'export DENO_INSTALL="${DENO_INSTALL:-/usr/local}"' >> /etc/profile && \
    echo 'export BUN_INSTALL="${BUN_INSTALL:-/usr/local}"' >> /etc/profile && \
    echo '[ -d "$DENO_INSTALL/bin" ] && export PATH="$DENO_INSTALL/bin:$PATH"' >> /etc/profile && \
    echo '[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"' >> /etc/profile

WORKDIR /home/coder
USER coder
