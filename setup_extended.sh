#!/bin/bash
set -euo pipefail
source utils.sh
PYTHON_VER="python=3.11"

# Bioconductor core packages
install_packages \
    bioconductor-biocgenerics \
    bioconductor-biocparallel \
    bioconductor-s4vectors \
    bioconductor-iranges \
    bioconductor-xvector \
    bioconductor-zlibbioc \
    bioconductor-genomeinfodb \
    bioconductor-genomeinfodbdata

# Bioconductor genomics packages
install_packages  \
    bioconductor-bsgenome \
    bioconductor-bsgenome.hsapiens.ucsc.hg38 \
    bioconductor-genomicranges \
    bioconductor-genomicalignments \
    bioconductor-genomicfiles \
    bioconductor-genomicinteractions \
    bioconductor-rtracklayer

# Bioconductor annotation packages
install_packages  \
    bioconductor-ensembldb \
    bioconductor-org.hs.eg.db \
    bioconductor-txdb.hsapiens.ucsc.hg38.knowngene \
    bioconductor-txdb.hsapiens.ucsc.hg38.refgene \
    bioconductor-variantannotation

# Bioconductor array and data packages
install_packages  \
    bioconductor-affy \
    bioconductor-affyio \
    bioconductor-affxparser \
    bioconductor-affycoretools \
    bioconductor-oligo \
    bioconductor-oligoclasses \
    bioconductor-pd.hugene.1.0.st.v1 \
    bioconductor-pd.clariom.s.human \
    bioconductor-pd.clariom.s.rat \
    bioconductor-pd.clariom.s.mouse \
    bioconductor-preprocesscore

# Bioconductor statistics and analysis
install_packages  \
    bioconductor-delayedarray \
    bioconductor-delayedmatrixstats \
    bioconductor-limma \
    bioconductor-matrixgenerics \
    bioconductor-multiassayexperiment \
    bioconductor-summarizedexperiment

# Bioconductor utilities
install_packages  \
    bioconductor-biocfilecache \
    bioconductor-biocio \
    bioconductor-biovizbase \
    bioconductor-gviz \
    bioconductor-interactionset \
    bioconductor-keggrest \
    bioconductor-protgenerics \
    bioconductor-rhtslib \
    bioconductor-rsamtools

# Python core packages
install_packages $PYTHON_VER\
    beautifulsoup4 \
    brotli \
    brotli-bin \
    brotli-python \
    gitpython \
    jedi \
    networkx \
    numba \
    numexpr \
    scikit-image \
    scikit-learn

# Jupyter and notebook related
install_packages $PYTHON_VER\
    jsonpatch \
    jsonpointer \
    jsonschema \
    nbclassic \
    nbclient \
    nbconvert \
    nbconvert-core \
    nbconvert-pandoc \
    nbdime \
    notebook \
    notebook-shim \
    pandocfilters \
    prometheus_client \
    prompt-toolkit

# System and utility packages
install_packages $PYTHON_VER\
    libjpeg-turbo \
    libsqlite \
    nodejs \
    nomkl \
    pyzmq \
    pyyaml \
    sed \
    stack_data

# R base packages (part 1)
install_packages  \
    r-reshape2 \
    r-xml2 \
    r-rjsonio \
    r-curl \
    r-dbi \
    r-dbplyr \
    r-devtools \
    r-diagram \
    r-dials \
    r-ellipsis \
    r-fontawesome \
    r-forcats \
    r-foreach

# R base packages (part 2)
install_packages  \
    r-forecast \
    r-foreign \
    r-formatr \
    r-formula \
    r-formula.tools \
    r-fracdiff \
    r-fs \
    r-furrr \
    r-futile.logger \
    r-futile.options \
    r-future \
    r-future.apply

# R statistics and visualization (part 1)
install_packages  \
    r-haven \
    r-hmisc \
    r-hms \
    r-htmltable \
    r-htmltools \
    r-htmlwidgets \
    r-httpcode \
    r-httpuv \
    r-httr \
    r-httr2 \
    r-igraph \
    r-isoband

# R statistics and visualization (part 2)
install_packages  \
    r-iterators \
    r-jpeg \
    r-labeling \
    r-lambda.r \
    r-later \
    r-lattice \
    r-latticeextra \
    r-lava \
    r-lazyeval \
    r-lhs \
    r-lifecycle \
    r-listenv

# R core utilities (part 1)
install_packages  \
    r-openssl \
    r-operator.tools \
    r-parallelly \
    r-plogr \
    r-plyr \
    r-png \
    r-praise \
    r-prettyunits \
    r-proc \
    r-processx \
    r-proxy \
    r-pryr \
    r-ps \
    r-purrr

# R core utilities (part 2)
install_packages  \
    r-r6 \
    r-randomforest \
    r-rcpp \
    r-rcpparmadillo \
    r-rcppeigen \
    r-rcurl \
    r-readr \
    r-readxl \
    r-rjson \
    r-rlang \
    r-rsqlite \
    r-rstudioapi

# R additional packages (part 1)
install_packages  \
    r-shape \
    r-slider \
    r-stringi \
    r-sys \
    r-systemfonts \
    r-testthat \
    r-textshaping \
    r-ttr \
    r-tune \
    r-tzdb

# R additional packages (part 2)
install_packages  \
    r-urlchecker \
    r-urltools \
    r-usethis \
    r-utf8 \
    r-uuid \
    r-vctrs \
    r-vegan \
    r-vgam \
    r-viridis \
    r-viridislite

# R final packages
install_packages  \
    r-vroom \
    r-waldo \
    r-warp \
    r-whisker \
    r-withr \
    r-workflows \
    r-workflowsets \
    r-xfun \
    r-xml \
    r-xopen \
    r-xtable \
    r-xts \
    r-yaml \
    r-yardstick \
    r-zip \
    r-zoo
    
# Bioconductor enrichment analysis
install_packages  \
    bioconductor-clusterprofiler \
    bioconductor-gsva \
    r-msigdbr \
    bioconductor-enrichplot \
    r-pheatmap \
    bioconductor-biomaRt