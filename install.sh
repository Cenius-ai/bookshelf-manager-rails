#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "=== BookShelf: Install ==="
echo ""

echo "→ Installing Ruby dependencies..."
bundle install --quiet

echo "→ Setting up database (create, migrate, seed)..."
ruby bin/rails db:prepare

echo "→ Seeding demo data..."
ruby bin/rails db:seed

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Start the server:"
echo "  bundle exec rails server -b 0.0.0.0 -p \${PORT:-3000}"
echo ""
echo "Demo account: cenius@cenius.ai / cenius"
