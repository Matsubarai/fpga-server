# Guide for Lab502 Server with Xilinx Cards v0.2

English | [Chinese](./README_CM.md)

By Qianyu Cheng (qycheng@mail.ustc.edu.cn) 

Date: 2023/12/12
## Overview
- Security
  - Disable `sudo` for all users (except `ubuntu`) and `XRT/setup.sh` configuration
  - Allocate, execute and deallocate environment in container mode (based on our scripts)
    ```bash
    env_alloc [-d <DeviceID[,...]>] [-e] [-p <APP=jupyter|vnc>] [-i <IMAGE_NAME>] # allocate
    env_exec # execute
    env_dealloc # deallocate
    ```
  - Reserve data in `/data` directory of container (i.e. `/home/$USER` directory of the host)
  - user creation script (`sudo` permission needed)
    ```bash
    /home/ubuntu/new_user_init.sh <username>
    ```
- Resource Management
  - allocate FPGA cards (`-d DeviceID,...`)
  - shared/exclusive allocation (with `-e` or without `-e`)
- Service
  - 提供网页端容器管理 `Portainer`, 可通过 `https://<IP>:2000` 访问 
  - 提供多版本运行环境，通过 `-i xilinx-u280:{2020.2|2021.2|2022.2|2023.2}` 切换，后续用户可基于 `Dockerfile` 构建扩展环境
    - [Template](./Dockerfile) 
  - 提供 `Jupyter Lab` (Python IDE) , `noVNC` (网页远程桌面) 服务支持 (`-p jupyter|vnc`)
  - 提供开放端口池，自动进行容器->主机端口映射，可使用浏览器通过 `<IP>:2001-2010` 访问
- 已知问题
  - 退出后直接释放容器，不保留 `/data` 目录外的其他运行时数据
  - 在容器 `/home/$USER` 目录内读写文件，返回用户环境后可能引发权限问题 (文件所有权被设为root)
    - 缓解措施: 提前记下用户 `$UID`, 在容器内使用`chown <HOST_UID>`修改所有权

![](image.png)
