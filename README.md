# Config files

Additional setup may be required besides copying in the dotfiles.

## SSL Certificates
When first setting up WSL on enterprise machines, they may be configured with
self signed certificates to allow deep packet inspection. If this is the case,
there is a python script in the scripts folder that you first have to run on
windows, and then within WSL. This will add all of the certificate bundles from
windows into WSL.

```sh
python3 win_certs.py
```

## Configuring zsh

First, install helpful CLI tools

```bash
sudo apt install zsh keychain fzf rg fd-find
```

Then, check if zsh is configured as a bootable shell.

```bash
grep $(command -v zsh) -- /etc/shells
```

If zsh is not present in /etc/shells, add it.

```bash
command -v zsh | sudo tee -a /etc/shells
```

Then, set your login shell to zsh.

```bash
chsh $(whoami) -s $(command -v zsh)
```

Then, install [Oh My Posh](https://ohmyposh.dev/docs/installation/linux).

```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```

## Installing Python
Install the Python dependencies as defined in

[Python Developer's guide](https://devguide.python.org/getting-started/setup-building/#linux).

```bash
sudo apt-get install build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev
```

Once you have downloaded the python source, cd into the directory and build it.

```bash
./configure --enable-optimizations
make -s -j$(nproc)
make altinstall
```

## Installing nodejs

Instructions lifted from [NodeJS on WSL](https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl)

First, install nvm, the "Node Version Manager"

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
```

Then, install the long term support version of NodeJS.

```bash
nvm install --lts
```

Installing node this way is crucial to have the LSPs for neovim work correctly.

## Configuring tmux

tmux is installed by default on most linux based operating systems. After
cloning this repo, tmux.conf will allow some customization of the multiplexer.

To install plugins, once in a tmux session, hit the prefix, then I. The default
prefix is C-b. 


