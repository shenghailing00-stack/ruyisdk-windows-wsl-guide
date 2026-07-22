# 【RuyiSDK Windows/WSL 教程 02】初始化 Ubuntu 24.04：软件源、网络与基础工具

上一节已经在 Windows 中安装了 WSL 2 和 Ubuntu 24.04。这一节继续在 Ubuntu 终端中操作，检查系统、软件源和网络，并安装后面使用 RuyiSDK 时需要的基础工具。

## 完成本节后，你将能够

- 确认当前使用的是普通 Linux 用户；
- 检查 Ubuntu 版本、系统时间和处理器架构；
- 更新 Ubuntu 软件包索引；
- 安装并验证 `curl`、`wget`、`git` 等基础工具；
- 根据报错初步判断 DNS、代理或证书问题。

## 1. 进入 Ubuntu 24.04

打开 PowerShell，运行：

```powershell
wsl -d Ubuntu-24.04
```

看到类似下面的提示符后，就已经进入 Ubuntu：

```text
linuxuser@computer:~$
```

本节后面的命令都在 Ubuntu 终端中运行，不需要使用管理员 PowerShell。

## 2. 确认当前用户和目录

依次运行：

```bash
whoami
pwd
```

`whoami` 应显示上一节创建的 Linux 用户名，`pwd` 通常显示 `/home/用户名`。

如果 `whoami` 显示 `root`，先输入：

```bash
exit
```

然后重新用 `wsl -d Ubuntu-24.04` 进入 Ubuntu。日常安装和开发使用普通用户即可，需要管理员权限时再在命令前加 `sudo`。

## 3. 检查系统信息

先看系统日期和时间：

```bash
date
```

时间不必精确到秒，但日期、年份和时区不能明显错误。时间错误可能导致 HTTPS 证书验证失败。

再检查 Ubuntu 版本和处理器架构：

```bash
cat /etc/os-release
uname -m
```

系统信息中应包含 `Ubuntu 24.04` 和 `VERSION_ID="24.04"`。普通的 Intel 或 AMD Windows 电脑一般会显示：

```text
x86_64
```

后面下载 Ruyi 时，需要根据这里的结果选择对应架构的文件。

## 4. 检查 DNS 解析

运行：

```bash
getent hosts mirror.iscas.ac.cn
```

如果能返回一行或多行 IP 地址，说明 Ubuntu 可以把域名解析为网络地址。显示的 IP 可能变化，不需要与教程完全相同。

如果没有任何输出，或者出现 `Temporary failure in name resolution`，先跳到本文的“常见问题”部分检查 DNS。

## 5. 更新 Ubuntu 软件包索引

运行：

```bash
sudo apt update
```

第一次使用 `sudo` 时，终端会要求输入 Linux 密码。输入过程中不会显示字符或星号，输完直接按 Enter。

`apt update` 获取的是软件包列表，不是把系统中的所有软件都升级一遍。命令最后没有出现 `Failed to fetch` 等错误，就可以继续。

这一节不要求运行 `sudo apt upgrade`。完整升级会下载更多文件，也可能花费较长时间，不是安装 Ruyi 的必要步骤。

## 6. 安装基础工具

运行：

```bash
sudo apt install -y ca-certificates curl wget git file tar xz-utils
```

这些工具在后续下载、检查和解压文件时会用到：

| 工具 | 用途 |
|---|---|
| `ca-certificates` | 验证 HTTPS 网站的证书 |
| `curl`、`wget` | 从网页或镜像站下载文件 |
| `git` | 访问 Git 仓库 |
| `file` | 判断下载文件的类型和架构 |
| `tar`、`xz-utils` | 解压常见格式的软件包 |

如果部分工具已经存在，`apt` 会保留现有版本，不会重复安装。

## 7. 检查 HTTPS 连接

基础工具安装完成后，运行：

```bash
curl -I https://mirror.iscas.ac.cn
```

`-I` 表示只获取响应头，不下载网页正文。看到以 `HTTP/` 开头的状态行，例如 `HTTP/2 200`、`HTTP/1.1 200 OK` 或重定向状态码，说明 DNS、HTTPS 和证书验证可以正常工作。

返回的协议版本和状态码可能随镜像站配置变化，只要没有出现连接或证书错误即可。

## 8. 验证基础工具

运行：

```bash
curl --version
wget --version
git --version
file --version
```

每条命令都能显示版本信息，就说明工具已经可以使用。版本号不需要与教程相同。

最后回到上一节创建的工作目录：

```bash
mkdir -p ~/ruyisdk-work
cd ~/ruyisdk-work
pwd
```

`pwd` 应显示类似：

```text
/home/linuxuser/ruyisdk-work
```

## 9. 常见问题

### `Temporary failure resolving` 或 `Temporary failure in name resolution`

这类提示通常表示 DNS 解析失败。先确认 Windows 本身可以正常打开网页，然后退出 Ubuntu，在 PowerShell 中运行：

```powershell
wsl --shutdown
```

重新进入 Ubuntu 后，再执行：

```bash
getent hosts mirror.iscas.ac.cn
sudo apt update
```

如果仍然失败，保留完整报错信息，再检查 Windows 使用的 VPN、代理或校园网设置。不要直接照抄其他电脑的 `/etc/resolv.conf`。

### `Could not connect`、`Connection timed out` 或长时间无响应

域名能够解析但连接失败时，问题通常出在当前网络、代理或目标站点连接上。可以先用浏览器确认同一网址是否能够访问，再查看 Ubuntu 中是否设置了代理：

```bash
env | grep -i proxy
```

没有使用代理时，这条命令没有输出是正常的。使用代理时，WSL 中的地址和端口需要与自己的 Windows 代理设置一致，不能直接复制其他人的配置。

### `Certificate verification failed`

先重新检查日期：

```bash
date
```

日期正常时，可以重新安装证书包：

```bash
sudo apt install --reinstall ca-certificates
sudo update-ca-certificates
```

然后再次运行 `curl -I https://mirror.iscas.ac.cn`。

### `sudo` 密码输入后提示错误

这里需要输入的是安装 Ubuntu 时创建的 Linux 密码，不是 Windows 的 PIN 或登录密码。终端不显示输入内容属于正常现象。

## 10. 本节检查

- [ ] `whoami` 显示普通 Linux 用户名；
- [ ] 系统为 Ubuntu 24.04；
- [ ] 已确认处理器架构；
- [ ] `sudo apt update` 能够正常完成；
- [ ] `curl`、`wget`、`git` 和 `file` 能显示版本信息；
- [ ] `curl -I https://mirror.iscas.ac.cn` 没有连接或证书错误；
- [ ] 当前工作目录为 `~/ruyisdk-work`。

以上检查都通过后，就可以安装 RuyiSDK 包管理器了。

## 下一节

[下一节：安装 RuyiSDK 包管理器并完成首次验证](03-install-ruyi.md)

## 参考资料

- [Ubuntu：APT 使用说明](https://documentation.ubuntu.com/server/how-to/software/package-management/)
- [Microsoft：排查 WSL 问题](https://learn.microsoft.com/windows/wsl/troubleshooting)
- [RuyiSDK 包管理器安装文档](https://ruyisdk.org/docs/Package-Manager/installation/)
