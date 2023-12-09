#! /bin/sh

git branch --all | fzf | sed 's/remotes\/origin\///' | sed 's/\*//' | sed 's/^[ ]*//' | xargs git checkout
