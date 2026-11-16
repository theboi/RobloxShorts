#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
if [ "$(uname -s)-$(uname -m)" != "Darwin-arm64" ]; then
  echo "This pinned tool bundle targets this Apple Silicon Mac. See README for tool versions."
  exit 1
fi
mkdir -p .tools/bin .tools/downloads
install_tool() {
  tool_name="$1"
  tool_url="$2"
  tool_checksum="$3"
  if [ ! -f ".tools/downloads/$tool_name.zip" ]; then
    curl --fail --location --retry 3 "$tool_url" -o ".tools/downloads/$tool_name.zip"
  fi
  actual_checksum=$(shasum -a 256 ".tools/downloads/$tool_name.zip")
  actual_checksum=${actual_checksum%% *}
  if [ "$actual_checksum" != "$tool_checksum" ]; then
    echo "Checksum mismatch for $tool_name; download retained for inspection."
    exit 1
  fi
  unzip -oq ".tools/downloads/$tool_name.zip" -d .tools/bin
  chmod +x ".tools/bin/$tool_name"
}
install_tool lune https://github.com/lune-org/lune/releases/download/v0.11.1/lune-0.11.1-macos-aarch64.zip 0592c9b37c06f208f7d90e5d750e76101b9ba6191cd693ef34667f4f1f1063d4
install_tool rojo https://github.com/rojo-rbx/rojo/releases/download/v7.7.1/rojo-7.7.1-macos-aarch64.zip a702659940f6ca061a62df34aa0002ff024aa264efb859007ba890e9524753a4
install_tool stylua https://github.com/JohnnyMorganz/StyLua/releases/download/v2.6.0/stylua-macos-aarch64.zip dab9b66d340ca5ffc8225211f1dcf89b84783e09b8cbec8c518497eba81f3c42
.tools/bin/lune --version
.tools/bin/rojo --version
.tools/bin/stylua --version
