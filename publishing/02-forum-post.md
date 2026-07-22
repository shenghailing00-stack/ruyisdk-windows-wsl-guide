# 【RuyiSDK Windows/WSL 教程 02】初始化 Ubuntu 24.04：软件源、网络与基础工具

上一节已经完成 WSL 2 和 Ubuntu 24.04 的安装。这一节继续在 Ubuntu 中检查系统信息、软件源和网络，并安装后续使用 RuyiSDK 时需要的基础工具。

## 一、进入 Ubuntu

在 PowerShell 中运行：

```powershell
wsl -d Ubuntu-24.04
```

看到 `用户名@计算机名:~$` 后，下面的命令都在 Ubuntu 终端中执行。

## 二、确认用户和系统信息

```bash
whoami
pwd
date
cat /etc/os-release
uname -m
```

`whoami` 应显示普通 Linux 用户名，系统版本应为 Ubuntu 24.04。常见 Intel 或 AMD Windows 电脑的架构通常显示为 `x86_64`。

## 三、检查 DNS

```bash
getent hosts mirror.iscas.ac.cn
```

能够返回 IP 地址，说明 Ubuntu 可以正常解析域名。IP 地址可能变化，不需要与示例一致。

## 四、更新软件包索引

```bash
sudo apt update
```

第一次使用 `sudo` 时需要输入 Linux 密码，终端不会显示输入内容。`apt update` 只更新软件包列表，本节不要求执行完整系统升级。

## 五、安装基础工具

```bash
sudo apt install -y ca-certificates curl wget git file tar xz-utils
```

这些工具分别用于 HTTPS 证书验证、文件下载、访问 Git 仓库、识别文件类型和解压软件包。

## 六、检查 HTTPS 和工具版本

```bash
curl -I https://mirror.iscas.ac.cn
curl --version
wget --version
git --version
file --version
```

`curl -I` 能返回 HTTP 状态行，并且其余命令能够显示版本信息，就可以继续后面的安装。

## 七、进入工作目录

```bash
mkdir -p ~/ruyisdk-work
cd ~/ruyisdk-work
pwd
```

后续下载的 Ruyi 安装文件和示例项目可以统一放在这个目录中。

## 八、常见问题

出现 `Temporary failure resolving` 时，先确认 Windows 可以上网，然后退出 Ubuntu，在 PowerShell 中运行 `wsl --shutdown`，重新进入 Ubuntu 后再试。

出现连接超时或无法连接时，检查当前网络和代理设置。可以用 `env | grep -i proxy` 查看 Ubuntu 中是否设置了代理，但不要直接复制其他电脑的地址和端口。

出现证书错误时，先用 `date` 检查系统日期，再重新安装 `ca-certificates`。

## 九、本节完成标准

- [ ] 当前使用普通 Linux 用户；
- [ ] 已确认 Ubuntu 版本和处理器架构；
- [ ] `sudo apt update` 能够完成；
- [ ] DNS 和 HTTPS 连接正常；
- [ ] `curl`、`wget`、`git` 和 `file` 可以使用；
- [ ] 已进入 `~/ruyisdk-work`。

完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/02-prepare-ubuntu.md

下一节将下载并安装 RuyiSDK 包管理器，刷新软件包索引，并完成第一次软件包查询。
