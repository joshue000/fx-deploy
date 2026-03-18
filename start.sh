#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Environment setup ─────────────────────────────────────────────────────────
if [[ ! -f "$ROOT_DIR/.env" ]]; then
  echo "No .env file found — copying from .env.example..."
  cp "$ROOT_DIR/.env.example" "$ROOT_DIR/.env"
fi

# ── Build and start all services ──────────────────────────────────────────────
echo "Starting FXReplayChallenge full stack..."
docker compose -f "$ROOT_DIR/docker-compose.yml" up -d --build

# ── Wait for the API to be ready ──────────────────────────────────────────────
echo "Waiting for the API to be ready..."
RETRIES=30
until curl -sf http://localhost:3000/api/v1/health > /dev/null 2>&1; do
  RETRIES=$((RETRIES - 1))
  if [[ $RETRIES -le 0 ]]; then
    echo "ERROR: API did not become ready in time."
    docker compose -f "$ROOT_DIR/docker-compose.yml" logs api
    exit 1
  fi
  sleep 2
done

# ── Seed the database ─────────────────────────────────────────────────────────
echo "Seeding the database with sample data..."
cd "$ROOT_DIR/fx-back" && npm run prisma:seed

echo ""
echo "Stack is running:"
echo "  Frontend:   http://localhost:4200"
echo "  API:        http://localhost:3000"
echo "  Swagger:    http://localhost:3000/api/v1/docs"
echo "  Metrics:    http://localhost:3000/metrics"
echo "  Prometheus: http://localhost:9090"
echo "  Grafana:    http://localhost:3100  (admin / admin)"
