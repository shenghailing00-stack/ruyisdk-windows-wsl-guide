# B 站投稿信息

## 标题

【RuyiSDK 新手教程 04】查询并安装 RISC-V 工具链与 QEMU

## 简介

本期继续学习 Ruyi 软件包管理。我们会从查询软件包开始，安装后续需要的 GNU RISC-V 工具链和 QEMU 模拟器，再检查已安装状态与本地目录。

主要内容：

- 了解 `toolchain`、`emulator`、`source` 等软件包分类；
- 使用 `ruyi list` 按名称和类别查询；
- 看懂 `latest`、`prerelease`、`installed` 等状态；
- 安装 `gnu-upstream`；
- 安装 `qemu-user-riscv-upstream`；
- 查看已安装的软件包；
- 分清软件包索引、下载缓存和已安装文件；
- 了解重新安装、卸载与缓存清理命令。

配套仓库：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

完整图文：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/04-manage-packages.md

下一期将使用这两个软件包创建并激活 Ruyi 虚拟环境。

## 章节

视频完成后，根据最终画面填写时间点。

## 标签

`RuyiSDK` `RISC-V` `WSL2` `Ubuntu` `工具链` `QEMU` `新手教程`

## 置顶评论

本期命令和完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/04-manage-packages.md

如果安装失败，可以留下完整报错，以及 `ruyi version`、`ruyi config get repo.remote`、`uname -m` 和 `ruyi list --is-installed true` 的输出。截图前请隐藏用户名、IP 和代理地址。
