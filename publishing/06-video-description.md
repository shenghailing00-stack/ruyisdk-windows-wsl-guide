# B 站投稿信息

## 标题

【RuyiSDK 新手教程 06】交叉编译第一个 RISC-V 程序

## 简介

本期继续使用上一节创建的 Ruyi 虚拟环境，编写一个最小的 C 程序，通过 GNU RISC-V 交叉编译器生成可执行文件，并确认输出文件的目标架构确实是 RISC-V。

主要内容：

- 重新进入项目并激活 `ruyi-venv`；
- 编写并检查 `hello.c`；
- 说明主机架构与目标架构的区别；
- 使用 `riscv64-unknown-linux-gnu-gcc` 交叉编译；
- 说明本示例使用静态链接的原因；
- 检查 `hello-riscv64` 是否生成；
- 使用 `file` 确认 RISC-V ELF；
- 使用 `readelf` 查看 ELF 文件头；
- 排查编译器、源码和目标架构错误。

配套仓库：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

完整图文：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/06-cross-compile-hello.md

下一期将使用 Ruyi 虚拟环境中的 QEMU 运行这个 RISC-V 程序。

## 章节

视频完成后，根据最终画面填写时间点。

## 标签

`RuyiSDK` `RISC-V` `WSL2` `Ubuntu` `交叉编译` `GCC` `新手教程`

## 置顶评论

本期命令和完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/06-cross-compile-hello.md

如果编译失败，可以留下完整报错，以及 `command -v riscv64-unknown-linux-gnu-gcc`、`riscv64-unknown-linux-gnu-gcc --version`、`file hello.c` 和 `pwd` 的输出。截图前请隐藏用户名、IP 和代理地址。
