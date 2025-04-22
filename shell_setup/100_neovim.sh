#! /usr/bin/env bash
debian_prerequisites() {
    # Check for missing packages
    local required_packages
    required_packages=(ninja-build gettext cmake curl build-essential)
    local missing_packages
    missing_packages=()
    for pkg in "${required_packages[@]}"; do
        if ! dpkg -l | grep -q "^ii  ${pkg} "; then
            missing_packages+=("${pkg}")
        fi
    done

    # Install missing packages if any
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        sudo apt install "${missing_packages[@]}"
    fi
}

install_neovim() {
    local nvim_version
    nvim_version="v0.11.0"

    if command -v apt &> /dev/null; then
        debian_prerequisites
    fi

    if [[ ! -d "${HOME}/programs" ]]; then
        mkdir "${HOME}/programs"
    fi
    pushd "${HOME}/programs" || exit

    if [[ ! -d "${HOME}/programs/neovim" ]]; then
        git clone https://www.github.com/neovim/neovim --depth 1
        git checkout "${nvim_version}"
    fi
    pushd neovim || exit

    # Check if the correct version is installed
    if command -v nvim &> /dev/null; then
        nvim_exec=$(command -v nvim)
        version=$("${nvim_exec}" --version | head -n 1 | awk '{print $2}')
        if [[ "${version}" != "${nvim_version}" ]]; then
            echo "Neovim version mismatch: ${version} != ${nvim_version}"
            make clean
            git fetch --tags
            git checkout "${nvim_version}"
        else
            echo "Neovim version ${version} is already installed."
            popd || exit
            return
        fi

    else
        nvim_exec="${HOME}/.local/bin/nvim"
    fi

    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install

    # Check if the installation was successful
    # This is a workaround for the fact that the nvim executable is not in the PATH
    # until the installation is complete
    if [[ -f "build/bin/nvim" && -x "build/bin/nvim" ]]; then
        echo "Neovim installed successfully."
    else
        echo "Neovim installation failed."
        popd || exit
        return
    fi
}

link_neovim() {
    if [[ ! -f "${HOME}/.local/bin/nvim" ]]; then
        ln -sf "${HOME}/programs/neovim/build/bin/nvim" "${HOME}/.local/bin/nvim"
    fi

    if command -v nvim &> /dev/null; then
        alias vim="nvim"
        export EDITOR="nvim"
        export MANPAGER='nvim +Man!'
    fi
}

main() {
    install_neovim
    link_neovim
}

main

