#!/usr/bin/env bash
cd "$(dirname "$0")"

# Linux
o_file=$(mktemp)
gcc -c src/display.c -o $o_file -fPIC -I include || exit 1
gcc $o_file -o bin/linux/libdisplay.so -shared -lSDL3 -L bin/linux
rm $o_file

# Windows
o_file=$(mktemp)
x86_64-w64-mingw32-gcc -c src/display.c -o $o_file -fPIC -I include || exit 1
x86_64-w64-mingw32-gcc $o_file -o bin/windows/display.dll -shared \
  -L bin/windows -lSDL3
rm $o_file
