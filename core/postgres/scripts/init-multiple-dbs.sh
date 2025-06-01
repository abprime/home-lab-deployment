#!/bin/bash
set -e
set -u

export PGPASSWORD="$(cat /run/secrets/postgres_password)"

echo "⏳  Waiting for PostgreSQL to accept connections …"
until pg_isready -h $POSTGRES_HOST -U $POSTGRES_USER >/dev/null 2>&1; do
  sleep 2
done
echo "✅  PostgreSQL is ready"


function create_db_if_not_exists() {
  local db="$1"
  echo "Checking if database '$db' exists..."
  if psql -h $POSTGRES_HOST -U "$POSTGRES_USER" -d $POSTGRES_DB -tAc "SELECT 1 FROM pg_database WHERE datname='${db}'" | grep -q 1; then
    echo "   • Database '$db' already exists, skipping."
  else
    echo "   • Creating database '$db' with owner '$POSTGRES_USER'..."
    psql -h $POSTGRES_HOST -U "$POSTGRES_USER" -d $POSTGRES_DB -c "CREATE DATABASE \"$db\" OWNER \"$POSTGRES_USER\";"
    echo "   • Database '$db' created successfully with owner '$POSTGRES_USER'!"
  fi
}
if [ -n "${POSTGRES_MULTIPLE_DATABASES:-}" ]; then
  echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
  for db in $(echo "$POSTGRES_MULTIPLE_DATABASES" | tr ',' ' '); do
    create_db_if_not_exists "$db"
  done
  echo "🏁  All requested databases handled."
fi