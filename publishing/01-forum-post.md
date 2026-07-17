# 【RuyiSDK Windows/WSL 教程 01】安装并验证 WSL 2 与 Ubuntu 24.04

大家好，这是 Windows + WSL 2 下 RuyiSDK 新手教程的第一节。本节目标是
为后续 Ruyi 包管理器、RISC-V 工具链和 QEMU 准备 Ubuntu 24.04 环境。

本次测试机在录制前已经安装 WSL，因此本文会明确区分“新电脑安装步骤”和
“既有环境验证”，不会用补造截图冒充本次全新安装。

## 实测环境

- Windows 11 专业版 25H2，Build 26200.8457
- WSL 2.6.3.0
- Ubuntu 24.04.4 LTS，WSL 2
- Linux 内核 6.6.87.2-microsoft-standard-WSL2
- x86_64

## 新电脑安装

在管理员 PowerShell 中执行：

```powershell
wsl --set-default-version 2
wsl --install -d Ubuntu-24.04
```

如果系统要求重启，请先保存工作再重启。首次打开 Ubuntu 时需要创建 Linux
用户名和密码；输入密码时终端不显示字符是正常现象。

## 验收命令

```powershell
wsl --version
wsl --list --verbose
wsl -d Ubuntu-24.04 --cd / -- cat /etc/os-release
wsl -d Ubuntu-24.04 --cd / -- uname -mr
```

验收重点是 `Ubuntu-24.04` 对应的 `VERSION` 为 `2`，并能正确输出 Ubuntu
版本、Linux 内核和架构。

> 发帖时在这里上传 `assets/01-install-wsl2/01-winver.png`。

> 接着上传 `assets/01-install-wsl2/02-wsl-ubuntu-environment.png`。

## 本次发现

测试机出现“localhost 代理未镜像到 NAT 模式 WSL”的警告。它不影响本节
版本验收，但可能影响后续下载。因此下一节会先测试 DNS 与 HTTPS，再决定
是否调整网络配置，不会直接复制未知代理参数。

完整图文、自动化脚本和测试记录：<GitHub article URL>  
配套视频：<Bilibili video URL>

欢迎 Windows + WSL 用户留言反馈实际环境差异。如果发现 RuyiSDK 本身的
问题，我会整理最小复现步骤并提交到对应仓库。
