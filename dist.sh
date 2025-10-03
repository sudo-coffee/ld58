#!/usr/bin/env bash

# Project name
name="Temp Name"

# Setup
mkdir -p "dist"
temp=$(mktemp -d)
proj="$(pwd "$(dirname "$0")")"
cd "$proj"
(cd main && zip -9qr "$temp/$name.lovr" .)

# Windows
mkdir -p "$temp/windows/$name"
cp "bin/windows"/* "$temp/windows/$name/"
cat "$temp/windows/$name/lovr.exe" "$temp/$name.lovr" \
  > "$temp/windows/$name/$name.exe"
rm "$temp/windows/$name/lovr.exe"
(cd "$temp/windows" && zip -9qr "$name.zip" "$name")
mv "$temp/windows/$name.zip" "dist/$name - Windows.zip"

# Linux
mkdir -p "$temp/linux"
cp "bin/linux/lovr" "$temp/linux"
(cd "$temp/linux" && lovr --appimage-extract) > /dev/null 2>&1
cat "$temp/linux/squashfs-root/lovr" "$temp/$name.lovr" \
  > "$temp/linux/squashfs-root/lovr_cat"
mv "$temp/linux/squashfs-root/lovr_cat" "$temp/linux/squashfs-root/lovr"
chmod +x "$temp/linux/squashfs-root/lovr"
(cd "$temp/linux/squashfs-root" && appimagetool . "$proj/dist/$name - Linux") \
  > /dev/null 2>&1

# Cleanup
rm -r "$temp"
