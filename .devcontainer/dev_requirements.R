#!/usr/bin/Rscript

install.packages(c(
    "devtools",  # devtools is needed to install packages from github
    "lintr",     # lintr is used by vscode-r-lsp to lint R code
    "roxygen2",  # roxygen2 is used to generate documentation
    "testthat",  # testthat is used to run tests
    "languageserver",  # languageserver is used by vscode-r-lsp to provide language server functionality
    "httpgd"))  # httpgd is used by vscode-r-lsp to provide graphics
