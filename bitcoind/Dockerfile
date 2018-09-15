FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin -y
RUN apt-get update && \
    apt-get install -y bitcoind && \
    rm -rf /var/lib/apt/lists/*

# create data directory
ENV DATA_DIR /data
RUN mkdir "$DATA_DIR"

# install config
ENV CONFIG_FILE=/root/.bitcoin/bitcoin.conf
COPY bitcoin.conf "$CONFIG_FILE"

CMD bitcoind -printtoconsole -conf="$CONFIG_FILE" -datadir="$DATA_DIR"
