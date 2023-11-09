FROM rocker/r-base:4.3.1

LABEL maintainer="Julius Cathalina <julius.cathalina@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    git \
    pandoc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# COPY Rprofile.site /etc/R  # TODO: Maybe relevant when we move to shiny app
ENV _R_SHLIB_STRIP_=true

RUN install.r remotes renv

RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/gelnetix

COPY ../renv.lock .
RUN Rscript -e "options(renv.consent = TRUE);renv::restore(lockfile = '/home/gelnetix/renv.lock', repos = c(CRAN='https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"
RUN rm -f renv.lock