# Guide for Lab502 Server with Xilinx Cards v0.1

By Qianyu Cheng (qycheng@mail.ustc.edu.cn) 

Date: 2023/12/3

U280服务器维护已基本完成，提供特性如下：
- 数据安全
  - 用户环境禁用 `sudo` 权限 (除 `ubuntu`), 禁用 `XRT/setup.sh`, `Xilinx/settings64.sh` 等环境配置
  - 仅限使用脚本以容器模式启用开发环境
    ```bash
    /opt/xilinx/env_alloc [-d DeviceID,...] [-e] [-p jupyter|vnc] [-h]
    ```
  - 数据完全隔离, 仅限在容器 `/data`, `/home/$USER` 目录内读写、保留数据
  - 使用脚本创建用户，避免错误授权 (需要 `sudo` 权限)
    ```bash
    /home/ubuntu/new_user_init.sh <username>
    ```
- 资源管理
  - 选择分配板卡 (`-d DeviceID,...`)
  - 独占分配 (`-e`)
    - TODO: 限额分配
  - 挂载 `/home/$USER` 目录
- 服务接口
  - 提供 `jupyter-lab` (Python IDE) , `noVNC` (网页远程桌面) 服务支持 (`-p jupyter | vnc`)
  - 提供开放端口池，自动进行容器->主机端口映射，可使用浏览器通过 `192.168.20.40:2000-2010` 访问
- 已知问题
  - 现版本 `env_alloc` 属一次性分配，易受SSH断连影响，退出后直接释放容器，不保留 `/data`, `/home/$USER` 目录外的其他运行时数据
    - 缓解措施: 使用 `tmux`, `screen`, `nohup` 等工具进行后台管理
  - 在容器 `/home/$USER` 目录内读写文件，返回用户环境后可能引发权限问题 (文件所有权被设为root)

![](image.png)
