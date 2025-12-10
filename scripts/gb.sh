#! /usr/bin/env bash

main() {
    local remotes
    remotes=$(git remote | sort -u)
    local branch
    branch=$(git for-each-ref --format='%(refname:short)' \
        | grep -v ^original \
        | grep -v stash \
        | grep -v HEAD \
        | fzf --preview 'git log -n5 {}'
    )
    # echo "Selected branch: ${branch}"
    if [[ -z "${branch}" ]]; then
        return
    fi
    for remote in $remotes; do
        if [[ "${branch}" =~ ^$remote/(.*)$ ]]; then
            # echo "Matching remote: ${remote}"
            branch="${BASH_REMATCH[1]}"
            break
        fi
    done

    if [[ -z "${branch}" ]]; then
        echo "No branch selected."
        return 1
    fi

    git checkout "${branch}" || {
        echo "Failed to checkout branch '${branch}'."
        return 1
    }
}

main "$@"
