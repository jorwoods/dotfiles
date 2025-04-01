nvim_version="v0.11.0"
nvim_install_dir="${HOME}/programs/nvim-linux64"
nvim_exec="${nvim_install_dir}/bin/nvim"

if [[ -f "${nvim_exec}" ]]; then
    version=$("${nvim_exec}" --version | head -n 1 | awk '{print $2}')
    if [[ "${version}" != "${nvim_version}" ]]; then
        echo "Neovim version mismatch: ${version} != ${nvim_version}"
        rm -rf "${nvim_install_dir}"
    fi
fi

if [[ ! -d "${nvim_install_dir}" ]]; then
    if [[ ! -d "${HOME}/programs" ]]; then
        mkdir "${HOME}/programs"
    fi

    pushd "${HOME}/programs" || exit

    arch=$(uname --machine)
    if [[ "${arch}" =~ (aarch64|arm64) ]]; then
        format="nvim-macos-arm64"
    else
        format="nvim-linux-x86_64"
    fi


    url="https://github.com/neovim/neovim/releases/download/${nvim_version}/${format}.tar.gz"
    wget "${url}"
    tar xzf "${format}.tar.gz"
    rm  "${format}.tar.gz"

    popd || exit

fi
if [[ ! -f "${HOME}/.local/bin/nvim" ]]; then
	ln -sf "${HOME}/programs/${format}/bin/nvim" "${HOME}/.local/bin/nvim"
fi

if command -v nvim &> /dev/null; then
    alias vim="nvim"
    export EDITOR="nvim"
    export MANPAGER='nvim +Man!'
fi
