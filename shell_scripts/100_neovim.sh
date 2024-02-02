# Add path and aliases for neovim if its present

if [[ ! -d "$HOME/programs/nvim-linux64" ]]; then
    if [[ ! -d "$HOME/programs" ]]; then
        mkdir "$HOME/programs"
    fi

    pushd "$HOME/programs"

    url="https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz"
    wget $url
    tar xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz

    popd
    
fi
if [[ ! -f "$HOME/.local/bin/nvim" ]]; then
	ln -s "$HOME/programs/nvim-linux64/bin/nvim" "$HOME/.local/bin/nvim"
fi

alias vim="nvim"
