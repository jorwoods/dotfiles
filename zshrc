export BROWSER=sensible-browser
if [[ ! -d "$HOME/.local/bin" ]]; then
	mkdir "$HOME/.local/bin"
fi
export PATH="$HOME/.local/bin:$PATH"

function source_bash {
    bashfile="$HOME/.bashrc"
    if [[ ! -f $bashfile ]]; then
        echo "No .bashrc found"
        return 0
    fi

    # Ignore comment lines from the bashfile
    contents=grep -vE "^\s*#" $bashfile

    if [[ $contents =~ "\bzsh\b" ]]; then
        echo "$bashrc calls zsh. Not loading .bashrc"
        return 1
    fi

    source $bashfile

}
plugins=(git)


which oh-my-posh > /dev/null
if [[ $? -eq 0 ]]; then
  eval "$(oh-my-posh init zsh --config 'https://gist.githubusercontent.com/jorwoods/b9580bcdc3526a659c98de3c53158530/raw/8dfc2cab5b58c7c4fe0df61dd47ad3d314553712/.mytheme.omp.json')"
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


############################################
############################################
######### Python CONFIGURATION #############
############################################
############################################

python_folders=$(find "$HOME/programs" -type d -maxdepth 1 -name "Python-3.*" 2>/dev/null)
for folder in $python_folders; do
	version=$(echo $folder | grep -oP "Python-\K3\.\d+" )
	if [ -x "$folder/python" ]; then
    if [ ! -f "$HOME/.local/bin/python$version" ]; then
      ln -s "$folder/python" "$HOME/.local/bin/python$version"
    fi
	fi
done
# Python will put binaries for pip and other tools in the ~/.local/bin folder 

if [[ ! -d "$HOME/.virtualenvs" ]]; then
    mkdir "$HOME/.virtualenvs"
fi

if [[ ! -d "$HOME/.virtualenvs/debugpy" ]]; then
    pushd "$HOME/.virtualenvs"
    python3 -m venv debugpy
    ./debugpy/bin/python -m pip install debugpy
    popd
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

############################################
############################################
######### NEOVIM CONFIGURATION #############
############################################
############################################
# Add path and aliases for neovim if its present

if [[ ! -d "$HOME/programs/nvim-linux64" ]]; then
    if [[ ! -d "$HOME/programs" ]]; then
        mkdir "$HOME/programs"
    fi

    pushd "$HOME/programs"

    url="https://github.com/neovim/neovim/releases/download/v0.9.4/nvim-linux64.tar.gz"
    wget $url
    tar xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz

    popd
    
fi
if [[ ! -f "$HOME/.local/bin/nvim" ]]; then
	ln -s "$HOME/programs/nvim-linux64/bin/nvim" "$HOME/.local/bin/nvim"
fi
# export PATH="$HOME/programs/nvim-linux64/bin:$PATH"
alias vim="nvim"

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true
if [[ -f "$HOME/.aliases" ]]; then 
  source "$HOME/.aliases"
fi
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



################################################################################
################################################################################
################################## fzf config ##################################
################################################################################
################################################################################

 # Use the CLI fd to respect ignore files (like '.gitignore'),
# display hidden files, and exclude the '.git' directory.
export FZF_DEFAULT_COMMAND='fd . --hidden --exclude ".git" --exclude .venv'

# Use the CLI ripgrep to respect ignore files (like '.gitignore'),
# display hidden files, and exclude the '.git' directory.
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git" --glob "!.venv"'

