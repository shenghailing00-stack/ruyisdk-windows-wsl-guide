# Windows + WSL 2 下的 RuyiSDK 新手教程

这套教程面向使用 Windows 10/11、此前没有接触过 Linux 的读者。内容从 WSL 2 和 Ubuntu 环境准备开始，逐步介绍 Ruyi 包管理器、虚拟环境、RISC-V 工具链、QEMU 和 VS Code。

## 当前进度

| 单元 | 内容 | 状态 |
|---|---|---|
| 01 | 安装 WSL 2 与 Ubuntu 24.04 | 图文教程已完成，视频待审核 |

## 第 01 节

- [图文教程：安装 WSL 2 与 Ubuntu 24.04](docs/01-install-wsl2.md)
- [视频脚本与字幕](video-scripts/)
- [配套截图](assets/01-install-wsl2/README.md)

第 01 节先检查电脑上的 WSL 状态；如果尚未安装，则单独安装 WSL 并重启。随后通过 WSL 安装 Ubuntu 24.04，完成首次启动、版本验证和几项基本操作。完成这些步骤后，就可以继续配置 Ubuntu 网络并安装 RuyiSDK。

## 说明

不同 Windows 和 WSL 版本显示的具体版本号可能不同。只要命令能够正常执行，`Ubuntu-24.04` 已安装且 `VERSION` 为 `2`，就可以继续后面的教程。
