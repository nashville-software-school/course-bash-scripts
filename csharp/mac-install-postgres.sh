#!/bin/bash

set -e

POSTGRES_PASSWORD="devpassword"
PG_HBA_LINE="host all all 127.0.0.1/32 md5"

echo "🧰 Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "🚫 Homebrew is not installed. Please install Homebrew first."
  exit 1
fi

echo "🍺 Installing PostgreSQL (if not already installed)..."
brew install postgresql || true

echo "🚀 Starting PostgreSQL service..."
brew services start postgresql

echo "🔧 Waiting for PostgreSQL to start..."
sleep 5

# Create default database for current user if it doesn't exist
if ! psql -lqt | cut -d \| -f 1 | grep -qw "$USER"; then
  echo "📦 Creating default database for user '$USER'..."
  createdb "$USER"
fi

echo "🛠️ Creating postgres superuser and database..."
psql -v ON_ERROR_STOP=1 <<EOF
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'postgres') THEN
    CREATE ROLE postgres WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD '$POSTGRES_PASSWORD';
  END IF;
END
\$\$;

CREATE DATABASE postgres OWNER postgres;
EOF

# Enable md5 auth in pg_hba.conf if not present
echo "🔒 Configuring password authentication (md5)..."
PG_HBA=$(psql -t -P format=unaligned -c "SHOW hba_file;")
if ! grep -qF "$PG_HBA_LINE" "$PG_HBA"; then
  echo "$PG_HBA_LINE" | sudo tee -a "$PG_HBA" >/dev/null
  echo "✅ md5 authentication line added to pg_hba.conf"
else
  echo "ℹ️ md5 authentication already configured."
fi

echo "🔄 Restarting PostgreSQL..."
brew services restart postgresql

echo "✅ PostgreSQL is ready!"
echo "🔑 Connect with: psql -U postgres -d postgres"
echo "📦 Or use in code: Host=localhost;Username=postgres;Password=$POSTGRES_PASSWORD;Database=postgres"
