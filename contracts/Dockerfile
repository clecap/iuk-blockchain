FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive

# update
RUN apt-get update -yqq

# install latest version of solc
RUN apt-get install -yqq --no-install-recommends software-properties-common && \
add-apt-repository ppa:ethereum/ethereum && \
apt-get install -yqq --no-install-recommends solc

# clean up
RUN rm -rf /var/lib/apt/lists/*

# mount /data
WORKDIR /data
VOLUME ["/data"]
