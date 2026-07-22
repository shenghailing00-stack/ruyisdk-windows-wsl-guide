# 【RuyiSDK Windows/WSL 教程 01】安装 WSL 2 与 Ubuntu 24.04

RuyiSDK 包管理器及后续使用的 RISC-V 工具链主要运行在 Linux 环境中。Windows 用户可以通过 WSL 2 使用 Ubuntu，不需要安装双系统。本节从检查 WSL 开始，带你完成 Ubuntu 24.04 的安装和基本设置。

## 完成本节后，你将能够

- 在 Windows 中安装并启动 Ubuntu 24.04；
- 确认 Ubuntu 使用的是 WSL 2；
- 分清 PowerShell 和 Ubuntu 终端；
- 进入 Linux 工作目录并执行几条基础命令。

![WSL 2 与 Ubuntu 24.04 验证结果](../assets/01-install-wsl2/02-wsl-ubuntu-environment.png)

## 1. 检查 Windows 版本

按 `Win + R`，输入 `winver`，再按 Enter。

本文中的安装命令适用于 Windows 11，或 Windows 10 版本 2004、Build 19041 及以上版本。如果系统版本更早，请先通过 Windows Update 更新。

![查看 Windows 版本](../assets/01-install-wsl2/01-winver.png)

## 2. 打开管理员 PowerShell

打开开始菜单，搜索“PowerShell”或“终端”，右键选择“以管理员身份运行”。出现用户账户控制提示时选择“是”。

窗口提示符一般以 `PS C:\\...>` 开头。下面用于管理 WSL 的命令都在这个窗口中运行。

## 3. 检查并准备 WSL

先运行：

```powershell
wsl --version
```

如果能够看到 WSL 和内核版本，说明 WSL 已经安装，可以继续第 4 步。

如果系统提示无法识别 `wsl`，或者没有显示版本信息，运行：

```powershell
wsl --install --no-distribution
```

这条命令只安装 WSL，不会同时安装 Linux 发行版。命令执行完成后，按照系统提示重启 Windows。重启后重新打开管理员 PowerShell，再运行一次 `wsl --version`。

然后设置新安装的 Linux 发行版默认使用 WSL 2：

```powershell
wsl --set-default-version 2
```

这个设置不会删除或修改已经安装的发行版。

## 4. 安装 Ubuntu 24.04

先查看当前可通过 WSL 安装的发行版：

```powershell
wsl --list --online
```

在列表中找到 `Ubuntu-24.04`，然后运行：

```powershell
wsl --install -d Ubuntu-24.04
```

等待下载和安装完成，中途不要关闭终端。如果系统要求重启，请保存正在编辑的文件后再重启。

如果电脑上已经安装过 Ubuntu，也可以先运行下面的命令查看现有发行版：

```powershell
wsl --list --verbose
```

列表中已有 `Ubuntu-24.04` 时，不需要重复安装，直接继续下一步。

## 5. 首次启动 Ubuntu

从开始菜单搜索并打开“Ubuntu 24.04 LTS”。第一次启动时需要等待初始化，随后终端会要求创建 Linux 用户。

1. 在 `Enter new UNIX username` 后输入用户名；
2. 在 `New password` 后输入密码；
3. 再输入一次密码确认。

输入密码时，屏幕不会显示字符、圆点或星号，这是 Linux 终端的正常行为。用户名和密码只属于这个 Ubuntu 环境，不必与 Windows 账户相同。

初始化完成后，会看到类似下面的提示符：

```text
linuxuser@computer:~$
```

这说明已经进入 Ubuntu 终端。

## 6. 验证安装结果

打开普通 PowerShell，运行：

```powershell
wsl --list --verbose
```

找到 `Ubuntu-24.04` 所在行，确认最后一列 `VERSION` 为 `2`。`STATE` 显示 `Running` 或 `Stopped` 都是正常的，只表示 Ubuntu 当前是否正在运行。

如果 `VERSION` 为 `1`，可以转换为 WSL 2：

```powershell
wsl --set-version Ubuntu-24.04 2
```

继续检查 Ubuntu 版本：

```powershell
wsl -d Ubuntu-24.04 -- cat /etc/os-release
```

输出中应包含 `Ubuntu 24.04` 和 `VERSION_ID="24.04"`。

最后检查 Linux 内核和处理器架构：

```powershell
wsl -d Ubuntu-24.04 -- uname -mr
```

通常可以看到 `microsoft-standard-WSL2` 和 `x86_64`。WSL 更新后，内核的小版本号可能变化，不需要与教程截图完全一致。

## 7. 分清 PowerShell 和 Ubuntu 终端

| 窗口 | 常见提示符 | 用途 |
|---|---|---|
| PowerShell | `PS C:\\...>` | 安装和管理 WSL、查看发行版 |
| Ubuntu/Bash | `user@host:~$` | 执行 Linux、RuyiSDK 和工具链命令 |

后面的教程会继续标明命令应在哪个终端运行。`wsl` 命令一般在 PowerShell 中运行，`sudo`、`apt`、`pwd` 等 Linux 命令在 Ubuntu 中运行。

## 8. 进入、退出和关闭 Ubuntu

从 PowerShell 进入 Ubuntu 24.04：

```powershell
wsl -d Ubuntu-24.04
```

退出 Ubuntu、返回 PowerShell：

```bash
exit
```

平时直接关闭终端即可。排查网络或配置问题时，可以在 PowerShell 中关闭所有 WSL 发行版：

```powershell
wsl --shutdown
```

运行前请先保存 Ubuntu 中正在进行的任务。

## 9. 熟悉几条 Linux 命令

下面的命令在 Ubuntu 终端中执行。

查看当前目录：

```bash
pwd
```

查看目录中的文件：

```bash
ls -la
```

创建后续教程使用的工作目录：

```bash
mkdir -p ~/ruyisdk-work
cd ~/ruyisdk-work
pwd
```

最后应显示类似 `/home/linuxuser/ruyisdk-work` 的路径。

在 Windows 文件资源管理器中打开当前 Linux 目录：

```bash
explorer.exe .
```

命令末尾的点号表示当前目录。

## 10. Windows 路径与 Linux 路径

- Windows 的 `C:\\` 在 Ubuntu 中对应 `/mnt/c/`；
- Windows 的 `D:\\` 对应 `/mnt/d/`；
- Linux 用户的个人目录通常是 `/home/用户名/`；
- 在 Windows 文件资源管理器地址栏输入 `\\\\wsl$`，可以查看 WSL 中的文件。

主要通过 Linux 工具处理的项目，建议放在 `~/ruyisdk-work` 这类 Linux 目录中。这样通常比放在 `/mnt/c/` 下有更好的文件操作性能，也能减少权限差异带来的问题。

## 11. 其他 Linux 发行版怎么安装

`wsl --list --online` 显示的是当前可以直接通过 WSL 安装的发行版。列表中的发行版可以使用：

```powershell
wsl --install -d 发行版名称
```

如果某个发行版不在列表中，不能直接把名称填入这条命令。应先查看该发行版是否提供 WSL 镜像或官方导入方法。有兼容的 rootfs 文件时，可以使用 `wsl --import` 导入。

RevyOS 等面向 RISC-V 平台的系统还涉及处理器架构问题，不属于本节在 x86_64 Windows 电脑上直接安装 Ubuntu 的范围，后续可以结合 QEMU 或开发板单独介绍。

## 12. 常见问题

### 下载长时间停在 0.0%

可以尝试：

```powershell
wsl --install --web-download -d Ubuntu-24.04
```

如果仍然失败，先确认 Windows 可以正常访问 Microsoft 服务。

### 出现 `0x80370102`

这个错误通常与 Virtual Machine Platform 或 BIOS/UEFI 中的 CPU 虚拟化设置有关。请保留完整错误信息，并根据电脑品牌查询虚拟化功能的开启方法。

### 出现 localhost 代理警告

这个提示一般不影响 Ubuntu 启动，但可能影响后续下载软件包。先不要照抄其他电脑的代理地址。下一节会检查 DNS 和 HTTPS 连接，再根据实际网络环境处理。

### 电脑中有多个 Ubuntu

先在 PowerShell 中运行：

```powershell
wsl --list --verbose
```

进入 Ubuntu 时明确指定发行版：

```powershell
wsl -d Ubuntu-24.04
```

## 13. 本节检查

- [ ] `wsl --version` 能显示版本信息；
- [ ] `wsl --list --verbose` 中存在 `Ubuntu-24.04`；
- [ ] `Ubuntu-24.04` 的 `VERSION` 为 `2`；
- [ ] 能进入和退出 Ubuntu；
- [ ] 能运行 `pwd`、`ls` 和 `cd`；
- [ ] 已创建 `~/ruyisdk-work`。

完成以上检查后，Windows + WSL 2 + Ubuntu 24.04 环境就准备好了。

## 下一节

[下一节：初始化 Ubuntu，检查软件源、网络与基础工具](02-prepare-ubuntu.md)

## 参考资料

- [Microsoft：安装 WSL](https://learn.microsoft.com/windows/wsl/install)
- [Microsoft：WSL 基本命令](https://learn.microsoft.com/windows/wsl/basic-commands)
- [Microsoft：导入 Linux 发行版](https://learn.microsoft.com/windows/wsl/use-custom-distro)
- [Microsoft：在 Windows 与 Linux 文件系统之间工作](https://learn.microsoft.com/windows/wsl/filesystems)
- [Microsoft：WSL 故障排查](https://learn.microsoft.com/windows/wsl/troubleshooting)
