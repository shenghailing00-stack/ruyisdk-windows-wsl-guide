# B 站投稿信息

## 标题

【RuyiSDK 新手教程 08】用 VS Code + WSL 开发 RISC-V 程序

## 简介

本期安装 Windows 版 Visual Studio Code 和 WSL 扩展，打开前面一直使用的 Ubuntu 项目，在 VS Code 中完成源码编辑、交叉编译、目标架构检查和 QEMU 运行。

主要内容：

- 安装 Windows 版 VS Code；
- 安装 Microsoft WSL 扩展；
- 从 Ubuntu 项目目录运行 `code .`；
- 判断当前窗口是否连接 `Ubuntu-24.04`；
- 检查集成终端与 Linux 项目路径；
- 在新终端中激活 `ruyi-venv`；
- 使用编辑器修改并保存 `hello.c`；
- 在集成终端中重新交叉编译；
- 使用 `file` 检查 RISC-V 架构；
- 使用 QEMU 运行修改后的程序；
- 说明 Windows、WSL 与 RISC-V 目标环境的分工；
- 可选安装 RuyiSDK VS Code 插件。

配套仓库：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

完整图文：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/08-vscode-wsl.md

下一期将通过 SSH 与 SCP 连接实际的 RISC-V Linux 开发板，上传并运行同一个程序。

## 章节

视频完成后，根据最终画面填写时间点。

## 标签

`RuyiSDK` `RISC-V` `WSL2` `Ubuntu` `VS Code` `QEMU` `新手教程`

## 置顶评论

本期命令和完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/08-vscode-wsl.md

如果 VS Code 没有进入 WSL，或集成终端找不到工具链，可以留下左下角环境标识截图，以及 `pwd`、`uname -m`、`command -v riscv64-unknown-linux-gnu-gcc` 和 `command -v ruyi-qemu` 的输出。截图前请隐藏用户名、IP 和代理地址。
