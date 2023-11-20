# Config files

Additional setup may be required besides copying in the dotfiles.

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
