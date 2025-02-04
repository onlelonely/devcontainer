# Data Science Dev Container Setup

This project provides a reproducible development environment leveraging Docker, Visual Studio Code's Dev Container feature, and micromamba for managing dependencies. It is designed for data science projects that use Python, R, and bioinformatics tools. The setup includes scripts to bootstrap your project structure, initialize Git repositories, configure pre-commit hooks, and install a comprehensive list of packages for both core and extended workflows with robust retry logic.

> **Note:** This repository is for personal use and reference. Contributions, feedback, or suggestions are most welcome!
I'm not a professional software engineer, so this is not meant to be a production-ready solution.
However, I'm a bioinformatician familiar with NGS data (WES, WGS, RNA-seq, etc.) and Affymetrix arrays.
Contact me if you want to collaborate on any bioinformatics projects.

Li-Hsin Chang, Ph.D.  
Email: lhchang@nhri.edu.tw

## Table of Contents

1. [Overview](#overview)
2. [Dev Container Configuration](#dev-container-configuration)
3. [Project Setup Scripts](#project-setup-scripts)
4. [Package Installation Scripts](#package-installation-scripts)
5. [Usage](#usage)
6. [Directory Structure](#directory-structure)
7. [Troubleshooting](#troubleshooting)
8. [Additional Resources](#additional-resources)

## Overview

This repository provides an integrated solution that:

- **Creates an Isolated Development Environment:** Uses Docker and Visual Studio Code Dev Containers to deliver a consistent ecosystem.
- **Bootstraps New Projects:** Offers two alternatives for project initialization so that you can choose the level of interaction and customization that fits your workflow.
- **Manages Dependencies:** Installs core Python and R packages (including advanced bioinformatics and system utilities) using micromamba with built-in retry logic.
- **Ensures Persistent Data:** Leverages a mounted `permanent_storage` directory to keep configurations, logs, datasets, and models intact across container sessions.

## Dev Container Configuration

The primary container configuration is defined in `devcontainer/.devcontainer/devcontainer.json`. Key highlights include:

- **Base Image:** Ubuntu 22.04.
- **Workspace & Mounts:** Projects and persistent storage are mounted in `/workspace` with volumes for Python and R package caches.
- **Hooks:** 
  - The `updateContentCommand` runs `setup_core.sh` to install essential packages.
  - The `postCreateCommand` executes `setup_extended.sh` (after cleaning caches) to install additional packages if not already initialized.
- **Features & Customizations:** Pre-configured extensions and VS Code settings for Python, Jupyter, and R are provided to improve your development experience.

## Project Setup Scripts

### `devcontainer/manage.sh`

**Purpose:**  
The `manage.sh` script provides quick management of your development environment by offering commands to install or remove packages, clean caches, and refresh your overall setup. It leverages robust retry logic (sourced from `utils.sh`) to handle transient network or system issues.

**Functionalities:**

- **Installing Packages:**
  - **Usage:**  
    ```bash
    bash devcontainer/manage.sh install <category:package> [-s|--save]
    ```
  - **Details:**  
    Installs a package into the environment. The optional `-s` or `--save` flag appends the package to the relevant category section in `setup_extended.sh`. This ensures that the package installation is preserved for future container builds.
  - **Example:**  
    To install the Python package `numpy` under the default "New packages" category and save it:
    ```bash
    bash devcontainer/manage.sh install numpy -s
    ```
    To install an R package (for example, `ggplot2`) under the `r` category:
    ```bash
    bash devcontainer/manage.sh install r:ggplot2 -s
    ```

- **Removing Packages:**
  - **Usage:**  
    ```bash
    bash devcontainer/manage.sh remove <category:package> [-s|--save]
    ```
  - **Details:**  
    This command removes a package from the environment. The optional `-s` or `--save` flag simultaneously removes the package entry from `setup_extended.sh`.
  - **Example:**  
    To remove the Python package `numpy` and update the script:
    ```bash
    bash devcontainer/manage.sh remove numpy -s
    ```

- **Cleaning Package Caches:**
  - **Usage:**  
    ```bash
    bash devcontainer/manage.sh clean
    ```
  - **Details:**  
    Cleans all package caches using micromamba, helping resolve issues related to stale caches or disk space.

- **Refreshing the Environment:**
  - **Usage:**  
    ```bash
    bash devcontainer/manage.sh refresh
    ```
  - **Details:**  
    Resets the dev container environment by deleting the initialization flag and re-running both `setup_core.sh` and `setup_extended.sh`. This is particularly useful after making changes to the setup scripts or package configurations.

### `devcontainer/setup_project.sh`

**Purpose:**  
Provides an interactive project initialization with customizable options.

**What It Does:**
- Prompts for a project name and creates a directory structure (including `src`, `data`, `notebooks`, and `scripts`) in the current workspace.
- Initializes a Git repository (if one does not exist).
- Creates a default `.gitignore` to exclude persistent storage and common system files.
- Generates a `.pre-commit-config.yaml` to set up pre-commit hooks that support tools like **Black** for Python and **r-lintr** for R.
- Optionally, creates a basic `README.md` for your new project.
- Sets up corresponding persistent storage folders (under `permanent_storage`) for configuration, data, logs, and models, and writes a default settings JSON file.

## Package Installation Scripts

The container's package installation is managed by a set of scripts that leverage micromamba along with built-in retry logic provided by `utils.sh`:

### `devcontainer/utils.sh`

- **Purpose:**  
  Provides helper functions that add robustness to package installations or removals by retrying the command up to three times with exponential back-off.

### `devcontainer/setup_core.sh`

- **Purpose:**  
  Installs essential packages required for a basic data science environment including Jupyter kernels, core Python data science libraries, bioinformatics tools, and developer utilities such as pre-commit.

### `devcontainer/setup_extended.sh`

- **Purpose:**  
  Augments your setup by installing a wide-ranging suite of additional packages. This script covers Bioconductor packages, additional Python and R libraries, as well as system-level utilities.

## Usage

To get started with your development environment:

1. **Open in VS Code or Cursor:**
   - Clone the repository.
   - Open it in VS Code.
   - Use the **"Reopen in Container"** command to launch the Dev Container.

2. **Initial Package Installation:**
   - The container automatically runs `setup_core.sh` (via the `updateContentCommand`) to install essential packages.
   - On the first container creation, `setup_extended.sh` is executed (via the `postCreateCommand`) to install extended libraries. This process only runs once (tracked by a hidden initialization file).

3. **Project Initialization:**
   - **Interactive Setup with Pre-commit Hooks:**  
     Run `bash devcontainer/setup_project.sh` to walk through project initialization, including Git setup, pre-commit configuration, and optional README.md generation.

4. **Manage Packages:** 
   - Run `bash devcontainer/manage.sh` from the terminal (inside or outside the container) to manage your environment or update packages.

5. **Persistent Storage:**
   - The `permanent_storage` directory is mounted into the container. It holds your configuration files, datasets, logs, and model files—ensuring data continuity even if the container is rebuilt.

## Directory Structure

After running one of the setup scripts, your workspace should have a structure similar to:

```/workspace
├── project
│   └── <project_name>
│       ├── src/
│       ├── data/
│       ├── notebooks/
│       ├── scripts/
│       ├── .git           # Git repository (if initialized)
│       ├── .gitignore
│       └── .pre-commit-config.yaml   # (only if initialized via setup_project.sh)
└── permanent_storage
    └── <project_name>
        ├── config
        │   └── settings.json
        ├── data
        ├── logs
        └── models
```

- **project/**: Contains your active project code and related files.
- **permanent_storage/**: Houses persistent configuration, logs, data, and models that persist across container sessions.

## Troubleshooting

- **Package Installation Issues:**  
  If package installation fails, the retry logic from `utils.sh` should help overcome transient network or system hiccups. Check your network connection or review the container logs if issues persist.

- **Git Initialization or File Permissions:**  
  Ensure that the workspace directories are writable and Git is installed. Verify that the relative paths used by `manage.sh` or `setup_project.sh` match your container's mounted directories.

- **Persistent Storage Mounting:**  
  Confirm that the `permanent_storage` folder is correctly mounted via the `devcontainer.json` configuration, ensuring data is retained across container rebuilds.

## Additional Resources

- [Visual Studio Code Remote - Containers](https://code.visualstudio.com/docs/remote/containers)
- [Micromamba Documentation](https://mamba.readthedocs.io/)
- [Bioconductor](https://www.bioconductor.org/)