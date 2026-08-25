# B 站投稿信息

## 标题

【RuyiSDK 新手教程 07】使用 QEMU 运行 RISC-V 程序

## 简介

本期使用 Ruyi 虚拟环境提供的 QEMU 用户态模拟器，运行上一节交叉编译得到的 `hello-riscv64`，检查程序输出和退出状态，并说明模拟运行在整个开发流程中的作用。

主要内容：

- 重新进入项目并激活 `ruyi-venv`；
- 验证 `ruyi-qemu` 的路径与版本；
- 检查待运行文件的架构与链接方式；
- 使用 `ruyi-qemu` 运行 RISC-V Hello World；
- 使用 `echo $?` 检查退出状态；
- 理解 x86-64 主机与 RISC-V 程序之间的关系；
- 区分 QEMU 用户态模拟和完整系统模拟；
- 说明静态链接对本示例的作用；
- 排查架构、路径、动态加载器和非法指令问题。

配套仓库：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

完整图文：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/07-run-with-qemu.md

下一期将使用 VS Code Remote - WSL 打开同一个项目，完成图形化编辑、交叉编译和 QEMU 运行。

## 章节

视频完成后，根据最终画面填写时间点。

## 标签

`RuyiSDK` `RISC-V` `WSL2` `Ubuntu` `QEMU` `交叉编译` `新手教程`

## 置顶评论

本期命令和完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/07-run-with-qemu.md

如果运行失败，可以留下完整报错，以及 `command -v ruyi-qemu`、`ruyi-qemu --version`、`file hello-riscv64` 和 `echo $?` 的输出。截图前请隐藏用户名、IP 和代理地址。
