#!/bin/bash
set -e

# ── System update ─────────────────────────────────────────────────────────────
apt-get update -y
apt-get upgrade -y

# ── Install dependencies ──────────────────────────────────────────────────────
apt-get install -y curl git

# ── Docker (official install script — includes buildx and compose plugin) ─────
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# ── Node.js 22 (required to run the DB seed step from the host) ───────────────
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs

# ── Done ──────────────────────────────────────────────────────────────────────
echo "Bootstrap complete. Docker $(docker --version), Node $(node --version)"
