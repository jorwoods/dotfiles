get_remote() {
    local remote
    remote=$(
        git status --short --branch |
        \grep -oP "(?<=\.{3}).*(?= \[)" |
        sed 's/\/.*//'
    )
    if [[ -n "${remote}" ]]; then
        echo "${remote}"
        return 0
    fi
    local remotes
    remotes=$(git remote)
    local remote_count
    remote_count=$(echo "${remotes}" | wc -l)
    if [[ "${remote_count}" -gt 1 ]]; then
        remote=$(echo "${remotes}" | fzf)
        echo "${remote}"
        return 0
    elif [[ $remote_count -eq 1 ]]; then
        echo "${remotes}"
        return 0
    fi
}

push() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD)
    local remote
    remote=$(get_remote)
    if [[ -z "${remote}" ]]; then
        echo "No remote found"
        return 1
    fi
    local lines
    lines=$(git ls-remote --heads "${remote}" "${branch}")
    if [[ -z "${lines}" ]]; then
        git push --set-upstream "${remote}" "${branch}"
        return 0
    fi
    git push
}

clone() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: clone <repo>"
        return 1
    fi
    if [[ ! -d "${HOME}/source" ]]; then
        mkdir "${HOME}/source"
    fi

    pushd "${HOME}/source" || exit

    local dir
    dir=$(basename "$1" .git)
    if git clone gh:"$1" "$dir"; then
        echo "Cloned $1 to ${HOME}/source/$dir"
    fi
    popd || exit
}

gaf() {
    files=$(rg --files --hidden --glob "!**.git/*" | fzf -m --preview "cat {}" --preview-window=right:60% | tr "\n" " ")
    # check if files is empty
    if [[ -z "${files}" ]]; then
        return 1
    fi
    git add "${files}"
}

prune() {
    local force
    force="-d"
    while getopts "f" opt; do
        case ${opt} in
            f)
                force="-D"
                ;;
            *)
                ;;
        esac
    done

    git fetch --prune
    local branches
    branches=$(git branch -vv | awk '/: gone]/{print $1}')
    if [[ -z "${branches}" ]]; then
        echo "No branches to prune"
        return 0
    else
        branches | xargs git branch "${force}"
    fi
}
