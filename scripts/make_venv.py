#! /usr/bin/python3
# -*- coding: utf-8 -*-

from pathlib import Path
import subprocess

home = Path.home()

python_versions = list((home / ".local" / "bin").glob("python3*"))

if len(python_versions) == 0:
    raise RuntimeError("No python3 version found in ~/.local/bin")

python_versions.sort()

print("Found python3 versions:")
for i, version in enumerate(python_versions):
    print(f"{i}: {version.name}")

while True:
    try:
        choice = int(input("Which version do you want to use? "))
    except ValueError:
        print("Please enter a number")
        continue
    try:
        python = python_versions[choice]
    except IndexError:
        print("Please enter a valid number")
        continue
    else:
        break

version_number = python.name.replace("python", "")

print(f"Using {python.name}")
try:
    subprocess.check_call([
        python, "-m", "venv", ".venv",
        "--prompt", f"{version_number} {Path.cwd().name}"
    ])
except subprocess.CalledProcessError:
    raise RuntimeError("Failed to create virtual environment")
