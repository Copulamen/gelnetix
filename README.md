<div align="center">

# Gelnetix
### Graphical Elastic Net for Mixed Data

[![R](https://img.shields.io/badge/-R_4.3-blue?logo=r&logoColor=white)](https://www.r-project.org/)
[![C++](https://img.shields.io/badge/-C++_17-00599C?logo=cplusplus&logoColor=white)](https://cplusplus.com/)
<br/>
[![CI](https://github.com/jcathalina/gelnetix/actions/workflows/ci.yaml/badge.svg)](https://github.com/jcathalina/gelnetix/actions/workflows/ci.yaml)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://opensource.org/license/mit/) 

</div>

### Quickstart

#### Dev Container
If you have Docker installed and you're using an IDE that supports dev containers (e.g., VS Code), you can simply open this project
in a container (in VS Code, you will need the `Remote Development` plugin). This will install all necessary requirements for running the project and also the dev-only libraries.

##### Rcpp support
For many IDEs, it is necessary to supply the include path for the header files (such as Rcpp.h) that are used for the C++ parts of this project. You can find them easily by running `find . -name "Rcpp.h` (similarly for `RcppArmadillo.h` and `RcppParallel.h`) and `find . -name "R.h"`, for the Rcpp headers and the R headers, respectively.

### About

### Authors

Rocherno de Jongh and Julius Cathalina

### License

MIT