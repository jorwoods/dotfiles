#!/bin/bash

# Find the virtual environment in the current directory
VENV=$(find . -type d -iname ".venv")

# Check if the virtual environment exists
if [ -z "${VENV}" ]; then
    echo "No virtual environment found in the current directory."
    exit 1
fi

# Activate the virtual environment
source "${VENV}/bin/activate"
