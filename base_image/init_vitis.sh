#!/bin/bash
if [ -f /tools/Xilinx/Vitis/${XILINX_VERSION}/settings64.sh ]; then
	. /tools/Xilinx/Vitis/${XILINX_VERSION}/settings64.sh
fi
if [ -f /opt/xilinx/xrt/setup.sh ]; then
	. /opt/xilinx/xrt/setup.sh
fi
if [ -d /usr/local/MATLAB ]; then
	PATH=/usr/local/MATLAB/R2022b/bin/:$PATH
fi
export PS1="($HOST_USER-env) $PS1"
