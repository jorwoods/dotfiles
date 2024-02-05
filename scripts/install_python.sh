#! /bin/bash

sudo apt-get install build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev

if [ ! -d "$HOME/programs" ]; then
    mkdir "$HOME/programs"
fi

if [ ! -d "$HOME/.local/bin" ]; then
    mkdir "$HOME/.local/bin"
fi
pushd "$HOME/programs"

base_url="https://www.python.org/ftp/python"
version=$(curl -L $base_url | grep -oP "(3\.[0-9]+\.[0-9]+)" | sort -u | fzf --prompt="What version of Python do you want to install? ")
echo "\n\nInstalling Python $version from source."

if [ ! -d "$HOME/programs/Python-$version" ];
then
    echo "Downloading Python $version"
    wget "$base_url/$version/Python-$version.tgz"
    tar -xvf "Python-$version.tgz"
    rm "Python-$version.tgz"
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
py_link="$HOME/.local/bin/python$short_ver"
if [ ! -f $py_link ];
then
    ln -s "$HOME/programs/Python-$version/python" "$py_link"
else
    linked_bin=$(realpath "$py_link")
    linked_ver=$($py_link --version)

    echo "A link for Python $short_ver already exists and points to $linked_bin ($linked_ver)."
    read -p "Do you want to overwrite this link? (Y/n) " -n 1 -r
    echo    # move to a new line
    if [[ -z $REPLY || $REPLY =~ ^[Yy]$ ]]
    then
        rm "$py_link"
        ln -s "$HOME/programs/Python-$version/python" "$py_link"
        echo "Link overwritten."
    else
        echo "Link not overwritten."
    fi

fi
popd
