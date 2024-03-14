FROM xilinx/xilinx_runtime_base:alveo-2023.2-ubuntu-20.04

##
## install Vitis dependencies
##
RUN wget -qO- https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-gen3x16-xdma_2022.2_2022_1015_0317-all.deb.tar.gz > deploy.tar.gz && \
    tar -xzf deploy.tar.gz -C /opt/xilinx/shell && rm deploy.tar.gz
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y -qq && \
    apt-get install -y -qq --no-install-recommends \
        /opt/xilinx/shell/xilinx*u280*.deb \
        tofrodos \
        iproute2 \
        gawk \
        net-tools \
        libtinfo5 \
        libncurses5-dev \
        libncursesw5-dev \
        libssl-dev \
        flex \
        bison \
        libselinux1 \
        gnupg \
        wget \
        htop \
        diffstat \
        chrpath \
        socat \
        x11-utils \
        dbus-x11 \
        libdbus-glib-1-2 \
        xterm \
        autoconf \
        libtool \
        tar \
        unzip \
        texinfo \
        zlib1g-dev \
        g++-multilib \
        gcc-multilib \
        build-essential \
        libc6-dev-i386 \
        screen \
        pax \
        zip \
        gzip \
        bzip2 \
        python2.7-dev \
        python2.7 \
        python3-dev \
        python3 \
        pip \
        procps \
        apt-utils \
        binutils \
        cpio \
        expect \
        file \
        libfreetype6 \
        fontconfig \
        fonts-noto-cjk \
        ttf-wqy-zenhei \
        git \
        gosu \
        lib32z1-dev \
        libcanberra-gtk-module \
        libcanberra-gtk3-module \
        libglib2.0-dev \
        libgtk2.0-0 \
        libjpeg62-dev \
        libsdl1.2-dev \
        libstdc++6 \
        libtext-csv-perl \
        libtool-bin \
        libxi6 \
        libxrender1 \
        libxtst6 \
        locales \
        lsb-core \
        lsb-release \
        ncurses-dev \
        ocl-icd-libopencl1 \
        ocl-icd-opencl-dev \
        opencl-headers \
        pkg-config \
        software-properties-common \
        sudo \
        u-boot-tools \
        vim \
        xvfb \
        parted \
        udev \
        graphviz && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/*

##
## locale settings
##
ENV TERM=xterm
RUN locale-gen en_US.UTF-8 && \
    update-locale
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

##
## PYNQ/Jupyter settings
##
RUN /bin/bash -c 'source /opt/xilinx/xrt/setup.sh && \
     pip install jupyter pynq matplotlib -i https://pypi.tuna.tsinghua.edu.cn/simple'
EXPOSE 8888
COPY ./jupyter_configs/ /root/.jupyter
COPY ./jupyter_configs/ /etc/skel/.jupyter

##
## Xilinx Vitis settings
##
COPY files/init_vitis.sh /usr/local/bin/init_vitis.sh
RUN chmod +x /usr/local/bin/init_vitis.sh && \
    echo 'if [  -f /usr/local/bin/init_vitis.sh ]; then . /usr/local/bin/init_vitis.sh; export USER=`id -u -n`; fi' >> /root/.bashrc && \
    echo 'if [  -f /usr/local/bin/init_vitis.sh ]; then . /usr/local/bin/init_vitis.sh; export USER=`id -u -n`; fi' >> /etc/skel/.bashrc

##
## ENTRYPOINT settings
##
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash", "-l"]
