ARG XILINX_VERSION=2022.2

FROM xilinx/xilinx_runtime_base:alveo-${XILINX_VERSION}-ubuntu-20.04

ARG XILINX_VERSION=2022.2

VOLUME /data

RUN wget -qO- https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-gen3x16-xdma_2022.2_2022_1015_0317-all.deb.tar.gz | tar xz --strip 1 -C /opt/xilinx/shell && ls /opt/xilinx/shell

RUN apt-get update && \
    apt-get install /opt/xilinx/shell/xilinx*u280*.deb && \
    apt-get install -y libtinfo5 opencl-headers pip locales && \
    apt-get clean && \
    locale-gen en_US.UTF-8

RUN pip install jupyter pynq -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN apt-get update && \
    apt-get install -y libxrender1 libxtst6 libxi6 libfreetype6 fontconfig git vim wget net-tools bzip2 procps apt-utils ttf-wqy-zenhei && \
    apt-get clean

ENV DISPLAY=:1 \
    TERM=xterm \
    VNC_PORT=5901 \
    DEBIAN_FRONTEND=noninteractive \
    NO_VNC_PORT=6901 \
    NO_VNC_HOME=/noVNC \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1600x900 \
    VNC_VIEW_ONLY=false

RUN apt-get update && \
    apt-get install -y xfce4 xfce4-terminal xterm dbus-x11 libdbus-glib-1-2 python-numpy tigervnc-standalone-server && \
    apt-get purge -y pm-utils *screensaver* && \
    apt-get clean

RUN mkdir -p $NO_VNC_HOME/utils/websockify && \
    wget -qO- https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME && \
    wget -qO- https://github.com/novnc/websockify/archive/refs/tags/v0.10.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify && \
    ln -s $NO_VNC_HOME/vnc_lite.html $NO_VNC_HOME/index.html && \
    mkdir $HOME/.vnc

EXPOSE 8888 6901

COPY ./entrypoint.sh /entrypoint.sh

COPY ./jupyter_configs/ /root/.jupyter

RUN mkdir $HOME/Desktop && \
echo "[Desktop Entry]\nEncoding=UTF-8\nType=Application\nName=Vitis HLS ${XILINX_VERSION}\nComment=Vitis HLS ${XILINX_VERSION}\nIcon=/tools/Xilinx/Vitis_HLS/${XILINX_VERSION}/doc/images/vitis_hls_icon.png\nExec=/tools/Xilinx/Vitis_HLS/${XILINX_VERSION}/bin/vitis_hls" > $HOME/Desktop/"Vitis HLS ${XILINX_VERSION}.desktop" && \
echo "[Desktop Entry]\nEncoding=UTF-8\nType=Application\nName=Xilinx Vitis ${XILINX_VERSION}\nComment=Xilinx Vitis ${XILINX_VERSION}\nIcon=/tools/Xilinx/Vitis/${XILINX_VERSION}/doc/images/ide_icon.png\nExec=/tools/Xilinx/Vitis/${XILINX_VERSION}/bin/vitis" > $HOME/Desktop/"Xilinx Vitis ${XILINX_VERSION}.desktop" && \
echo "[Desktop Entry]\nEncoding=UTF-8\nType=Application\nName=Vivado ${XILINX_VERSION}\nComment=Vivado ${XILINX_VERSION}\nIcon=/tools/Xilinx/Vivado/${XILINX_VERSION}/doc/images/vivado_logo.png\nExec=/tools/Xilinx/Vivado/${XILINX_VERSION}/bin/vivado" > $HOME/Desktop/"Vivado ${XILINX_VERSION}.desktop" && \
echo "[Desktop Entry]\nEncoding=UTF-8\nType=Application\nName=Model Composer and System Generator ${XILINX_VERSION}\nComment=Model Composer and System Generator ${XILINX_VERSION}\nIcon=/tools/Xilinx/Model_Composer/${XILINX_VERSION}/data/images/Compiler.png\nExec=/tools/Xilinx/Model_Composer/${XILINX_VERSION}/bin/model_composer" > $HOME/Desktop/"Model Composer and System Generator ${XILINX_VERSION}.desktop" && \
chmod 755 $HOME/Desktop/*.desktop

RUN printf '\n$localhost = "no";\n1;\n' >> /etc/tigervnc/vncserver-config-defaults && \
    printf '\n#!/bin/bash\nxset -dpms &\nxset s noblank &\nxset s off &\nstartxfce4 --replace &' >> $HOME/.vnc/xstartup

RUN echo "export PATH=$PATH:/usr/local/MATLAB/R2022b/bin" >> $HOME/.bashrc && \
    echo "source /tools/Xilinx/Vitis/${XILINX_VERSION}/settings64.sh" >> $HOME/.bashrc && \
    echo "source /opt/xilinx/auto_setup.sh" >> $HOME/.bashrc

WORKDIR /data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "" ]
