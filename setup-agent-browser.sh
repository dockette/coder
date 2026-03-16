#!/usr/bin/env bash
# Setup script for npm global directory and agent-browser installation
set -euo pipefail

# 1. Configure npm global install directory under user home
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global

# Add to PATH if not already present
if ! grep -q 'npm-global/bin' ~/.bashrc 2>/dev/null; then
  echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
fi
export PATH=~/.npm-global/bin:$PATH

# 2. Install Chrome system dependencies (Ubuntu 24.04+)
apt-get update && apt-get install -y --no-install-recommends \
    libnspr4 \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libatspi2.0-0 \
    libcups2t64 \
    libxshmfence1 \
    libgbm1 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libasound2t64 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxi6 \
    libgtk-3-0t64 \
    libcairo2 \
    libcairo-gobject2 \
    libgdk-pixbuf-2.0-0 \
    libatk1.0-0 \
    libxrender1 \
    libfontconfig1 \
    libdbus-1-3 \
    libxcb1 \
    libxext6 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# 3. Install agent-browser globally
npm install -g agent-browser

# 4. Install browser binaries (Chrome for Testing)
agent-browser install

echo "agent-browser setup complete. Run 'source ~/.bashrc' or open a new shell."
