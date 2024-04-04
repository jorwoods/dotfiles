# ZSH History
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS

full_path=$(realpath "$HOME/.zshrc")
dir=$(dirname $full_path)
for file in "$dir/shell_setup/"*; do
    if [[ -f $file ]]; then
        source $file
    fi
done

export PATH=$PATH:/snap/bin/


source_bash () {
    local bashfile="$HOME/.bashrc"
    if [[ ! -f $bashfile ]]; then
        echo "No .bashrc found"
        return 0
    fi

    # Ignore comment lines from the bashfile
    local contents=grep -vE "^\s*#" $bashfile

    if [[ $contents =~ "\bzsh\b" ]]; then
        echo "$bashrc calls zsh. Not loading .bashrc"
        return 1
    fi

    source $bashfile

}
plugins=(git)


which oh-my-posh > /dev/null
if [[ $? -eq 0 ]]; then
  eval "$(oh-my-posh init zsh --config '~/.mytheme.omp.json')"

fi


# SSH Agent

eval `keychain --eval --agents ssh id_rsa`
 
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true
if [[ -f "$HOME/.aliases" ]]; then 
  source "$HOME/.aliases"
fi
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

eval "$(zoxide init --cmd cd zsh)"
