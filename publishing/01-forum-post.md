# 【RuyiSDK Windows/WSL 教程 01】安装 WSL 2 与 Ubuntu 24.04

RuyiSDK 包管理器和后续使用的 RISC-V 工具链主要运行在 Linux 环境中。Windows 用户不必安装双系统，通过 WSL 2 就可以在 Windows 中使用 Ubuntu。本节从检查 WSL 开始，介绍 Ubuntu 24.04 的安装、首次启动和基本操作。

## 一、检查 Windows 版本

按 `Win + R`，输入 `winver`，再按 Enter。本文中的命令适用于 Windows 11，或 Windows 10 版本 2004、Build 19041 及以上版本。

## 二、检查并安装 WSL

从开始菜单搜索“PowerShell”或“终端”，右键选择“以管理员身份运行”。先输入：

```powershell
wsl --version
```

能够显示 WSL 和内核版本时，说明 WSL 已经安装，可以继续安装 Ubuntu。

如果系统无法识别 `wsl`，或者没有显示版本信息，运行：

```powershell
wsl --install --no-distribution
```

命令完成后按照提示重启 Windows，再次打开管理员 PowerShell，运行：

```powershell
wsl --set-default-version 2
```

## 三、安装 Ubuntu 24.04

先查看可安装的发行版：

```powershell
wsl --list --online
```

确认列表中有 `Ubuntu-24.04` 后运行：

```powershell
wsl --install -d Ubuntu-24.04
```

如果电脑上已经装过 Ubuntu，可以先用下面的命令检查，不需要重复安装：

```powershell
wsl --list --verbose
```

## 四、首次启动 Ubuntu

从开始菜单打开“Ubuntu 24.04 LTS”。第一次启动时需要等待初始化，然后按照提示创建 Linux 用户名和密码。

输入密码时，屏幕不会显示字符或星号，这是正常现象。初始化完成后看到类似 `linuxuser@computer:~$` 的提示符，就说明已经进入 Ubuntu。

## 五、验证安装结果

回到 PowerShell，运行：

```powershell
wsl --list --verbose
```

确认 `Ubuntu-24.04` 所在行的 `VERSION` 为 `2`。如果显示为 `1`，运行：

```powershell
wsl --set-version Ubuntu-24.04 2
```

继续检查 Ubuntu 版本、Linux 内核和处理器架构：

```powershell
wsl -d Ubuntu-24.04 -- cat /etc/os-release
wsl -d Ubuntu-24.04 -- uname -mr
```

输出中应能看到 Ubuntu 24.04，以及带有 `WSL2` 的内核信息。具体的小版本号可能随 WSL 更新而变化。

## 六、分清两个终端

| 窗口 | 常见提示符 | 用途 |
|---|---|---|
| PowerShell | `PS C:\\...>` | 安装和管理 WSL |
| Ubuntu/Bash | `user@host:~$` | 执行 Linux、RuyiSDK 和工具链命令 |

从 PowerShell 进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

从 Ubuntu 返回 PowerShell：

```bash
exit
```

## 七、熟悉基本操作

进入 Ubuntu 后运行：

```bash
pwd
ls -la
mkdir -p ~/ruyisdk-work
cd ~/ruyisdk-work
pwd
```

`~` 表示当前 Linux 用户的个人目录。后续 RuyiSDK 示例可以统一放在 `~/ruyisdk-work` 中。

如果想用 Windows 文件资源管理器查看当前目录，运行：

```bash
explorer.exe .
```

## 八、关于其他 Linux 发行版

`wsl --list --online` 中列出的发行版可以通过 `wsl --install -d` 直接安装。对于列表中没有的发行版，应先查看官方是否提供 WSL 镜像或导入方法，不能直接把名称填进安装命令。

RevyOS 等面向 RISC-V 平台的系统还涉及架构差异，不属于本节在 x86_64 Windows 电脑上直接安装 Ubuntu 的范围，后续可以结合 QEMU 或开发板单独介绍。

## 九、常见问题

下载长时间停在 0.0% 时，可以尝试：

```powershell
wsl --install --web-download -d Ubuntu-24.04
```

出现 `0x80370102` 时，通常需要检查 Virtual Machine Platform 和 BIOS/UEFI 中的 CPU 虚拟化设置。

出现 localhost 代理警告时，Ubuntu 通常仍能启动，但后续下载可能受影响。下一节会检查 DNS 和 HTTPS 连接。

## 十、本节完成标准

- [ ] `wsl --version` 能显示版本信息；
- [ ] `Ubuntu-24.04` 已安装并使用 WSL 2；
- [ ] 能进入和退出 Ubuntu；
- [ ] 能运行 `pwd`、`ls` 和 `cd`；
- [ ] 已创建 `~/ruyisdk-work`。

完整图文教程和配套命令：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

下一节将检查 Ubuntu 网络，并安装、验证 RuyiSDK 包管理器。
