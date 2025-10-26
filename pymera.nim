#!/usr/bin/env python3

# fmt: off
#[ 1. Nim: 🚫 forbidden block comment begin
# 2. Python: 😈 unholy main block begin
# fmt: on

#!fmt: off

import sys
import subprocess
import shutil
import os
import urllib.request
import json
import tarfile
import platform

print("🐍 Running in Python mode - checking for Nim installation...")

if not shutil.which("nim"):
    print("❌ Nim compiler not found! Attempting to auto-install...")

    installed = False
    if shutil.which("brew"):
        print("🍺 Detected Homebrew - installing Nim...")
        result = subprocess.run(
            ["brew", "install", "nim"], capture_output=True, text=True
        )
        if result.returncode == 0:
            installed = True
            print("✅ Nim installed successfully via Homebrew!")
        else:
            print(f"❌ Failed to install Nim via Homebrew: {result.stderr}")
    elif shutil.which("apt-get"):
        print("📦 Detected APT - installing build tools and downloading Nim...")
        subprocess.run(
            ["apt-get", "update", "-qq"],
            capture_output=True,
            check=False,
        )
        subprocess.run(
            ["apt-get", "install", "-y", "-qq", "build-essential"],
            capture_output=True,
            check=False,
        )

        machine = platform.machine()
        nim_arch = {
            "x86_64": "linux_x64",
            "aarch64": "linux_arm64",
            "arm64": "linux_arm64",
            "armv7l": "linux_armv7l",
        }.get(machine)

        if not nim_arch:
            print(f"❌ Unsupported architecture: {machine}")
        else:
            print(f"📥 Downloading Nim nightly for {nim_arch}...")
            api_url = "https://api.github.com/repos/nim-lang/nightlies/releases/tags/2025-09-25-version-2-2-0a18975472557d9d5ec1312cd44ccaa178b7f06c"

            github_token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
            headers = {}
            if github_token:
                headers["Authorization"] = f"Bearer {github_token}"

            request = urllib.request.Request(api_url, headers=headers)
            with urllib.request.urlopen(request) as response:
                release_data = json.loads(response.read())

            download_url = None
            for asset in release_data.get("assets", []):
                name = asset.get("name", "")
                if nim_arch in name and name.endswith(".tar.xz"):
                    download_url = asset.get("browser_download_url")
                    break

            if download_url:
                tar_path = "/tmp/nim.tar.xz"
                urllib.request.urlretrieve(download_url, tar_path)

                print("📦 Extracting Nim...")
                with tarfile.open(tar_path, "r:xz") as tar:
                    tar.extractall("/tmp")

                nim_dir = None
                for item in os.listdir("/tmp"):
                    if item.startswith("nim-") and os.path.isdir(f"/tmp/{item}"):
                        nim_dir = f"/tmp/{item}"
                        break

                if nim_dir:
                    print("🔗 Installing Nim binaries to /usr/local/bin...")
                    bin_dir = f"{nim_dir}/bin"
                    for binary in os.listdir(bin_dir):
                        src = f"{bin_dir}/{binary}"
                        dst = f"/usr/local/bin/{binary}"
                        if os.path.isfile(dst) or os.path.islink(dst):
                            os.remove(dst)
                        os.symlink(src, dst)

                    installed = True
                    version = subprocess.run(
                        ["nim", "--version"],
                        capture_output=True,
                        text=True,
                        check=False,
                    )
                    print(
                        f"✅ Nim installed: {version.stdout.splitlines()[0] if version.stdout else 'unknown version'}"
                    )
    elif shutil.which("apk"):
        print("🏔️  Detected APK (Alpine) - installing Nim and GCC...")
        result = subprocess.run(
            ["apk", "add", "nim", "gcc", "musl-dev"], capture_output=True, text=True
        )
        if result.returncode == 0:
            installed = True
            print("✅ Nim installed successfully via APK!")
        else:
            print(f"❌ Failed to install Nim via APK: {result.stderr}")

    if not installed:
        print("❌ No supported package manager found or installation failed!")
        print("\nTo install Nim manually:")
        print("  • macOS: brew install nim")
        print("  • Alpine: apk add nim")
        print("  • Others: https://nim-lang.org/install.html")
        sys.exit(1)

    if not shutil.which("nim"):
        print(
            "⚠️  Nim was installed but not found in PATH. You may need to restart your shell."
        )
        sys.exit(1)
else:
    print("✓ Nim compiler found!")
print(f"🔄 Re-executing {os.path.basename(__file__)} with Nim...\n")
print("-" * 60)

result = subprocess.run(
    ["nim", "c", "-r", "--hints:off", __file__], capture_output=False
)
sys.exit(result.returncode)

#!fmt: on

# 3. Python: 😈 unholy main block end
# fmt: off
#!fmt: off
[# 4. Python: 🤮 abhorrent list begin
]# # 5. Nim: 🚫 forbidden block comment end, Python: 🤮 abhorrent list end
#[ 6. Nim: 🔥 blasphemous block comment begin
""" 7. Python: ⚠️ heretical multi-line string begin
]# # 8. Nim: 🔥 blasphemous block comment end
#!fmt: on
# fmt: on
# 9. Nim: ✨ glorious main block begin

import strutils, os

echo "🎯 Now running in Nim!"
echo "✓ Successfully bootstrapped from Python to Nim"
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

# 10. Nim: ✨ glorious main block end
#!fmt: off
#[ # 11. Nim: 💀 cursed block comment begin
"""[0 # 12. Python: ⚠️ heretical multi-line string end + 🤢 wretched zero-index begin
]# # 13. Nim: 💀 cursed block comment end, Python: 🤢 wretched zero-index end
#!fmt: on
# fmt: on
