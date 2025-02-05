#!/bin/bash
set -euo pipefail

# Ask for the project name
project_base="project"
read -p "Enter your project name: " project_name
script_project="$(realpath ${project_base}/${project_name})"

project_base="project"
script_project="${project_base}/${project_name}"

# Create project folder structure within the workspace
mkdir -p "${script_project}/src/"
mkdir -p "${script_project}/generated_data/"
mkdir -p "${script_project}/notebooks/"
mkdir -p "${script_project}/scripts/"

# Initialize a git repository if one doesn't already exist
if [ ! -d "${script_project}/.git" ]; then
    cd "${script_project}"
    git init
    cd ..
    echo "Initialized a new Git repository in ${project_name}/"
else
    echo "Git repository already exists in ${project_name}/"
fi

# Create a .gitignore file with entries for folders that should be ignored
gitignore_file="${script_project}/.gitignore"
if [ ! -f "$gitignore_file" ]; then
    cat <<EOF > "$gitignore_file"
# Common Python and system files
__pycache__/
*.py[cod]
*.so
.DS_Store
# Ignore generated data folder
generated_data/
EOF
    echo "Created .gitignore in ${project_name}/"
else
    echo ".gitignore already exists in ${project_name}/"
fi

# Create a .pre-commit-config.yaml for pre-commit hooks for R and Python
cat <<'EOF' > "${script_project}/.pre-commit-config.yaml"
repos:
  - repo: https://github.com/psf/black
    rev: 23.1.0  # Use the version appropriate for your project
    hooks:
      - id: black
        language_version: python3

  - repo: local
    hooks:
      - id: r-lintr
        name: "Run R lintr on staged R files"
        entry: Rscript -e "if(length(lintr::lint(commandArgs(trailingOnly = TRUE))) > 0) quit(status=1)"
        language: system
        files: "\\.R$"
EOF
echo "Created .pre-commit-config.yaml in ${script_project}/"

# Optionally, create a basic README.md
read -p "Would you like to create a README.md for the project? (y/n): " create_readme
if [[ "$create_readme" =~ ^[Yy]$ ]]; then
    read -p "Enter a short project description: " description
    cat <<EOF > "${script_project}/README.md"
# ${project_name}

${description}

## Project Structure

- src/        : Source code
- data/       : Data files and datasets
- notebooks/  : Jupyter notebooks
- scripts/    : Utility scripts

EOF
    echo "README.md created for ${script_project}"
fi

# -------------------------------------------
# Create project-related folders and setting files in permanent_storage
# -------------------------------------------
ps_base="permanent_storage"
ps_project="${ps_base}/${project_name}"

# Create the base persistent storage folder (if not already there) and
# specific subdirectories for configurations, data, logs, and models.
mkdir -p "${ps_project}/config"
mkdir -p "${ps_project}/data"
mkdir -p "${ps_project}/logs"
mkdir -p "${ps_project}/models"
echo "Created permanent storage directories at ${ps_project}"

# Create a default settings file if it does not exist
settings_file="${ps_project}/config/settings.json"
if [ ! -f "$settings_file" ]; then
    cat <<EOF > "$settings_file"
{
    "project_name": "${project_name}",
    "version": "1.0.0",
    "description": "Default project settings. Modify as needed."
}
EOF
    echo "Created default settings file at ${settings_file}"
else
    echo "Settings file already exists at ${settings_file}"
fi

echo "Project '${project_name}' setup is complete!"