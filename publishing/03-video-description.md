# B 站投稿信息

## 标题

【RuyiSDK 新手教程 03】安装 Ruyi 包管理器并完成首次验证

## 简介

本期在 Ubuntu 24.04 中安装 RuyiSDK 包管理器。教程使用官方提供的预编译二进制文件，适合第一次接触 Ruyi 的 Windows/WSL 用户。

主要内容：

- 使用 `uname -m` 确认处理器架构；
- 下载并检查 Ruyi 二进制文件；
- 添加执行权限并安装到 `/usr/local/bin/ruyi`；
- 检查安装位置、版本和帮助信息；
- 处理首次运行提示；
- 使用 `ruyi update` 刷新软件包索引；
- 使用 `ruyi list` 查询软件包；
- 默认软件源连接失败时切换到 ISCAS 镜像。

配套仓库：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

完整图文：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/03-install-ruyi.md

下一期将继续介绍 Ruyi 软件包的查询、安装、卸载和本地缓存。

## 章节

视频完成后，根据最终画面填写时间点。

## 标签

`RuyiSDK` `RISC-V` `WSL2` `Ubuntu` `Linux` `包管理器` `新手教程`

## 置顶评论

本期命令和完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/03-install-ruyi.md

如果安装或更新失败，可以留下完整报错，以及 `uname -m`、`command -v ruyi` 和 `ruyi version` 的输出。截图前请隐藏用户名、IP 和代理地址。
