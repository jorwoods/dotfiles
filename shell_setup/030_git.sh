get_remote() {
    remote=$(
        git status --short --branch | 
        grep -oP "(?<=\.{3}).*(?= \[)" |
        sed 's/\/.*//'
    )
    if [[ ! -z $remote ]]; then
        echo "$remote"
        return 0
    fi
    remotes=$(git remote)
    remote_count=$(echo "$remotes" | wc -l)
    if [[ $remote_count -gt 1 ]]; then
        remote=$(echo "$remotes" | fzf)
        echo "$remote"
        return 0
    elif [[ $remote_count -eq 1 ]]; then
        echo "$remotes"
        return 0
    fi
}

push() {
    branch=$(git rev-parse --abbrev-ref HEAD)
    remote=$(get_remote)
    if [[ -z $remote ]]; then
        echo "No remote found"
        return 1
    fi
    lines=$(git ls-remote --heads $remote $branch)
    if [[ -z $lines ]]; then
        git push --set-upstream $remote $branch
        return 0
    fi
    git push
}

clone() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: clone <repo>"
        return 1
    fi
    if [[ ! -d "$HOME/source" ]]; then
        mkdir "$HOME/source"
    fi

    pushd "$HOME/source"

    dir=$(basename $1 .git)
    git clone gh:"$1" "$dir"
    if [[ $? -eq 0 ]]; then
        echo "Cloned $1 to $HOME/source/$dir"
    fi
    popd
}
