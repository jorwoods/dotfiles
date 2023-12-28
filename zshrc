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


function clone {
    if [[ $# -eq 0 ]]; then
        echo "Usage: clone <repo>"
        return 1
    fi
    if [[ ! -d "$HOME/source" ]]; then
        mkdir "$HOME/source"
    fi

    pushd "$HOME/source"

    dir=$(basename $1 .git)
    git clone gh:$#
    if [[ $? -eq 0 ]]; then
        echo "Cloned $1 to $HOME/source/$dir"
    fi
    popd
}


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

function select_python {
    # Iterate over each directory in the PATH variable
    for dir in $(echo $PATH | tr ":" "\n" | grep -v /mnt/c/); do
        # Find all executable files starting with 'python' in the current directory
        find $dir -name 'python*' -executable -maxdepth 1
    done 2>/dev/null | 
    # Exclude 'python*-config' from the output
    grep -v config | 
    # Sort the output and remove duplicate entries
    sort -u | 
    # Use fzf for interactive selection
    fzf --prompt='Select python version:'
}

function venv {
    venv_name=${1:-.venv}
    py=$(select_python)
    if [[ -z $py ]]; then
        echo "No python version selected"
        return 1
    fi
    version=$($py --version)
    folder=$(basename $PWD)
    if [[ -d $venv_name ]]; then
        echo "$venv_name already exists"
        return 1
    fi
    echo "Creating virtual environment for $version in $venv_name"
    $py -m venv --prompt "$folder" $venv_name
    touch .gitignore > /dev/null 2>&1
    if grep -L $venv_name .gitignore; then
        echo "Adding $venv_name/ to .gitignore"
        echo "$venv_name/" >> .gitignore
    fi
    echo "Upgrading $venv_name's pip"
    $(pwd)/$venv_name/bin/python -m pip install --upgrade pip > /dev/null
    echo "$venv_name/ created. Activate with 'source $venv_name/bin/activate'"
}

function activate {
    venv_name=${1:-.venv}
    if [[ ! -d $venv_name ]]; then
        echo "$venv_name does not exist"
        return 1
    fi
    source $(pwd)/$venv_name/bin/activate
}

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

