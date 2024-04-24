#! /bin/sh
git for-each-ref --format='%(refname:short)' \
    | grep -v ^original \
    | grep -v stash \
    | grep -v HEAD \
    | fzf --preview 'git log -n5 {}' \
    | xargs git checkout
