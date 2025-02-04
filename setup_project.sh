#!/bin/bash
set -euo pipefail

# Ask for the project name
read -p "Enter your project name: " project_name

# Create project folder structure within the workspace
mkdir -p "${project_name}/src/"
mkdir -p "${project_name}/data/"
mkdir -p "${project_name}/notebooks/"
mkdir -p "${project_name}/scripts/"

# Initialize a git repository if one doesn't already exist
if [ ! -d "${project_name}/.git" ]; then
    cd "${project_name}"
    git init
    cd ..
    echo "Initialized a new Git repository in ${project_name}/"
else
    echo "Git repository already exists in ${project_name}/"
fi

# Create a .gitignore file with entries for folders that should be ignored
gitignore_file="${project_name}/.gitignore"
cat <<EOF > "$gitignore_file"
# Ignore permanent storage for datasets
permanent_storage/

# Ignore settings reference (for previous docker file configurations)
Settings reference/

# Common Python and system files
__pycache__/
*.py[cod]
*.so
.DS_Store
EOF
echo "Created .gitignore in ${project_name}/"

# Create a .pre-commit-config.yaml for pre-commit hooks for R and Python
cat <<'EOF' > "${project_name}/.pre-commit-config.yaml"
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
echo "Created .pre-commit-config.yaml in ${project_name}/"

# Optionally, create a basic README.md
read -p "Would you like to create a README.md for the project? (y/n): " create_readme
if [[ "$create_readme" =~ ^[Yy]$ ]]; then
    read -p "Enter a short project description: " description
    cat <<EOF > "${project_name}/README.md"
# ${project_name}

${description}

## Project Structure

- src/        : Source code
- data/       : Data files and datasets
- notebooks/  : Jupyter notebooks
- scripts/    : Utility scripts

EOF
    echo "README.md created for ${project_name}"
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