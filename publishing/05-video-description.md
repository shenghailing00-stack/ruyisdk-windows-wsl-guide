# B 站投稿信息

## 标题

【RuyiSDK 新手教程 05】创建虚拟环境并启用 RISC-V 工具链

## 简介

本期使用上一节安装的 GNU RISC-V 工具链与 QEMU，创建一个独立的 Ruyi 虚拟环境，并完成激活、验证、退出和再次进入。

主要内容：

- 说明 Ruyi 虚拟环境与 Python 虚拟环境的区别；
- 查看已安装软件包和可用 profile；
- 理解工具链、模拟器、`generic` 和环境目录；
- 创建 `ruyi-venv`；
- 查看 sysroot、CMake 和 Meson 配置；
- 激活 Ruyi 虚拟环境；
- 验证 `riscv64-unknown-linux-gnu-gcc`；
- 验证 `ruyi-qemu`；
- 退出并再次进入已有环境。

配套仓库：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

完整图文：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/05-create-venv.md

下一期将在这个虚拟环境中编写并交叉编译第一个 RISC-V Hello World 程序。

## 章节

视频完成后，根据最终画面填写时间点。

## 标签

`RuyiSDK` `RISC-V` `WSL2` `Ubuntu` `虚拟环境` `交叉编译` `新手教程`

## 置顶评论

本期命令和完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/05-create-venv.md

如果虚拟环境创建或激活失败，可以留下完整报错，以及 `ruyi version`、`ruyi list --is-installed true`、`ruyi list profiles` 和 `pwd` 的输出。截图前请隐藏用户名、IP 和代理地址。
