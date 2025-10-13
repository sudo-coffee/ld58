#!/usr/bin/env bash
export LD_LIBRARY_PATH=$PWD/bin/linux:$LD_LIBRARY_PATH
cd "$(dirname "$0")"
bin/linux/lovr main
