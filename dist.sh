#!/usr/bin/env bash

# Project name
name="The Glasses Shop"

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
mkdir -p "$temp/linux/project"
cp "bin/linux"/* "$temp/linux/project/"
mv "$temp/linux/project/lovr" "$temp/linux/"
(cd "$temp/linux" && lovr --appimage-extract) > /dev/null 2>&1
cat "$temp/linux/squashfs-root/lovr" "$temp/$name.lovr" \
  > "$temp/linux/squashfs-root/lovr_cat"
mv "$temp/linux/squashfs-root/lovr_cat" "$temp/linux/squashfs-root/lovr"
mv "$temp/linux/squashfs-root"/* "$temp/linux/project/"
sed -ie '/^exec/i export LD_LIBRARY_PATH=$IMAGE_DIR:$LD_LIBRARY_PATH' \
  "$temp/linux/project/AppRun"
chmod +x "$temp/linux/project/lovr"
(cd "$temp/linux/project" && appimagetool . "$proj/dist/$name - Linux") \
  > /dev/null 2>&1

# Cleanup
rm -r "$temp"
