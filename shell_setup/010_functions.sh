function fcd() {
    dir_=$(fdfind --type d | fzf --preview "ls -lh {}" --preview-window=right:50%)
    if [[ -n $dir_ ]]; then
        cd $dir_
    fi
}
