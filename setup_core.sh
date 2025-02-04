#!/bin/bash
set -euo pipefail
source utils.sh
PYTHON_VER="python=3.11"

# Install Jupyter kernels
micromamba install -y -n base ipykernel ipywidgets r-irkernel
R -e 'IRkernel::installspec()'

# Python data science packages
install_packages $PYTHON_VER\
    numpy \
    pandas \
    scipy \
    matplotlib-base \
    matplotlib-inline \
    seaborn \
    seaborn-base \
    sympy \
    tqdm \
    yaml \
    yaml-cpp

# Jupyter packages
install_packages $PYTHON_VER\
    jupyter-lsp \
    jupyterlab \
    jupyterlab-git \
    jupyterlab_pygments \
    jupyterlab_server \
    jupyterlab_widgets

# Stats packages
install_packages $PYTHON_VER\
    statsmodels \
    blas \
    blas-devel

# Bioinformatics packages
install_packages $PYTHON_VER\
    biopython \
    bioconductor-annotationdbi \
    bioconductor-annotationfilter \
    bioconductor-biobase \
    bioconductor-biocbaseutils \
    bioconductor-biomart \
    bioconductor-biostrings \
    bioconductor-genomicfeatures

# R packages
install_packages $PYTHON_VER\
    r-matrix \
    r-knitr \
    r-e1071 \
    r-ggplot2 \
    r-stringr \
    r-survival \
    r-tibble \
    r-tidymodels \
    r-tidyr \
    r-tidyselect \
    r-tidyverse

# Install r-lintr to support pre-commit lintr hook
install_packages $PYTHON_VER\
    r-lintr

# ----------------------------------------------------------------
# Developer Tools: Install pre-commit so that the hook defined by
# .pre-commit-config.yaml (created in setup_project.sh) will work.
# ----------------------------------------------------------------
install_packages $PYTHON_VER\
    pre-commit

# Optionally, for any already initialized project(s) in /workspace/project,
# automatically install the pre-commit hooks.
if [ -d "/workspace/project" ]; then
    for repo in /workspace/project/*; do
        if [ -d "${repo}/.git" ] && [ -f "${repo}/.pre-commit-config.yaml" ]; then
            echo "Installing pre-commit hooks in ${repo}"
            (cd "${repo}" && pre-commit install)
        fi
    done
fi