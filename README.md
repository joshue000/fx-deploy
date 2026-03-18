# FXReplayChallenge — Deployment

Monorepo deployment setup for the **FXReplayChallenge** project. Orchestrates the full stack — Angular frontend, Node.js REST API, PostgreSQL database, Prometheus metrics, and Grafana dashboards — with a single command.

---

## Live Demo

| Service    | URL                                              |
|------------|--------------------------------------------------|
| Frontend   | http://3.15.46.220:4200                          |
| API        | http://3.15.46.220:3000                          |
| Swagger UI | http://3.15.46.220:3000/api/v1/docs              |
| Metrics    | http://3.15.46.220:3000/metrics                  |
| Prometheus | http://3.15.46.220:9090                          |
| Grafana    | http://3.15.46.220:3100 (admin / admin)          |

---

## Project Overview

FXReplayChallenge is a trade order management system. It allows users to create, list, update, and soft-delete trade orders across supported currency pairs (`BTCUSD`, `EURUSD`, `ETHUSD`), enforcing a price policy based on order type and side.

### Architecture

```
fx-deploy/
├── fx-back/        # REST API — Node.js 22, Express 5, Prisma 6, PostgreSQL 17
├── fx-front/       # SPA — Angular 20, served via nginx 1.27
├── docker-compose.yml
├── start.sh
├── stop.sh
└── .env.example
```

### Services

| Service    | Technology                         | Description                              |
|------------|------------------------------------|------------------------------------------|
| frontend   | Angular 20 + nginx 1.27            | Trade order management UI                |
| api        | Node.js 22 + Express 5             | REST API with business logic             |
| postgres   | PostgreSQL 17                      | Persistent relational database           |
| prometheus | Prometheus                         | Metrics collection and storage           |
| grafana    | Grafana                            | Observability dashboards                 |

---

## Requirements

| Tool        | Version      | Purpose                                      |
|-------------|--------------|----------------------------------------------|
| Docker      | 24+          | Container runtime                            |
| Docker Compose | v2+       | Multi-container orchestration                |
| Node.js     | 22 LTS       | Required on the host to run the DB seed step |
| npm         | 10+          | Package manager for the seed step            |
| curl        | any          | Used by `start.sh` to health-check the API   |

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/joshue000/fx-deploy.git
cd fx-deploy
```

### 2. Initialize submodules (first time only)

```bash
git submodule update --init --recursive
```

### 3. Grant execute permissions to the scripts (first time only)

```bash
chmod +x start.sh stop.sh
```

### 4. Install backend dependencies (required for the DB seed step)

```bash
cd fx-back && npm install && cd ..
```

### 5. Configure environment

```bash
cp .env.example .env
# Edit .env if you need to change ports or credentials
```

> The default values work out of the box — no changes required for a local run.

### 6. Start the stack

```bash
./start.sh
```

This will:
- Build the Docker images for the API and frontend
- Start PostgreSQL, the API, the frontend, Prometheus, and Grafana
- Run database migrations automatically (inside the API container)
- Seed the database with 25 sample trade orders
- Print all accessible URLs

### 7. Stop the stack

```bash
./stop.sh
```

---

## Accessible URLs

| Service       | URL                                   | Credentials   |
|---------------|---------------------------------------|---------------|
| Frontend      | http://localhost:4200                 |               |
| API           | http://localhost:3000                 |               |
| Swagger UI    | http://localhost:3000/api/v1/docs     |               |
| Health check  | http://localhost:3000/api/v1/health   |               |
| Metrics       | http://localhost:3000/metrics         |               |
| Prometheus    | http://localhost:9090                 |               |
| Grafana       | http://localhost:3100                 | admin / admin |

---

## Environment Variables

All variables have sensible defaults. Copy `.env.example` to `.env` and adjust as needed.

| Variable               | Default               | Description                              |
|------------------------|-----------------------|------------------------------------------|
| `API_PORT`             | `3000`                | Host port mapped to the API              |
| `FRONTEND_PORT`        | `4200`                | Host port mapped to the frontend         |
| `PROMETHEUS_PORT`      | `9090`                | Host port mapped to Prometheus           |
| `GRAFANA_PORT`         | `3100`                | Host port mapped to Grafana              |
| `DB_USER`              | `postgres`            | PostgreSQL username                      |
| `DB_PASSWORD`          | `postgres`            | PostgreSQL password                      |
| `DB_NAME`              | `fxreplaychallenge`   | PostgreSQL database name                 |
| `DB_PORT`              | `5432`                | Host port mapped to PostgreSQL           |
| `DATABASE_URL`         | *(derived)*           | Prisma connection string (host seeding)  |
| `RATE_LIMIT_WINDOW_MS` | `900000` (15 min)     | Rate limit window in milliseconds        |
| `RATE_LIMIT_MAX`       | `100`                 | Max requests per window per IP           |
| `GRAFANA_USER`         | `admin`               | Grafana admin username                   |
| `GRAFANA_PASSWORD`     | `admin`               | Grafana admin password                   |

---

## API Endpoints

### Health

```
GET /api/v1/health
```

### Trade Orders

| Method | Path                       | Description              |
|--------|----------------------------|--------------------------|
| GET    | /api/v1/trade_orders       | List orders (paginated)  |
| POST   | /api/v1/trade_orders       | Create a new order       |
| GET    | /api/v1/trade_orders/:id   | Get a single order       |
| PUT    | /api/v1/trade_orders/:id   | Update an order          |
| DELETE | /api/v1/trade_orders/:id   | Soft-delete an order     |

Full interactive documentation is available at **http://localhost:3000/api/v1/docs**.

### Supported pairs

`BTCUSD`, `EURUSD`, `ETHUSD`

### Price policy

| Type   | Side | Rule                           |
|--------|------|--------------------------------|
| limit  | buy  | price must be **below** market |
| limit  | sell | price must be **above** market |
| stop   | buy  | price must be **above** market |
| stop   | sell | price must be **below** market |
| market | any  | no price restriction           |

---

## Observability

- **Structured logs** — Winston (JSON in production) via Morgan, accessible via `docker compose logs api`
- **Prometheus metrics** — HTTP request duration histogram and total counter per `method/route/status_code`; default Node.js metrics included
- **Grafana dashboards** — auto-provisioned with Prometheus as the default datasource

---

## Submodules

| Submodule  | Repository                                      |
|------------|-------------------------------------------------|
| `fx-back`  | https://github.com/joshue000/fx-back.git        |
| `fx-front` | https://github.com/joshue000/fx-front.git       |

To pull the latest changes from both submodules:

```bash
git submodule update --remote --merge
```
