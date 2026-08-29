## 1. Prerequisites

- [Ruby](https://www.ruby-lang.org) version 3.3.11 (as declared in `.ruby-version`)
- [Bundler](https://bundler.io) – install with `gem install bundler`
- [PostgreSQL](https://www.postgresql.org/) (libpq-dev for the `pg` gem)
- [Docker](https://www.docker.com) (optional, for production deployment)

## 2. Clone the repository

```bash
git clone <repository-url>
cd bookshelf-manager
```

## 3. Environment setup

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` to set `DATABASE_URL` to your PostgreSQL connection (e.g., `postgres://user:pass@localhost/bookshelf_manager_development`). Alternatively, adjust `config/database.yml` directly.

## 4. Install dependencies

```bash
bundle install
```

## 5. Set up the database

Create the database, run migrations, and seed demo data (20+ books, several members, active loans). You can use the provided `install.sh` script which executes these steps, or run them manually:

```bash
bin/rails db:create db:migrate db:seed
```

## 6. Start the development server

```bash
bin/rails server
```

The application will be available at `http://localhost:3000`.

## 7. Run the test suite

```bash
bin/rails test
```

## 8. Production build

Precompile assets:

```bash
bin/rails assets:precompile
```

Build and run the Docker image:

```bash
docker build -t bookshelf-manager .
docker run -d -p 3000:3000 -e RAILS_MASTER_KEY=<your_key> bookshelf-manager
```

## 9. Troubleshooting

- **Database connection error**: Verify your PostgreSQL service is running and `DATABASE_URL` (or `config/database.yml`) is correct.
- **`pg` gem installation fails**: Install development headers – on Debian/Ubuntu: `sudo apt-get install libpq-dev`.
- **Assets not compiling**: Ensure Node.js is installed if using the Sprockets pipeline (though `importmap-rails` minimizes this).
- **Server fails to start**: Check `log/development.log` for details.