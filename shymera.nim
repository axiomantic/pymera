#!/bin/sh

# shfmt and shellcheck compatible - do not add spaces after # in comment sequences
# 1. Nim: 🚫 forbidden block comment begin, Shell: 😈 unholy shell block begin
#[

set -eu

# 2. Shell: 🐚 check for Nim and auto-install if needed

echo "🐚 Running in Shell mode - checking for Nim installation..."

if ! command -v nim >/dev/null 2>&1; then
	echo "❌ Nim compiler not found! Attempting to auto-install..."

	installed=false

	if command -v brew >/dev/null 2>&1; then
		echo "🍺 Detected Homebrew - installing Nim..."
		if brew install nim 2>&1 | grep -q "install"; then
			installed=true
			echo "✅ Nim installed successfully via Homebrew!"
		else
			echo "❌ Failed to install Nim via Homebrew"
		fi
	elif command -v apt-get >/dev/null 2>&1; then
		echo "📦 Detected APT - installing build tools and downloading Nim..."
		apt-get update -qq 2>/dev/null || true
		apt-get install -y -qq build-essential curl jq 2>/dev/null || true

		machine=$(uname -m)
		case "$machine" in
		x86_64)
			nim_arch="linux_x64"
			;;
		aarch64 | arm64)
			nim_arch="linux_arm64"
			;;
		armv7l)
			nim_arch="linux_armv7l"
			;;
		*)
			echo "❌ Unsupported architecture: $machine"
			nim_arch=""
			;;
		esac

		if [ -n "$nim_arch" ]; then
			echo "📥 Downloading Nim nightly for $nim_arch..."
			api_url="https://api.github.com/repos/nim-lang/nightlies/releases/tags/2025-09-25-version-2-2-0a18975472557d9d5ec1312cd44ccaa178b7f06c"

			github_token="${GITHUB_TOKEN:-${GH_TOKEN:-}}"
			if [ -n "$github_token" ]; then
				release_json=$(curl -s -H "Authorization: Bearer $github_token" "$api_url")
			else
				release_json=$(curl -s "$api_url")
			fi

			if [ -z "$release_json" ] || ! echo "$release_json" | jq empty 2>/dev/null; then
				echo "❌ Failed to fetch or parse GitHub API response"
				echo "This may be due to rate limiting. Set GITHUB_TOKEN or GH_TOKEN to avoid rate limits."
				installed=false
			else
				download_url=$(echo "$release_json" | jq -r ".assets[] | select(.name | contains(\"$nim_arch\") and endswith(\".tar.xz\")) | .browser_download_url" | head -n1)
			fi

			if [ -n "$download_url" ]; then
				tar_path="/tmp/nim.tar.xz"
				curl -L -s -o "$tar_path" "$download_url"

				echo "📦 Extracting Nim..."
				tar -xJf "$tar_path" -C /tmp

				nim_dir=$(find /tmp -maxdepth 1 -type d -name "nim-*" | head -n1)

				if [ -n "$nim_dir" ]; then
					echo "🔗 Installing Nim binaries to /usr/local/bin..."
					for binary in "$nim_dir"/bin/*; do
						binary_name=$(basename "$binary")
						dst="/usr/local/bin/$binary_name"
						rm -f "$dst"
						ln -s "$binary" "$dst"
					done

					installed=true
					version_output=$(nim --version 2>/dev/null | head -n1 || echo "unknown version")
					echo "✅ Nim installed: $version_output"
				fi
			fi
		fi
	elif command -v apk >/dev/null 2>&1; then
		echo "🏔️  Detected APK (Alpine) - installing Nim and GCC..."
		if apk add nim gcc musl-dev 2>&1 | grep -q "OK"; then
			installed=true
			echo "✅ Nim installed successfully via APK!"
		else
			echo "❌ Failed to install Nim via APK"
		fi
	fi

	if [ "$installed" = "false" ]; then
		echo "❌ No supported package manager found or installation failed!"
		echo ""
		echo "To install Nim manually:"
		echo "  • macOS: brew install nim"
		echo "  • Alpine: apk add nim gcc musl-dev"
		echo "  • Others: https://nim-lang.org/install.html"
		exit 1
	fi

	if ! command -v nim >/dev/null 2>&1; then
		echo "⚠️  Nim was installed but not found in PATH."
		echo "You may need to restart your shell or add Nim to PATH."
		exit 1
	fi
else
	echo "✓ Nim compiler found!"
fi

echo "🔄 Re-executing $(basename "$0") with Nim..."
echo ""
echo "------------------------------------------------------------"

nim c -r --hints:off "$0"
exit $?

# 3. Shell: 👻 phantom heredoc begin (unreachable, hides Nim code from shell)
# Using heredoc to make remaining content syntactically valid for shell
# shellcheck disable=SC2317
: <<'NIMCODE_SECTION'

# 4. Nim: 🚫 forbidden block comment end
]#

# 5. Nim: ✨ glorious main block begin

import strutils, os

echo "🎯 Now running in Nim!"
echo "✓ Successfully bootstrapped from Shell to Nim"
echo ""
echo "Command line arguments: ", commandLineParams()
echo "Nim version: ", NimVersion
echo ""

proc fibonacci(n: int): int =
  if n <= 1: return n
  return fibonacci(n - 1) + fibonacci(n - 2)

echo "Demo - First 10 Fibonacci numbers:"
for i in 0..9:
  echo "  F(", i, ") = ", fibonacci(i)

# 6. Nim: ✨ glorious main block end

# 7. Nim: 💀 cursed block comment begin
#[

# 8. Shell: 👻 phantom heredoc end (heredoc delimiter)
NIMCODE_SECTION

# 9. Nim: 💀 cursed block comment end
# shellcheck disable=SC2288,SC2317
]#
