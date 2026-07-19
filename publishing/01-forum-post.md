# 【RuyiSDK Windows/WSL 教程 01】安装并学会使用 WSL 2 与 Ubuntu 24.04

RuyiSDK 包管理器以及后续使用的 RISC-V 工具链主要在 Linux 环境中运行。
对于 Windows 用户，比较方便的做法是在 Windows 10/11 中启用 WSL 2，再安装
Ubuntu 24.04。本节从零说明安装、首次登录、窗口区别、基本 Linux 操作和最终
验收。

本文使用的测试机已经安装过 WSL。安装部分采用 Microsoft 官方流程，版本、
内核和架构信息来自真实环境。已经安装 WSL 的读者不需要卸载重装，直接运行
文中的验证命令即可。

## 一、Windows、WSL 2 和 Ubuntu 是什么关系

- Windows：日常使用的桌面系统，负责开始菜单、文件管理、PowerShell 和录屏；
- WSL 2：让 Windows 能够运行 Linux 的系统组件；
- Ubuntu 24.04：运行在 WSL 2 中的 Linux 发行版，后续在这里使用 RuyiSDK。

简单来说，Windows 仍然是主系统，Ubuntu 是 Windows 中的 Linux 开发环境。

## 二、检查 Windows 版本

按下 `Win + R`，输入 `winver`，再按 Enter。本文的一键安装命令适用于
Windows 11，或 Windows 10 版本 2004、Build 19041 及以上版本。

发帖时上传：`assets/01-install-wsl2/01-winver.png`

本次实测环境：

- Windows 11 专业版 25H2，Build 26200.8457；
- WSL 2.6.3.0；
- Ubuntu 24.04.4 LTS；
- Linux 内核 6.6.87.2-microsoft-standard-WSL2；
- x86_64。

## 三、新电脑安装 WSL 2 和 Ubuntu 24.04

### 1. 打开管理员 PowerShell

打开开始菜单，搜索“PowerShell”或“终端”，右键选择“以管理员身份运行”。
窗口提示符通常以 `PS C:\...>` 开头。

### 2. 查看可安装的 Ubuntu 名称

```powershell
wsl --list --online
```

确认列表中存在 `Ubuntu-24.04`。发行版名称需要按照列表中的写法输入。

### 3. 设置新发行版默认使用 WSL 2

```powershell
wsl --set-default-version 2
```

### 4. 安装 Ubuntu 24.04

```powershell
wsl --install -d Ubuntu-24.04
```

等待下载和安装完成。如果系统要求重启，请保存文件后重启 Windows。

## 四、首次打开 Ubuntu

重启后，从开始菜单打开“Ubuntu 24.04 LTS”。第一次启动会解压文件，并要求
创建 Linux 用户名和密码。

输入密码时，屏幕不会显示字符、圆点或星号，这是正常现象。用户名和密码只
属于 Ubuntu，不要求与 Windows 账户相同。看到类似下面的提示符，就表示已经
进入 Linux：

```text
linuxuser@computer:~$
```

## 五、分清两个命令窗口

| 窗口 | 常见提示符 | 应该运行的命令 |
|---|---|---|
| PowerShell | `PS C:\...>` | `wsl --install`、`wsl --list --verbose` |
| Ubuntu/Bash | `user@host:~$` | `pwd`、`ls`、`cd`、后续 `ruyi` 命令 |

`wsl` 管理命令通常在 PowerShell 中运行；Linux 命令和后续 RuyiSDK 命令在
Ubuntu 中运行。

## 六、验证 WSL 2 和 Ubuntu

打开普通 PowerShell，依次运行：

```powershell
wsl --version
wsl --list --verbose
wsl -d Ubuntu-24.04 --cd / -- cat /etc/os-release
wsl -d Ubuntu-24.04 --cd / -- uname -mr
```

检查以下结果：

1. `wsl --version` 能返回版本信息；
2. `Ubuntu-24.04` 所在行的 `VERSION` 为 `2`；
3. Ubuntu 版本为 24.04；
4. 内核名称中包含 `WSL2`；
5. 能正常显示处理器架构。

发帖时上传：`assets/01-install-wsl2/02-wsl-ubuntu-environment.png`

`STATE` 显示 `Running` 或 `Stopped` 都正常，它只代表发行版此刻是否运行。
内核小版本也可能随 WSL 更新而变化，不必与本文数字完全一致。

## 七、怎样进入、退出和使用 Ubuntu

从 PowerShell 进入指定发行版：

```powershell
wsl -d Ubuntu-24.04
```

进入 Ubuntu 后，尝试下面几条基础命令：

```bash
pwd
ls -la
cd ~
mkdir -p ~/ruyisdk-work
cd ~/ruyisdk-work
pwd
```

其中 `~` 代表 Linux 用户的个人主目录。后续 RuyiSDK 示例建议统一放在
`~/ruyisdk-work` 中。

需要从 Windows 文件资源管理器查看当前 Linux 目录时，在 Ubuntu 中运行：

```bash
explorer.exe .
```

命令末尾的点号代表当前目录。退出 Ubuntu、回到 PowerShell时运行：

```bash
exit
```

## 八、Windows 和 Linux 文件路径

- Windows 的 `C:\` 在 Ubuntu 中对应 `/mnt/c/`；
- Linux 用户目录一般是 `/home/你的Linux用户名/`；
- 在 Windows 文件资源管理器地址栏输入 `\\wsl$`，可以查看 WSL 文件；
- 主要由 Linux 工具处理的项目，建议存放在 Linux 用户目录中。

## 九、常见问题

### `wsl --install` 只显示帮助

先查看在线发行版，再明确指定 Ubuntu 24.04：

```powershell
wsl --list --online
wsl --install -d Ubuntu-24.04
```

### 下载停在 0.0%

```powershell
wsl --install --web-download -d Ubuntu-24.04
```

### 出现 `0x80370102`

通常需要检查 Virtual Machine Platform 和 BIOS/UEFI 中的 CPU 虚拟化设置。
请保留完整错误文本，并参考电脑厂商说明和 Microsoft WSL 故障排查文档。

### 出现 localhost 代理警告

本次测试机出现了“localhost 代理未镜像到 NAT 模式 WSL”的提示。它不影响
本节版本验收，但可能影响后续下载。本系列下一节会测试 DNS 和 HTTPS，再根据
真实网络环境处理，不直接复制未知代理地址。

## 十、本节完成标准

- [ ] 能分清 PowerShell 与 Ubuntu 终端；
- [ ] `Ubuntu-24.04` 已安装并使用 WSL 2；
- [ ] 能进入和退出 Ubuntu；
- [ ] 能运行 `pwd`、`ls` 和 `cd`；
- [ ] 已创建 `~/ruyisdk-work`；
- [ ] 能从 Windows 文件资源管理器查看 Linux 目录。

完整命令、实测截图和检查脚本：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

配套视频：审核通过并发布后补充。

下一节将检查 Ubuntu 网络，并安装、验证 RuyiSDK 包管理器。
