#!/bin/bash
set -e
set -u

echo "🔍 Checking PostgreSQL health..."

if pg_isready; then
    echo "✅ PostgreSQL is healthy"
else
    echo "❌ PostgreSQL is not healthy"
    exit 1
fi