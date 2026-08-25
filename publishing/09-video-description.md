# B 站投稿信息

## 标题

【RuyiSDK 新手教程 09】SSH 连接 RISC-V 开发板并运行程序

## 简介

本期把前面交叉编译并通过 QEMU 验证的 `hello-riscv64` 上传到实际的 RISC-V Linux 开发板，通过 SSH 登录、SCP 传输和板端运行完成真实硬件验证。

主要内容：

- 从开发板官方资料确认用户名、IP、端口和认证方式；
- 在 WSL 中检查 SSH 与 SCP 客户端；
- 检查电脑与开发板的网络连通性；
- 首次 SSH 登录并核对主机指纹；
- 使用 `uname -m` 确认远端为 `riscv64`；
- 在开发板用户目录中创建接收目录；
- 上传前检查 `hello-riscv64` 的架构；
- 使用 SCP 上传程序；
- 在真实开发板上运行并检查退出状态；
- 从开发板取回系统信息文件；
- 区分 QEMU 验证与真实硬件验证；
- 说明 VS Code Remote - SSH 的 RISC-V 兼容性边界。

不同开发板的系统镜像、默认账号、IP、联网方式和 SSH 开启方法不同，请以对应板卡的官方文档为准，不要直接照抄视频中的示例信息。

配套仓库：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

完整图文：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/09-connect-board-ssh.md

本期完成后，Windows、WSL、Ruyi 工具链、QEMU、VS Code 与实际 RISC-V Linux 开发板之间的基础开发链路已经连通。

## 章节

视频完成后，根据最终画面填写时间点。

## 标签

`RuyiSDK` `RISC-V` `WSL2` `Ubuntu` `SSH` `开发板` `新手教程`

## 置顶评论

本期命令和完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/09-connect-board-ssh.md

不同开发板没有统一的默认用户名和 IP，请先查阅板卡官方文档。如果连接或运行失败，可以留下完整报错，以及 WSL 中的 `printf '%s@%s\n' "$BOARD_USER" "$BOARD_IP"`、`file hello-riscv64`，以及开发板上的 `uname -m` 和 `cat /etc/os-release` 输出。截图前请隐藏密码、公网 IP、密钥和其他敏感信息。
