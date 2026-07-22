# B 站投稿信息

## 标题

【RuyiSDK 新手教程 02】初始化 Ubuntu：软件源、网络与基础工具

## 简介

本期继续准备 Windows + WSL 下的 RuyiSDK 开发环境。进入 Ubuntu 24.04 后，我们会检查当前用户、系统版本、时间和处理器架构，更新软件包索引，并安装后续操作需要的基础工具。

主要内容：

- 分清普通 Linux 用户与 root 用户；
- 检查 Ubuntu 版本、系统时间和处理器架构；
- 检查 DNS 解析；
- 使用 `sudo apt update` 更新软件包索引；
- 安装 `curl`、`wget`、`git`、`file` 等工具；
- 检查 HTTPS 连接；
- 处理常见的 DNS、代理和证书问题。

配套仓库：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide

完整图文：https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/02-prepare-ubuntu.md

下一期将安装 RuyiSDK 包管理器，刷新软件包索引，并完成第一次软件包查询。

## 章节

视频完成后，根据最终画面填写时间点。

## 标签

`RuyiSDK` `RISC-V` `WSL2` `Ubuntu` `Linux` `开发环境` `新手教程`

## 置顶评论

本期命令和完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/02-prepare-ubuntu.md

如果 `apt update` 或 `curl` 失败，可以留下完整报错，以及 `cat /etc/os-release`、`uname -m` 和 `date` 的输出。截图前请隐藏用户名、IP 和代理地址。
