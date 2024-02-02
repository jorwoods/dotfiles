
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

select_python() {
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

venv() {
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
    "$PWD/$venv_name/bin/python" -m pip install --upgrade pip > /dev/null
    echo "$venv_name/ created. Activate with 'source $venv_name/bin/activate'"
}

activate() {
    venv_name=${1:-.venv}
    if [[ ! -d $venv_name ]]; then
        echo "$venv_name does not exist"
        return 1
    fi
    source $(pwd)/$venv_name/bin/activate
}