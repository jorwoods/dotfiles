# Add path and aliases for n.tar.gz.tar.gzeovim if its present

if [[ ! -d "$HOME/programs/nvim-linux64" ]]; then
    if [[ ! -d "$HOME/programs" ]]; then
        mkdir "$HOME/programs"
    fi

    pushd "$HOME/programs"

    local arch=$(uname --machine)
    if [[ $arch =~ "(aarch64|arm64)" ]]; then
        local format="nvim-macos-arm64"
    else
        local format="nvim-linux64"
    fi


    url="https://github.com/neovim/neovim/releases/download/v0.10.0/$format.tar.gz"
    wget $url
    tar xzf "$format.tar.gz" 
    rm  "$format.tar.gz"

    popd
    
fi
if [[ ! -f "$HOME/.local/bin/nvim" ]]; then
	ln -s "$HOME/programs/$format/bin/nvim" "$HOME/.local/bin/nvim"
fi

alias vim="nvim"
