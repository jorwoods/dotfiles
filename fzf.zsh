# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jordan/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/jordan/bin"
fi

source <(fzf --zsh)
