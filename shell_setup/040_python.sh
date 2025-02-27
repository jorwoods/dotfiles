sym_link_python(){
    local local_bin
    local_bin="${HOME}/.local/bin"

    local versions
    versions=()

    for folder in "$HOME/programs"/Python*; do
        if [[ ! -d "${folder}" ]]; then
            continue
        fi

        local version
        version="${folder##*-}"
        versions+=("${version}")
        local short_ver
        short_ver="${version%.*}"

        if [[ -x "${folder}/python" ]]; then
            if [[ ! -e "${local_bin}/python${version}" ]]; then
                ln -sf "${folder}/python" "${local_bin}/python${version}"
            fi

            if [[ ! -e "${local_bin}/python/${short_ver}" ]]; then
                ln -sf "${folder}/python" "${local_bin}/python${short_ver}"
            fi
        fi
    done

    local latest
    latest=$(printf "%s\n" "${versions[@]}" | sort -V | tail -n1)

    ln -sf "${local_bin}/python${latest}" "${local_bin}/python3"
}


select_python() {
    # Iterate over each directory in the PATH variable
    for dir in $(echo "${PATH}" | tr ":" "\n" | grep -v /mnt/c/); do
        # Find all executable files starting with 'python' in the current directory
        \find "${dir}" -name 'python*' -executable -maxdepth 1
    done 2>/dev/null |
    # Exclude 'python*-config' from the output
    grep -v config |
    # Sort the output and remove duplicate entries
    sort -u |
    # Use fzf for interactive selection
    fzf --prompt='Select python version:'
}

venv() {
    local venv_name
    venv_name=${1:-.venv}
    local py
    py=$(select_python)
    if [[ -z "${py}" ]]; then
        echo "No python version selected"
        return 1
    fi
    local version
    version=$("${py}" --version)
    local folder
    folder=$(basename "${PWD}")
    if [[ -d "${venv_name}" ]]; then
        echo "${venv_name} already exists"
        return 1
    fi
    echo "Creating virtual environment for ${version} in ${venv_name}"
    "$py" -m venv --prompt "${folder}" "${venv_name}"
    touch .gitignore &> /dev/null
    if ! grep -q "${venv_name}" .gitignore; then
        echo "Adding ${venv_name}/ to .gitignore"
        echo "${venv_name}/" >> .gitignore
    fi
    echo "Upgrading ${venv_name}'s pip"
    "$PWD/${venv_name}/bin/python" -m pip install --upgrade pip > /dev/null
    echo "${venv_name}/ created. Activate with 'source ${venv_name}/bin/activate'"
}

activate() {
    local venvs
    venvs=$(fd --hidden --no-ignore --max-depth 2 pyvenv.cfg)
    local venv_count
    venv_count=$(echo "${venvs}" | wc -l)
    if [[ "${venv_count}" -eq 0 ]]; then
        echo "No virtual environments found"
        return 1
    fi
    if [[ "${venv_count}" -eq 1 ]]; then
        source $(dirname "${venvs}")/bin/activate
        return 0
    fi
    local venv_name
    venv_name=$(echo "$venvs" | xargs -L1 dirname | fzf --prompt="Select virtual environment:")

    if [[ -n "${venv_name}" ]]; then
        source "${venv_name}/bin/activate"
    fi
}

main() {
sym_link_python > /dev/null

if [[ ! -d "$HOME/.virtualenvs" ]]; then
    mkdir "$HOME/.virtualenvs"
fi

if [[ ! -d "$HOME/.virtualenvs/debugpy" ]]; then
    pushd "$HOME/.virtualenvs" || exit
    python3 -m venv debugpy
    ./debugpy/bin/python -m pip install debugpy
    popd || exit
fi
}

main
