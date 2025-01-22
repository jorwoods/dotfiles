# ZSH History
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export HISTFILESIZE=1000000000
# https://zsh.sourceforge.io/Doc/Release/Options.html
setopt SHARE_HISTORY # Share history between all sessions
setopt INC_APPEND_HISTORY # Write to history immediately, not when shell ends
setopt HIST_IGNORE_ALL_DUPS # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE # Do not record events starting with a space
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from each command line written to history
setopt HIST_SAVE_NO_DUPS # Do not write a duplicate event to the history file
setopt HIST_VERIFY # Do not execute immediately upon history expansion
setopt HIST_NO_STORE # Don't store history commands

HISTORY_IGNORE="(ls|cd|pwd|exit)*"
HIST_STAMPS="yyyy-mm-dd"

full_path=$(realpath "${HOME}/.zshrc")
dir=$(dirname ${full_path})
for file in "${dir}/shell_setup/"*; do
    if [[ -f "${file}" ]]; then
        source "${file}"
    fi
done

export PATH="${PATH}:/snap/bin/"
export NODE_EXTRA_CA_CERTS="${HOME}/windows_certs.pem"


source_bash () {
    local bashfile
    bashfile="${HOME}/.bashrc"
    if [[ ! -f "${bashfile}" ]]; then
        echo "No .bashrc found"
        return 0
    fi

    # Ignore comment lines from the bashfile
    local contents
    contents=grep -vE "^\s*#" "${bashfile}"

    if [[ $contents =~ "\bzsh\b" ]]; then
        echo "${bashrc} calls zsh. Not loading .bashrc"
        return 1
    fi

    source "${bashfile}"

}
plugins=(git fzf)


which oh-my-posh &> /dev/null && eval "$(oh-my-posh init zsh --config '~/.mytheme.omp.json')"


# SSH Agent
keys=('id_rsa')
if [[ -f "${HOME}/.ssh/github" ]]; then
    keys+=("github")
fi

eval `keychain --eval --agents ssh ${keys[*]}`

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
[[ -f ~/.config/tabtab/__tabtab.bash ]] && . ~/.config/tabtab/__tabtab.bash || true
if [[ -f "$HOME/.aliases" ]]; then
  source "$HOME/.aliases"
fi
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

eval "$(zoxide init --cmd cd zsh)"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
