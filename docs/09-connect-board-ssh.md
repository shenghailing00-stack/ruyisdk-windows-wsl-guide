# 【RuyiSDK Windows/WSL 教程 09】通过 SSH 连接 RISC-V 开发板

上一节已经在 VS Code 的 WSL 环境中完成编辑、交叉编译和 QEMU 运行。这一节把 `hello-riscv64` 传到实际的 RISC-V Linux 开发板，通过 SSH 登录开发板，并在板端运行程序。

本节适用于已经安装 Linux、能够联网并提供 SSH 服务的 RISC-V 开发板。不同板卡的系统镜像、默认用户名、联网方式和 SSH 开启方法差别很大，这些信息必须以开发板官方文档为准。本教程不会假设一个通用的默认账号。

如果暂时没有开发板，可以先阅读本节，但不能完成板端运行检查。前一节的 QEMU 结果仍然有效。

## 完成本节后，你将能够

- 确认连接开发板所需的用户名、IP 和认证方式；
- 在 WSL 中检查 SSH 客户端和网络连通性；
- 第一次通过 SSH 登录 RISC-V Linux 开发板；
- 确认远端处理器架构和系统信息；
- 使用 SCP 把交叉编译结果上传到开发板；
- 在真实 RISC-V 系统中运行程序并检查退出状态；
- 从开发板取回文件；
- 判断常见的网络、认证、主机密钥和兼容性问题。

## 1. 准备开发板连接信息

开始前，先从开发板说明书、系统镜像说明或板端终端确认以下信息：

| 信息 | 示例 | 说明 |
|---|---|---|
| 开发板用户名 | `debian` | 示例不能当作所有板卡的默认值 |
| 开发板 IP | `192.168.1.50` | 应是开发板当前在局域网中的实际地址 |
| SSH 端口 | `22` | 本节按默认端口 22 演示 |
| 认证方式 | 密码或 SSH 密钥 | 第一次连接常见为密码 |
| 系统类型 | Debian、Ubuntu、RevyOS 等 | 必须是能够提供 SSH 的 Linux 系统 |

不要直接照抄示例用户名和 IP。开发板重启或重新联网后，DHCP 分配的 IP 可能变化。

## 2. 启动开发板并确认 IP

按照开发板官方文档完成供电、启动和联网。电脑与开发板通常需要连接到同一个可互通的局域网。

如果能够使用开发板的屏幕、串口或本地终端，可以在开发板上运行：

```bash
ip -br address
```

在有线网卡或无线网卡一行寻找类似 `192.168.x.x` 的地址。不要使用 `127.0.0.1`，它只代表开发板自身。

如果无法进入板端终端，请按照开发板说明书从路由器设备列表、厂商工具或串口启动日志中查找 IP。USB 网络、直连网线和 Wi-Fi 的配置方式可能不同。

## 3. 在 WSL 中检查 SSH 客户端

在 PowerShell 中进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

下面的命令都在 Ubuntu 终端或已经连接 WSL 的 VS Code 集成终端中运行。先检查 `ssh` 和 `scp`：

```bash
command -v ssh
command -v scp
ssh -V
```

正常应显示 `/usr/bin/ssh`、`/usr/bin/scp` 和 OpenSSH 版本信息。

如果找不到命令，安装客户端：

```bash
sudo apt update
sudo apt install -y openssh-client
```

这里安装的是电脑端的 SSH 客户端，不会替开发板开启 SSH 服务。

## 4. 填入开发板的实际信息

在 WSL 终端中输入下面两行，但必须把引号中的内容替换成自己的实际用户名和 IP：

```bash
BOARD_USER='你的开发板用户名'
BOARD_IP='你的开发板IP地址'
```

例如，只有当开发板实际用户名为 `debian`、IP 为 `192.168.1.50` 时，才应写成：

```bash
BOARD_USER='debian'
BOARD_IP='192.168.1.50'
```

检查即将使用的目标：

```bash
printf 'SSH target: %s@%s\n' "$BOARD_USER" "$BOARD_IP"
```

输出中的用户名和 IP 必须与开发板实际信息一致。只要当前 WSL 终端不关闭，后面的命令都可以继续使用这两个变量。

## 5. 检查基本网络连通性

运行：

```bash
ping -c 4 "$BOARD_IP"
```

正常情况下会收到 4 次回复，并显示丢包统计。可以按 `Ctrl+C` 提前停止持续运行的 `ping`，但这里的 `-c 4` 会在 4 次后自动结束。

部分系统会屏蔽 ICMP，因此 `ping` 失败不一定说明 SSH 一定不可用。只要 IP 已确认，仍可继续尝试下一步的 SSH 连接。

## 6. 第一次通过 SSH 登录

运行：

```bash
ssh "$BOARD_USER@$BOARD_IP"
```

第一次连接某台开发板时，通常会看到主机真实性提示和一段指纹。确认 IP 正确，并尽量与开发板文档或可信来源提供的指纹核对后，输入：

```text
yes
```

随后按提示输入开发板密码。Linux 终端输入密码时不会显示字符或星号，这是正常现象，输入完成后直接按 Enter。

登录成功后，终端提示符会从 WSL 电脑切换为开发板上的用户名和主机名。

## 7. 确认当前确实在 RISC-V 开发板

登录开发板后运行：

```bash
whoami
hostname
uname -m
cat /etc/os-release
```

正常情况下：

- `whoami` 与登录用户名一致；
- `hostname` 显示开发板的主机名；
- `uname -m` 显示 `riscv64`；
- `/etc/os-release` 显示开发板当前 Linux 发行版。

如果 `uname -m` 不是 `riscv64`，应先确认是否连接错设备或使用了其他架构的系统，不要继续把本教程的 RISC-V 程序当作已经完成板端验证。

## 8. 在开发板上创建接收目录

仍在开发板终端中运行：

```bash
mkdir -p ~/ruyisdk-work/hello-ruyi
cd ~/ruyisdk-work/hello-ruyi
pwd
```

正常应显示开发板用户主目录下的 `ruyisdk-work/hello-ruyi`。然后退出开发板：

```bash
exit
```

终端会回到 WSL。前面设置的 `BOARD_USER` 和 `BOARD_IP` 变量仍然保留。

## 9. 在 WSL 中检查待上传程序

回到 WSL 后运行：

```bash
cd ~/ruyisdk-work/hello-ruyi
pwd
file ./hello-riscv64
```

`file` 输出中应包含：

```text
ELF 64-bit
RISC-V
statically linked
```

如果文件不存在，或架构显示为 `x86-64`，先回到第 06—08 节重新编译，不要上传错误文件。

## 10. 使用 SCP 上传程序

在 WSL 中运行：

```bash
scp ./hello-riscv64 "$BOARD_USER@$BOARD_IP:~/ruyisdk-work/hello-ruyi/"
```

如果使用密码认证，按提示输入开发板密码。正常会显示传输进度，并以 `100%` 结束。

SCP 使用 SSH 连接传输文件。冒号左侧是远端登录目标，冒号右侧是开发板上的目标路径。

## 11. 在开发板上运行程序

再次登录：

```bash
ssh "$BOARD_USER@$BOARD_IP"
```

在开发板中运行：

```bash
cd ~/ruyisdk-work/hello-ruyi
ls -lh ./hello-riscv64
chmod +x ./hello-riscv64
./hello-riscv64
echo $?
```

如果第 08 节保留了修改后的源码，正常应显示：

```text
Hello from VS Code and RuyiSDK!
0
```

看到文字且退出状态为 `0`，说明这个程序已经从 WSL 交叉编译，通过网络传到开发板，并在真实 RISC-V Linux 系统上正常结束。

QEMU 运行成功只能说明模拟环境可执行；开发板运行成功才进一步验证了程序与这块板的处理器、内核和用户态环境相容。

## 12. 从开发板取回文件

仍在开发板中，先生成一份简单的系统信息文件：

```bash
{
    uname -a
    cat /etc/os-release
} > ~/ruyisdk-work/hello-ruyi/board-info.txt
```

退出开发板：

```bash
exit
```

在 WSL 项目目录中运行：

```bash
cd ~/ruyisdk-work/hello-ruyi
scp "$BOARD_USER@$BOARD_IP:~/ruyisdk-work/hello-ruyi/board-info.txt" ./
cat ./board-info.txt
```

正常会先显示下载进度，再显示开发板的内核和发行版信息。这说明 SCP 可以同时完成“上传到开发板”和“从开发板下载”两种方向。

## 13. 在 VS Code 中使用同一套命令

打开第 08 节的 WSL 项目窗口，选择：

```text
Terminal → New Terminal
```

在这个集成终端中重新设置开发板信息：

```bash
BOARD_USER='你的开发板用户名'
BOARD_IP='你的开发板IP地址'
```

随后可以直接运行同样的：

```bash
ssh "$BOARD_USER@$BOARD_IP"
```

或：

```bash
scp ./hello-riscv64 "$BOARD_USER@$BOARD_IP:~/ruyisdk-work/hello-ruyi/"
```

这样可以在 VS Code 中编辑本地 WSL 源码，再从集成终端编译、上传和登录开发板。每个新终端都要重新设置变量；变量不会自动永久保存。

## 14. 为什么不把 VS Code Remote - SSH 作为通用主线

VS Code Remote - SSH 需要在远端安装 VS Code Server。微软当前官方支持列表包括 x86_64、ARMv7 和 ARM64 Linux 远端，没有把 RISC-V 列为受支持架构。

因此，普通 SSH 和 SCP 在 RISC-V 开发板上可用，并不代表 VS Code Remote - SSH 一定能够安装或启动。为保证本教程适用于不同 RISC-V 板卡，本节使用 WSL 或 VS Code 的 WSL 集成终端进行 SSH 与文件传输。

如果某块开发板的厂商文档明确提供了适配的 VS Code 远程开发方案，应优先按照该板卡文档操作，不要把其他架构的 VS Code Server 安装步骤直接套用到 RISC-V。

## 15. 常见问题

### `Connection timed out` 或 `No route to host`

依次确认：

- 开发板已经完全启动；
- 电脑和开发板网络能够互通；
- `BOARD_IP` 是当前实际 IP；
- 路由器的访客网络或设备隔离没有阻断两台设备；
- SSH 使用的端口与开发板文档一致。

重新查看变量：

```bash
printf '%s@%s\n' "$BOARD_USER" "$BOARD_IP"
```

### `Connection refused`

这通常说明已经到达该 IP，但开发板的 SSH 服务没有监听对应端口。按照开发板官方文档启用 SSH 服务。

如果开发板使用 Debian 或 Ubuntu 且你能够操作板端终端，可以先检查：

```bash
systemctl status ssh
```

其他发行版的服务名称和管理方式可能不同，不要在不了解板卡系统时直接套用 Ubuntu 的安装命令。

### `Permission denied`

重点检查用户名、密码或密钥是否正确。用户名不是 Windows 用户名，也不是 WSL 用户名，而是开发板系统中的账号。

连续输错时先停止尝试，回到开发板说明书或板端终端确认账号，不要猜测默认密码。

### 主机密钥出现变化警告

开发板重装系统后，SSH 主机密钥可能改变；但同样的提示也可能表示连接目标异常。先重新确认开发板 IP 和指纹。

只有确认该 IP 确实属于刚刚重装的开发板时，才在 WSL 中运行：

```bash
ssh-keygen -R "$BOARD_IP"
```

然后重新连接并核对新指纹。不要为了消除警告而直接删除整个 `~/.ssh/known_hosts`。

### 上传后提示 `Permission denied`

确保目标位于当前开发板用户有写权限的主目录中：

```bash
ssh "$BOARD_USER@$BOARD_IP"
mkdir -p ~/ruyisdk-work/hello-ruyi
exit
```

不要一开始就把文件上传到 `/usr/bin`、`/opt` 等系统目录。

### 运行时出现 `Exec format error`

在 WSL 中重新确认：

```bash
file ./hello-riscv64
```

在开发板中确认：

```bash
uname -m
```

前者应为 RISC-V ELF，后者应为 `riscv64`。如果架构不一致，需要重新选择工具链或目标设备。

### 运行时出现 `Illegal instruction`

这通常说明程序使用了开发板处理器不支持的指令扩展，或工具链默认架构与实际芯片不匹配。保留以下信息：

```bash
uname -m
cat /proc/cpuinfo
```

同时记录 WSL 中的编译命令和 `readelf -h` 输出，再根据具体开发板的 ISA、ABI 和 RuyiSDK 支持矩阵选择匹配配置。不要把 QEMU 成功运行当作实际芯片一定兼容的证明。

### 提示缺少动态加载器或共享库

本系列使用 `-static` 生成静态链接示例。如果上传的是其他动态链接程序，需要保证板端存在匹配的动态加载器和库。

先在 WSL 中检查：

```bash
file ./hello-riscv64
```

当前示例应包含 `statically linked`。

## 16. 本节检查

- [ ] 已从开发板官方资料确认实际用户名、IP 和 SSH 方式；
- [ ] WSL 中能够找到 `ssh` 和 `scp`；
- [ ] 已通过 SSH 登录开发板；
- [ ] 开发板上的 `uname -m` 显示 `riscv64`；
- [ ] 已在开发板用户主目录中创建接收目录；
- [ ] 已通过 SCP 上传 `hello-riscv64`；
- [ ] 板端程序输出正确，且退出状态为 `0`；
- [ ] 已通过 SCP 从开发板取回 `board-info.txt`；
- [ ] 理解 QEMU 验证与真实开发板验证的区别；
- [ ] 知道 VS Code Remote - SSH 当前不能作为通用 RISC-V 方案。

完成以上检查后，Windows、WSL、Ruyi 工具链、QEMU 和实际 RISC-V Linux 开发板之间的基础开发链路已经连通。

## 系列完成

至此，本系列已经完成以下主线：

```text
Windows → WSL 2 → Ubuntu → Ruyi 包管理器 → Ruyi 虚拟环境
→ RISC-V 交叉编译 → QEMU 模拟运行 → VS Code 开发 → SSH 开发板验证
```

后续进入具体项目时，应根据目标开发板的 RuyiSDK profile、系统镜像、芯片 ISA、外设和厂商 SDK 继续扩展，而不是继续使用一个通用配置覆盖所有设备。

## 参考资料

- [OpenSSH Manual Pages：ssh](https://www.openssh.com/manual.html)
- [Visual Studio Code：Remote Development using SSH](https://code.visualstudio.com/docs/remote/ssh)
- [Visual Studio Code：Remote Development Linux prerequisites](https://code.visualstudio.com/docs/remote/linux)
- [RuyiSDK：支持矩阵](https://matrix.ruyisdk.org/)
