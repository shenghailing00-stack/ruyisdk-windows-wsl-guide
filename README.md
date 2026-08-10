# Windows + WSL 2 下的 RuyiSDK 新手教程

这套教程面向使用 Windows 10/11、此前没有接触过 Linux 的读者。内容从 WSL 2 和 Ubuntu 环境准备开始，逐步介绍 Ruyi 包管理器、虚拟环境、RISC-V 工具链、QEMU、VS Code 和开发板连接。

## 当前进度

| 单元 | 内容 | 状态 |
|---|---|---|
| 01 | 安装 WSL 2 与 Ubuntu 24.04 | 图文与视频已完成并发布 |
| 02 | 初始化 Ubuntu：软件源、网络与基础工具 | 图文与视频已完成并发布 |
| 03 | 安装 RuyiSDK 包管理器并完成首次验证 | 图文与视频已完成并发布 |
| 04 | 查询、安装与管理 Ruyi 软件包 | 图文教程已完成 |
| 05 | 创建并使用 Ruyi 虚拟环境 | 图文教程已完成 |
| 06 | 交叉编译第一个 RISC-V 程序 | 图文教程已完成 |
| 07 | 使用 QEMU 运行 RISC-V 程序 | 图文教程已完成 |
| 08 | 使用 VS Code Remote - WSL 开发 | 计划中 |
| 09 | 通过 SSH 连接 RISC-V 开发板 | 计划中 |

## 教程目录

1. [安装 WSL 2 与 Ubuntu 24.04](docs/01-install-wsl2.md)
2. [初始化 Ubuntu：软件源、网络与基础工具](docs/02-prepare-ubuntu.md)
3. [安装 RuyiSDK 包管理器并完成首次验证](docs/03-install-ruyi.md)
4. [查询、安装与管理 Ruyi 软件包](docs/04-manage-packages.md)
5. [创建并使用 Ruyi 虚拟环境](docs/05-create-venv.md)
6. [交叉编译第一个 RISC-V 程序](docs/06-cross-compile-hello.md)
7. [使用 QEMU 运行 RISC-V 程序](docs/07-run-with-qemu.md)
8. 使用 VS Code Remote - WSL 开发
9. 通过 SSH 连接 RISC-V 开发板

前七节从 Windows 环境准备开始，依次完成 Ubuntu 初始化、Ruyi 包管理器安装、工具链与模拟器安装、Ruyi 虚拟环境创建，以及第一个 RISC-V 程序的交叉编译与 QEMU 运行。后续将在 VS Code 中复现同一开发流程，再连接实际的 RISC-V 开发板。

## 说明

不同 Windows、WSL 和 Ruyi 版本显示的具体版本号可能不同。教程中的版本号和输出用于说明检查方法，不要求与截图完全一致。
