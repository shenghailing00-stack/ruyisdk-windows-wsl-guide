# 【RuyiSDK Windows/WSL 教程 09】通过 SSH 连接 RISC-V 开发板

上一节已经在 VS Code 的 WSL 环境中完成编辑、交叉编译和 QEMU 运行。这一节把 `hello-riscv64` 传到实际的 RISC-V Linux 开发板，通过 SSH 登录，并在板端完成运行验证。

本节适用于已经安装 Linux、能够联网并提供 SSH 服务的 RISC-V 开发板。不同板卡的系统镜像、默认用户名、联网方式和 SSH 开启方法不同，实际账号、IP 和端口必须以开发板官方文档为准。

## 一、准备实际连接信息

先确认：

- 开发板当前用户名；
- 开发板当前局域网 IP；
- SSH 端口和认证方式；
- 开发板已启动 SSH 服务；
- 电脑与开发板网络能够互通。

在 WSL 中填入自己的实际信息：

```bash
BOARD_USER='你的开发板用户名'
BOARD_IP='你的开发板IP地址'
printf 'SSH target: %s@%s\n' "$BOARD_USER" "$BOARD_IP"
```

不要直接照抄教程中的示例账号或 IP。

## 二、检查客户端并首次登录

```bash
command -v ssh
command -v scp
ping -c 4 "$BOARD_IP"
ssh "$BOARD_USER@$BOARD_IP"
```

第一次连接时，先确认目标 IP 和主机指纹，再输入 `yes`。登录成功后，在开发板中运行：

```bash
whoami
hostname
uname -m
cat /etc/os-release
```

`uname -m` 应显示 `riscv64`。

## 三、创建板端目录并上传程序

在开发板中创建目录后退出：

```bash
mkdir -p ~/ruyisdk-work/hello-ruyi
exit
```

回到 WSL，检查并上传：

```bash
cd ~/ruyisdk-work/hello-ruyi
file ./hello-riscv64
scp ./hello-riscv64 "$BOARD_USER@$BOARD_IP:~/ruyisdk-work/hello-ruyi/"
```

上传前，`file` 应显示 RISC-V 静态链接程序。

## 四、在开发板上运行

```bash
ssh "$BOARD_USER@$BOARD_IP"
cd ~/ruyisdk-work/hello-ruyi
chmod +x ./hello-riscv64
./hello-riscv64
echo $?
```

正常应显示程序输出和退出状态 `0`。这说明程序已经从 WSL 交叉编译，经 SCP 上传，并在真实 RISC-V Linux 系统中正常结束。

## 五、取回板端文件

可以在开发板中生成系统信息文件，退出后再从 WSL 下载：

```bash
{ uname -a; cat /etc/os-release; } > ~/ruyisdk-work/hello-ruyi/board-info.txt
exit
scp "$BOARD_USER@$BOARD_IP:~/ruyisdk-work/hello-ruyi/board-info.txt" ./
cat ./board-info.txt
```

## 六、关于 VS Code Remote - SSH

普通 SSH 与 SCP 可以用于 RISC-V 开发板，但这不代表 VS Code Remote - SSH 一定兼容。该功能需要在远端运行 VS Code Server，而微软当前官方支持列表没有把 RISC-V 列为通用支持架构。

因此，本教程采用 WSL 或 VS Code 的 WSL 集成终端执行 `ssh` 和 `scp`。如果板卡厂商提供专用远程开发方案，应以其官方文档为准。

## 七、本节完成标准

- [ ] 已确认开发板实际用户名、IP、端口和认证方式；
- [ ] WSL 中能够使用 `ssh` 和 `scp`；
- [ ] 已通过 SSH 登录开发板；
- [ ] 板端 `uname -m` 显示 `riscv64`；
- [ ] 已通过 SCP 上传 `hello-riscv64`；
- [ ] 板端程序输出正确，且退出状态为 `0`；
- [ ] 已从开发板取回 `board-info.txt`；
- [ ] 理解 QEMU 验证与真实开发板验证的区别。

完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/09-connect-board-ssh.md

至此，Windows、WSL、Ruyi 工具链、QEMU、VS Code 和实际 RISC-V Linux 开发板之间的基础开发链路已经连通。
