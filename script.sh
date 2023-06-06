#!/bin/bash

docs="$(pwd)"/out/markdown_github/

echo "$docs"

# List of Python dependencies to check and install
dependencies=("slugify" "frontmatter")

# Loop through each dependency
for dependency in "${dependencies[@]}"; do
    # Check if the dependency is installed
    if ! python3 -c "import $dependency" &>/dev/null; then
        echo "Installing $dependency..."
        # Install the dependency using pip
        python3 -m pip install $dependency
    fi
done


script_path=$(dirname "$0")

# Execute the Python 3 script
echo "$script_path"

python3 "$script_path"/script.py