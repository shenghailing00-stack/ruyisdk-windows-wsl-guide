# 【RuyiSDK Windows/WSL 教程】第 01 节｜安装并验证 WSL 2 与 Ubuntu 24.04

> 本文在一台已经安装 WSL 的 Windows 11 电脑上完成最终状态验证。为保证
> 证据真实，本文不会把“既有环境验证”描述成“本次全新安装”。新电脑的
> 安装步骤采用 Microsoft 官方命令，执行后可使用同一套验收方法。

## 本节完成后你将得到什么

完成本节后，Windows 中将有一个可运行 Linux 命令的 Ubuntu 24.04 环境，
用于后续安装 RuyiSDK 包管理器、RISC-V 工具链和 QEMU。最终以
`wsl --list --verbose` 中 Ubuntu 对应的 `VERSION` 是否为 `2` 作为验收点。

![WSL 2 与 Ubuntu 24.04 实测结果](../assets/01-install-wsl2/02-wsl-ubuntu-environment.png)

## 实测环境

![Windows 11 版本与 Build](../assets/01-install-wsl2/01-winver.png)

| 项目 | 实测值 |
|---|---|
| 测试日期 | 2026-07-17（UTC+8） |
| Windows | Windows 11 专业版 25H2 |
| Windows Build | 26200.8457 |
| Windows 架构 | 64 位 |
| WSL | 2.6.3.0 |
| WSL 内核包 | 6.6.87.2-1 |
| Linux 内核 | 6.6.87.2-microsoft-standard-WSL2 |
| Linux 发行版 | Ubuntu 24.04.4 LTS（Noble Numbat） |
| Linux 架构 | x86_64 |
| 发行版类型 | WSL 2 |

本次预检还发现：系统默认发行版为 `Ubuntu`，而本系列明确使用
`Ubuntu-24.04`。因此后续脚本始终带 `-d Ubuntu-24.04`，避免命令跑到另一
个发行版中。

## 1. 运行只读预检

在教程仓库根目录双击 `START-01-PREFLIGHT.cmd`。也可以在 PowerShell 中
运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\01-wsl-helper.ps1 -Mode Preflight -OpenFolder
```

脚本只读取 Windows Build、架构、虚拟化和现有 WSL 状态，不安装软件、
不修改 Windows 功能，也不会重启。运行结束后只公开 `PUBLIC-REPORT.md`，
不要提交 `raw/` 文件夹。

本机预检结果显示 Windows 11 Build 26200、Hypervisor 已存在，并且
`Ubuntu` 与 `Ubuntu-24.04` 都已注册为 WSL 2，因此跳过重复安装。

## 2. 新电脑：安装 WSL 2 与 Ubuntu 24.04

如果预检没有发现 `Ubuntu-24.04`，请在管理员 PowerShell 中执行：

```powershell
wsl --set-default-version 2
wsl --install -d Ubuntu-24.04
```

也可以使用仓库脚本。它会请求管理员权限，并要求输入 `INSTALL` 二次确认：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\01-wsl-helper.ps1 -Mode Install -Distro Ubuntu-24.04
```

安装可能要求重启。若下载长时间停在 `0.0%`，Microsoft 文档提供了网络
下载分支：

```powershell
wsl --install --web-download -d Ubuntu-24.04
```

本测试机在录制前已经安装 WSL，因此没有生成或补造“本次安装成功”截图。

## 3. 首次启动 Ubuntu

从开始菜单打开“Ubuntu 24.04 LTS”。全新安装时，首次启动需要解包并创建
Linux 用户名和密码。输入密码时不会显示圆点或星号，这是 Linux 终端的
正常行为，输入完成后按 Enter 即可。

如果打开后直接出现终端提示符，说明该发行版已经完成初始化。

## 4. 验证 WSL、Ubuntu、内核和架构

最省事的方法是在仓库根目录双击 `START-01-VERIFY.cmd`。核心验收命令为：

```powershell
wsl --version
wsl --list --verbose
wsl -d Ubuntu-24.04 --cd / -- cat /etc/os-release
wsl -d Ubuntu-24.04 --cd / -- uname -mr
```

本机实测结果为：

- `Ubuntu-24.04` 状态为 `Running`，`VERSION` 为 `2`；
- Ubuntu 版本为 `24.04.4 LTS`；
- Linux 内核为 `6.6.87.2-microsoft-standard-WSL2`；
- 架构为 `x86_64`。

这说明后续可以在该发行版中继续准备 RuyiSDK 环境。

## 5. 本次实测发现的提示与处理

### 检测到 localhost 代理，但未镜像到 WSL

本机启动 Ubuntu 时出现：Windows 存在 localhost 代理配置，但 WSL 的 NAT
模式不能直接使用该 localhost 地址。这个警告不影响本节的版本与架构验收，
但可能影响后续下载 RuyiSDK。下一节会先测试 DNS 与 HTTPS，再决定是否需要
调整代理或 WSL 网络模式；不要在未确认代理软件和端口前直接复制配置。

### `VirtualizationFirmwareEnabled` 等字段显示 `False`

预检中部分底层 CPU 字段显示 `False`，但 Hypervisor 已存在，而且
`Ubuntu-24.04` 已经实际运行在 WSL 2。因此本机以功能验证结果为准，不进入
BIOS 重复修改虚拟化设置。

### 从其他盘符启动时出现路径转换失败

早期辅助脚本从 `G:` 盘工作目录启动 Linux 命令时曾出现路径转换失败。
当前脚本会先切换到 Windows 系统目录，并使用 WSL 的 `--cd /`，项目仓库
仍然可以保存在其他盘符。这个问题属于教程辅助脚本兼容性，不是 RuyiSDK
缺陷。

### `wsl --install` 只显示帮助

先列出在线发行版，再明确指定名称：

```powershell
wsl --list --online
wsl --install -d Ubuntu-24.04
```

### 出现 `0x80370102`

该错误通常与 Virtual Machine Platform 或 BIOS/UEFI 中的 CPU 虚拟化有关。
请保留完整错误文本和预检报告，根据电脑品牌确认虚拟化设置，不要连续运行
来源不明的修复命令。

## 本节验收

- [x] Windows Build 满足 WSL 当前安装要求。
- [x] `wsl --version` 能正常返回信息。
- [x] Ubuntu 24.04 已完成初始化并可执行 Linux 命令。
- [x] `Ubuntu-24.04` 的 `VERSION` 为 `2`。
- [x] Ubuntu 版本、内核和架构已由真实命令验证。
- [x] Windows 版本截图与终端截图均已完成隐私检查。

## 下一节

下一节将初始化 Ubuntu 的软件包环境，测试 DNS、HTTPS 与 localhost 代理
提示，并安装后续 RuyiSDK 教程需要的基础工具。

## 官方资料

- [Microsoft：安装 WSL](https://learn.microsoft.com/windows/wsl/install)
- [Microsoft：WSL 基本命令](https://learn.microsoft.com/windows/wsl/basic-commands)
- [Microsoft：WSL 故障排查](https://learn.microsoft.com/windows/wsl/troubleshooting)
