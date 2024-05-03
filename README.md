# governing-commons-code-clones
Replication package for the EMSE paper "Governing the Commons: Code Ownership and Code Clones in Large Scale Software Development"

## Steps to build and run docker image

The image has been built on an Ubuntu 22.04 system (x64 Linux), with 64 GiB internal memory and 21 GiB swap.
Other steps might be needed on other architectures or OSes.

1. Build the docker image via: `docker build -t ownership-commons .`

2. Output files are created in `/home/app/ownership/output`, and models are cached in `/home/app/ownership/.cache`.
   These directories should be mapped to some directory on your local system.
   First create the needed local directories, and make them available for the docker image:
   `mkdir -p ${PWD}/ownership/.cache && mkdir -p ${PWD}/ownership/output && chmod -R a+rwx ${PWD}/ownership`

3. Run the image, and mount these directories to the container:
   `docker run --mount type=bind,source=${PWD}/ownership,target=/home/app/ownership ownership-commons`

    a. In case you only want to run some RMarkdown files, a prefix can be specified via a docker environment variable:
    `docker run --mount type=bind,source=${PWD}/ownership,target=/home/app/ownership -e PREFIX=02 ownership-commons`
    Standard shell globbing rules can be used (but beware to escape them from the regular shell used to start docker.
    b. In case you want to run with a separately stored cache directory, use the CACHE environment variable, and make sure that it is mounted into the container. For instance:
    `docker run --mount type=bind,source=${PWD}/ownership,target=/home/app/ownership -e PREFIX=02 -e CACHE="../ownership/.cache" ownership-commons