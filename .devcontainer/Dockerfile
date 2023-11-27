FROM rocker/r-ver:4.3.1

LABEL maintainer="Julius Cathalina <julius.cathalina@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    git \
    openssh-client \
    pandoc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev \
    python3.10 \
    python3-pip \ 
    && rm -rf /var/lib/apt/lists/*

ENV _R_SHLIB_STRIP_=true

RUN install2.r remotes renv

WORKDIR /home/projects

COPY ./renv.lock .
RUN Rscript -e "options(renv.consent = TRUE);renv::restore(lockfile = '/home/projects/renv.lock', repos = c(CRAN='https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"
RUN rm -f renv.lock

CMD ["/bin/bash"]
