#!/bin/bash
if [ -f /tools/Xilinx/Vitis/${XILINX_VERSION}/settings64.sh ]; then
    . /tools/Xilinx/Vitis/${XILINX_VERSION}/settings64.sh
fi

if [ -d /usr/local/MATLAB ]; then
    export PATH=/usr/local/MATLAB/bin:$PATH
fi
