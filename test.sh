#!/bin/bash

set -e

echo "🧪 Running The Pymera + Shymera test suite..."
echo ""

# Clean up any existing containers
echo "🧹 Cleaning up..."
docker-compose down 2>/dev/null || true
echo ""

# Test 1: Ruff check (linting + formatting)
echo "1️⃣  Testing Ruff (linting + formatting)..."
docker-compose run --rm pymera-ruff-test
echo ""

# Test 2: Debian auto-install and execution
echo "2️⃣  Testing Debian auto-install (nightlies) and execution..."
docker-compose run --rm pymera-debian-test
echo ""

# Test 3: Alpine auto-install and execution
echo "3️⃣  Testing Alpine auto-install (apk) and execution..."
docker-compose run --rm pymera-alpine-test
echo ""

# Test 4: shellcheck and shfmt (linting + formatting)
echo "4️⃣  Testing shellcheck and shfmt (linting + formatting)..."
docker-compose run --rm shymera-shellcheck-shfmt-test
echo ""

# Test 5: Debian shell auto-install and execution
echo "5️⃣  Testing Debian shell auto-install (nightlies) and execution..."
docker-compose run --rm shymera-debian-test
echo ""

# Test 6: Alpine shell auto-install and execution
echo "6️⃣  Testing Alpine shell auto-install (apk) and execution..."
docker-compose run --rm shymera-alpine-test
echo ""

# Clean up
echo "🧹 Cleaning up..."
docker-compose down
echo ""

echo "✅ All tests passed! The Pymera + Shymera live! 🐍💀🐚👑"
