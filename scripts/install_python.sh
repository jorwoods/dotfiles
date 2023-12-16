#! /bin/bash

sudo apt-get install build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev fzf

if [ ! -d "$HOME/programs" ]; then
    mkdir $HOME/programs
fi

if [ ! -d "$HOME/.local/bin" ]; then
    mkdir $HOME/.local/bin
fi
pushd $HOME/programs

base_url="https://www.python.org/ftp/python"
version=$(curl $base_url | grep -oP "(3\.[0-9]+\.[0-9]+)" | sort -u | fzf -prompt "What version of Python do you want to install? ")
echo "Installing Python $version from source."

if [ ! -d "$HOME/programs/Python-$version" ];
then
    echo "Downloading Python $version"
    wget $base_url/$version/Python-$version.tgz
    tar -xvf Python-$version.tgz
    rm Python-$version.tgz
    pushd ./Python-$version

    echo "Configuring Python $version"
    ./configure --prefix=$HOME/programs/python-$version --enable-optimizations
    echo "Building Python $version"
    make -s -j$(nproc)
    echo "Installing Python $version"
    sudo make altinstall
    popd
else
    echo "Python $version already installed."
fi

short_ver=$(echo $version | grep -oP "3\.\d+")
if [ ! -f "$HOME/.local/bin/Python$short_ver" ];
then
    ln -s "$HOME/programs/Python-$version/python" "$HOME/.local/bin/python$short_ver"
else
    linked_ver=$("$HOME/.local/bin/Python$short_ver" --version)
    echo "python$short_ver already linked for $linked_ver."

fi
popd

