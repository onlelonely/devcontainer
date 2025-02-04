#!/bin/bash
set -euo pipefail
source utils.sh

# Function to add a package under a specified category to setup_extended.sh
function add_to_setup_extended() {
    local package=$1
    local category="${2:-New packages}"
    local setup_file="setup_extended.sh"
    
    # Check if the category header already exists; if not, create it
    if ! grep -q "# Category: ${category}" "$setup_file"; then
        echo -e "\n# Category: ${category}" >> "$setup_file"
        echo "install_packages install -y -n base \\\\" >> "$setup_file"
    fi
    
    # Append the package to the category section
    sed -i "/# Category: ${category}/a\    ${package} \\\\" "$setup_file"
    echo "Added $package to $setup_file under 'Category: ${category}' section"
    echo "Don't forget to move it to the appropriate category if needed!"
}

function remove_from_setup_extended() {
    local package=$1
    local setup_file="setup_extended.sh"
    
    # Remove package from setup_extended.sh
    sed -i "/$package/d" "$setup_file"
    
    # Clean up empty install commands and leftover backslashes
    sed -i '/micromamba install -y -n base \\$/d' "$setup_file"
    sed -i '/^[[:space:]]*\\$/d' "$setup_file"
    
    echo "Removed $package from $setup_file"
}

# Utility function to extract optional category and package from input.
# Usage:
#   Input: "r:ggplot2"  -> Output: "r:ggplot2"
#   Input: "numpy"      -> Output: "New packages:numpy"
function parse_package_input() {
    local input=$1
    if [[ "$input" == *":"* ]]; then
        # Expecting format <category>:<package>
        local category=$(echo "$input" | cut -d':' -f1)
        local package=$(echo "$input" | cut -d':' -f2-)
        echo "$category:$package"
    else
        echo "New packages:$input"
    fi
}

case "$1" in
    "install")
        if [ -z "${2-}" ]; then
            echo "Usage: $0 install <category:package> [-s|--save]"
            exit 1
        fi
        
        # Parse input to separate category and package name
        parsed=$(parse_package_input "$2")
        category="${parsed%%:*}"
        package="${parsed#*:}"
        
        # Use the retry-enabled install_packages function
        install_packages install -y -n base "$package"
        
        # Check for save flag and add package to the correct category section in setup_extended.sh
        if [[ "${3-}" == "-s" ]] || [[ "${3-}" == "--save" ]]; then
            add_to_setup_extended "$package" "$category"
        else
            echo "Package installed. Use -s or --save flag to add to setup_extended.sh"
        fi
        ;;
        
    "clean")
        micromamba clean --all --yes
        ;;
        
    "remove")
        if [ -z "${2-}" ]; then
            echo "Usage: $0 remove <category:package> [-s|--save]"
            exit 1
        fi
        
        # Support optional category in removal (only the package name is significant)
        parsed=$(parse_package_input "$2")
        package="${parsed#*:}"
        
        # Use the retry-enabled removal function
        remove_packages "$package"
        
        # Check for save flag to remove from setup_extended.sh
        if [[ "${3-}" == "-s" ]] || [[ "${3-}" == "--save" ]]; then
            remove_from_setup_extended "$package"
        else
            echo "Package removed. Use -s or --save flag to remove from setup_extended.sh"
        fi
        ;;
        
    "refresh")
        rm -f ~/.devcontainer_initialized
        bash setup_core.sh
        bash setup_extended.sh
        ;;
        
    *)
        echo "Usage: $0 {install|clean|remove|refresh}"
        echo "  install <category:package> [-s|--save] : Install a new package (optionally add to setup_extended.sh)"
        echo "  clean                                  : Clean all package caches"
        echo "  remove <category:package> [-s|--save]    : Remove a specific package (optionally remove from setup_extended.sh)"
        echo "  refresh                                : Full environment refresh"
        exit 1
        ;;
esac