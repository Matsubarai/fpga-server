FROM xilinx-u280:2022.2
WORKDIR /
RUN git clone https://github.com/rogersce/cnpy.git && \
    apt-get update && apt-get install -y cmake && apt-get clean && \
    cd cnpy && mkdir build && \
    cd build && cmake .. && \
    make && make install && \
    cd ../.. && rm -rf cnpy
WORKDIR /data
