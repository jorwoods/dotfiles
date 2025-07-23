#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
main(){
    local UVDIR
    local LOCALBIN
    UVDIR=$(uv python dir)
    LOCALBIN="${HOME}/.local/bin"

    # Create symlinks for pythonX.Y to uv-managed Pythons
    for ITEM in "${UVDIR}"/*
    do
        local BASEITEM
        BASEITEM=$(basename "${ITEM}")

        local FULLVERSION
        local MINORVERSION
        local DEST
        FULLVERSION=$(echo "${BASEITEM}" | cut -d'-' -f 2)
        MINORVERSION=$(echo "${FULLVERSION}" | rev | cut -f 2- -d '.' | rev)
        DEST="${LOCALBIN}/python${MINORVERSION}"

        if [[ -L "${DEST}" ]]; then
            if [[ -e "${DEST}" ]]; then
                echo "${DEST} already exists and is valid. Nothing to do."
                continue
            else
                echo "${DEST} already exists but is broken. Removing."
                rm "${DEST}"
            fi
        fi

        rm -rf "${DEST}"
        ln -s "${UVDIR}/${BASEITEM}/bin/python${MINORVERSION}" "${DEST}"
        echo "${DEST} created."
    done

    # Create symlink for python to latest uv-managed Python
    local LATESTPYTHON
    LATESTPYTHON=$(uv python find)
    DEST="${LOCALBIN}/python"

    if [[ -L "${DEST}" ]]; then
        if [[ -e "${DEST}" ]] && [[ "$(realpath "${DEST}")" == "$(realpath "${LATESTPYTHON}")" ]]; then
            # echo "${DEST} already exists and is valid. Nothing to do."
            return
        else
            echo "${DEST} already exists but is broken. Removing."
            rm "${DEST}"
        fi
    fi

    rm -rf "${DEST}"
    ln -s "${LATESTPYTHON}" "${DEST}"
    echo "${DEST} created."
}
main
