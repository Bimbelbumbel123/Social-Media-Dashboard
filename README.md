# Social Media Dashboard

A full‑stack Social Media Dashboard consisting of:
- A Ruby on Rails 8 API backend (PostgreSQL, Puma/Thruster) that exposes analytics/summary data.
- An Angular 20 frontend (Chart.js) living in the `frontend/` folder.

The application demonstrates a simple multi‑platform social media analytics view with seed data for YouTube, Instagram, and TikTok accounts.

Current local date/time for reference: 2025-11-18 09:20


## Stack Overview

- Backend:
  - Language: Ruby (Dockerfile uses Ruby 3.4.4; see `.ruby-version` if present)
  - Framework: Rails 8 (API‑only mode)
  - Database: PostgreSQL
  - Server: Puma (started via Thruster)
  - Key Gems: `rails`, `pg`, `puma`, `rack-cors`, `solid_cache`, `solid_queue`, `solid_cable`, `bootsnap`, `tailwindcss-rails` (gem present; API is configured `api_only = true`), `foreman` (for Procfile), `kamal` (optional deploy), `thruster`

- Frontend:
  - Framework: Angular 20
  - UI/Charts: Chart.js
  - Dev tooling: Angular CLI

- Monorepo structure with `Procfile` to run both backend and frontend together in development.


## API Endpoints (Backend)

- GET `/api/v1/dashboard` — returns aggregated account metrics and recent stats (7 days), as defined in `app/controllers/api/v1/dashboard/dashboard_controller.rb`.
- Health check: GET `/up` — standard Rails health endpoint.

Note: Default `root` route is not defined.


## Requirements

- Ruby: 3.4.x (Dockerfile sets `ARG RUBY_VERSION=3.4.4`)
- Bundler: latest compatible with Ruby 3.4
- Node.js: 18+ (Angular 20 recommends Node 18 or newer)
- npm: 9+ (or the version that ships with your Node LTS)
- PostgreSQL: 14+ recommended
- Git, cURL (general tooling)


## Project Structure

Top‑level layout:

```
.
├─ app/                       # Rails app code (API controllers, models, etc.)
├─ bin/                       # Rails binstubs and docker entrypoint
├─ config/                    # Rails configuration (routes, database.yml, environments)
├─ db/                        # Migrations and seeds
├─ frontend/                  # Angular application (CLI project)
├─ public/                    # Public files for Rails (if any)
├─ Dockerfile                 # Production‑oriented image (with Thruster)
├─ Procfile                   # Dev processes: rails (3001) and angular (4200)
├─ Gemfile / Gemfile.lock     # Backend dependencies
├─ package.json               # Root npm deps (tailwind/postcss used by Rails if applicable)
├─ package-lock.json
└─ README.md
```


## Setup

Clone the repository:

```
git clone <your-fork-or-origin-url>
cd Social-Media-Dashboard
```

### Backend (Rails API)

1) Install Ruby gems:

```
bundle install
```

2) Configure database (PostgreSQL):

The dev/test DBs are configured in `config/database.yml` as:
- development: `social_media_dashboard_development`
- test: `social_media_dashboard_test`

Ensure your local Postgres is running and your user can create databases. Then run:

```
bin/rails db:create db:migrate
```

Optionally load sample data:

```
bin/rails db:seed
```

3) Environment variables for backend:

- `RAILS_ENV` — defaults to development locally.
- `RAILS_MAX_THREADS` — connection pool sizing (defaults to 5 via `database.yml`).
- `DATABASE_URL` — optional; if provided, Rails will use it.
- `SOCIAL_MEDIA_DASHBOARD_DATABASE_PASSWORD` — used in production DB config.
- `RAILS_MASTER_KEY` — required for production builds (Dockerfile expects it at runtime).

TODO:
- Confirm any CORS allowed origins configuration in `config/initializers` (not found in this review).
- Confirm whether `tailwindcss-rails` is used in API mode or can be removed.

### Frontend (Angular)

1) Install Node dependencies:

```
cd frontend
npm install
```

2) Development server:

```
npm start
```

By default, Angular dev server runs on `http://localhost:4200`.

The backend (Rails) in the `Procfile` uses port `3001`. If the frontend needs to call the API during development, set up an Angular proxy (e.g., `proxy.conf.json`) or configure environment files to point to `http://localhost:3001`. A proxy file is not committed in this repo.

TODO:
- Add an Angular proxy configuration to forward `/api` to `http://localhost:3001` for local dev.


## Running the App (Development)

There are two common ways to run backend and frontend in development:

1) Using Foreman (recommended):

```
foreman start
```

This will run the two processes defined in `Procfile`:
- Rails API at `http://localhost:3001`
- Angular dev server at `http://localhost:4200`

2) Running each manually:

- Terminal A (Rails):
  ```
  bin/rails server -p 3001 -b 0.0.0.0
  ```

- Terminal B (Angular):
  ```
  cd frontend
  npm run start -- --host 0.0.0.0 --port 4200
  ```


## Building and Running with Docker (Production‑oriented)

The provided `Dockerfile` is designed for production images (works well with Kamal). For a quick local build/run:

```
docker build -t social_media_dashboard .
docker run -d \
  -p 80:80 \
  -e RAILS_MASTER_KEY=<value from config/master.key> \
  --name social_media_dashboard \
  social_media_dashboard
```

Notes:
- The image runs the Rails server via Thruster and exposes port 80.
- Ensure database connectivity via `DATABASE_URL` or production settings in `config/database.yml`.
- This container is for the backend only; the Angular app would typically be built separately and served via a web server/CDN, or integrated behind a reverse proxy. TODO: Document production hosting strategy for the Angular app.


## Scripts

Backend (common):
- `bin/rails db:create db:migrate db:seed`
- `bin/rails s` (server)
- `foreman start` (runs both processes from `Procfile`)

Procfile:
- `rails: bundle exec rails server -p 3001 -b 0.0.0.0`
- `angular: cd frontend && npm run start -- --host 0.0.0.0 --port 4200`

Frontend (`frontend/package.json`):
- `npm start` → `ng serve`
- `npm run build` → `ng build`
- `npm run watch` → `ng build --watch --configuration development`
- `npm test` → `ng test`


## Testing

- Backend (Rails): No test framework is configured by default in this repo (`rails/test_unit` is commented out). TODO: Add and document RSpec or Minitest setup.
- Frontend (Angular):
  - Unit tests: `cd frontend && npm test`


## Database and Seed Data

Sample data can be loaded via:

```
bin/rails db:seed
```

Seed content (`db/seeds.rb`) creates platforms, accounts, 7 days of stats, and a demo user. It logs counts after seeding.


## Environment Variables

- `RAILS_ENV` — Rails environment (development/test/production)
- `RAILS_MASTER_KEY` — required to run in production or to decrypt credentials
- `DATABASE_URL` — optional connection URL overriding `database.yml`
- `SOCIAL_MEDIA_DASHBOARD_DATABASE_PASSWORD` — production DB password (see `config/database.yml`)
- `RAILS_MAX_THREADS` — affects DB pool size (default 5)

Frontend specific (suggested):
- `NG_API_BASE_URL` or an Angular environment setting to point to the Rails API. TODO: add and document actual variable if/when implemented.


## Linting & Security (Backend)

Development/test gems include:
- `brakeman` — security static analysis
- `rubocop-rails-omakase` — style guide

Example runs (if configured locally):
```
bundle exec brakeman
bundle exec rubocop
```


## License

TODO: Add a LICENSE file and state the chosen license here (e.g., MIT, Apache-2.0).


## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## Notes & TODOs

- [ ] Add Angular proxy configuration for `/api` → `http://localhost:3001` during development.
- [ ] Document production deployment steps (Kamal, container orchestration, and Angular hosting strategy).
- [ ] Add a LICENSE file.
- [ ] Decide on and set up a backend test framework (RSpec or Minitest) and CI.
