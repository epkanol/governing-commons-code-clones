FROM rocker/r-ver:4.3.3 AS builder

MAINTAINER Anders Sundelin "epkanol@gmail.com"

# These were the package versions used at the time of build.
# Should be stable and tied to the rocker/r-ver version.
# Check which versions that are available via:
#
# $ docker run -ti --rm rocker/r-ver:4.3.3 bash
# root@abc123:/# apt update
# root@abc123:/# apt list cmake
# cmake/jammy-updates 3.22.1-1ubuntu1.22.04.2 amd64
#
# The point is to have a stable base of packages for R to stand on.

# tidyverse: libharfbuzz-dev libfribidi-dev
# ragg: libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev
# xml2: libxml2-dev

RUN apt-get update && apt-get install -y \
    cmake=3.22.1-1ubuntu1.22.04.2 \
    libssl-dev=3.0.2-0ubuntu1.15 \
    pandoc=2.9.2.1-3ubuntu2 \
    libexpat1=2.4.7-1ubuntu0.3 \
    libnode-dev=12.22.9~dfsg-1ubuntu3.4 \
    libcurl4=7.81.0-1ubuntu1.15 \
    libcurl4-openssl-dev=7.81.0-1ubuntu1.15 \
    libfontconfig1-dev=2.13.1-4.2ubuntu5 \
    libharfbuzz-dev=2.7.4-1ubuntu3.1 \
    libfribidi-dev=1.0.8-2ubuntu3.1 \
    libfreetype6-dev=2.11.1+dfsg-1ubuntu0.2 \
    libpng-dev=1.6.37-3build5 \
    libtiff5-dev=4.3.0-6ubuntu0.8 \
    libjpeg-dev=8c-2ubuntu10 \
    libxml2-dev=2.9.13+dfsg-1ubuntu0.4 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 2000 app
USER app

RUN mkdir -p /home/app/R/library && mkdir /home/app/analysis

WORKDIR /home/app

RUN echo ".libPaths('/home/app/R')" >> .Rprofile && R -e "install.packages('renv')"

USER root
COPY renv.lock /home/app/renv.lock
RUN chown -R app:app /home/app/renv.lock
USER app
RUN R -e "renv::restore()"
RUN R -e 'install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")), version="2.34.1")'
RUN R -e 'cmdstanr::install_cmdstan(version="2.34.1")'

# source code changes here, after building the R image incl. renv packages and Stan
USER root
COPY analysis/ownership /home/app/analysis
RUN chown -R app:app /home/app/analysis

USER app
RUN mkdir -p /home/app/ownership/.cache

CMD ["R", "-e", "rmarkdown::render('analysis/01_exploratory_data_analysis.Rmd', output_dir='ownership/output')" ]
