#! /usr/bin/env bash
set -eu

version=1.21.6

wget "https://go.dev/dl/go$version.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go$version.linux-amd64.tar.gz"

