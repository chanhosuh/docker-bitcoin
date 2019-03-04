FROM ubuntu:18.04

# Bitcoin Core dependencies and install instructions from
# https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md

RUN apt-get update && apt-get install -y \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
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


RUN git clone https://github.com/bitcoin/bitcoin.git
WORKDIR bitcoin
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
