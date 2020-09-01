#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "run as root"
  exit
fi
echo hello

