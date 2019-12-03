FROM ubuntu:18.04

# Bitcoin Core dependencies and install instructions from
# https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md

RUN apt-get update && apt-get install -y \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        curl \
        git \
        make \
        python3 \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-chrono-dev \
        libboost-test-dev \
        libboost-thread-dev \
        libevent-dev \
        libssl-dev \
        libtool \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*


# Clone source repo into bitcoin directory
RUN git clone https://github.com/bitcoin/bitcoin.git


# Need to get the latest stable release version;
# luckily, GitHub provides a URL which will redirect to
# a URL with the release version number.
ENV release_url https://github.com/bitcoin/bitcoin/releases/latest
# RUN curl "${release_url}" -sLIo /dev/null -w '%{url_effective}' | grep -o '[^/]*$' > ./release_version
RUN echo "v0.19.0.1" > ./release_version
RUN echo "*** release version: `cat ./release_version` ***"


# Install latest release from cloned repo
WORKDIR bitcoin
RUN git checkout `cat ../release_version`
RUN ./autogen.sh
RUN ./configure --disable-wallet
RUN make
RUN make install
WORKDIR ../


# create data directory
ENV DATA_DIR /data
RUN mkdir "$DATA_DIR"


# install config
ENV CONFIG_FILE=/root/.bitcoin/bitcoin.conf
COPY bitcoin.conf "$CONFIG_FILE"


CMD bitcoind -printtoconsole -conf="$CONFIG_FILE" -datadir="$DATA_DIR"
