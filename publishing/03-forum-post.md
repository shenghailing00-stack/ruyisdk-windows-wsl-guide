# 【RuyiSDK Windows/WSL 教程 03】安装 RuyiSDK 包管理器并完成首次验证

前两节已经准备好 WSL 2、Ubuntu 24.04 和基础下载工具。这一节使用官方提供的预编译二进制文件安装 Ruyi，检查命令和版本，刷新软件包索引，并进行一次软件包查询。

本文示例适用于 `x86_64`，使用的 Ruyi 版本为 `0.51.0`。以后发布新版本时，安装步骤不变，只需要根据官方下载页替换版本号和文件名。

## 一、进入工作目录并检查架构

```bash
mkdir -p ~/ruyisdk-work
cd ~/ruyisdk-work
uname -m
```

普通 Intel 或 AMD Windows 电脑通常显示 `x86_64`，对应下载文件中的 `amd64`。

## 二、下载并检查文件

```bash
wget https://mirror.iscas.ac.cn/ruyisdk/ruyi/tags/0.51.0/ruyi-0.51.0.amd64
ls -lh ruyi-0.51.0.amd64
file ruyi-0.51.0.amd64
```

`file` 的结果中应包含 `ELF 64-bit` 和 `x86-64`。如果电脑显示的架构不是 `x86_64`，请从官方安装页选择对应文件。

## 三、安装 Ruyi

```bash
chmod +x ./ruyi-0.51.0.amd64
sudo cp -v ./ruyi-0.51.0.amd64 /usr/local/bin/ruyi
```

安装后的文件名必须是 `ruyi`，不能保留版本号和架构后缀。

## 四、验证安装

```bash
command -v ruyi
ruyi version
ruyi --help
```

`command -v ruyi` 通常显示 `/usr/local/bin/ruyi`，另外两条命令应能返回版本和帮助信息。

首次执行 Ruyi 命令时，如果终端显示许可、隐私或遥测提示，请阅读说明后按自己的选择输入 `y` 或 `n`。

## 五、刷新软件包索引

```bash
ruyi update
```

这一步只下载软件包索引，不会立即安装工具链或 QEMU。默认索引目录为 `~/.cache/ruyi/packages-index/`。

## 六、查询软件包

```bash
ruyi list --name-contains gnu-plct
```

能够返回名称中包含 `gnu-plct` 的工具链软件包和版本信息，就说明本地索引可以正常使用。

## 七、更新失败时切换镜像

先检查当前软件源：

```bash
ruyi config get repo.remote
```

默认的 GitHub 软件包索引无法访问时，可以切换到 ISCAS 镜像：

```bash
ruyi config set repo.remote https://mirror.iscas.ac.cn/git/ruyisdk/packages-index.git
ruyi update
```

## 八、本节完成标准

- [ ] 下载文件的架构与 `uname -m` 对应；
- [ ] `command -v ruyi` 能找到安装位置；
- [ ] `ruyi version` 能正常显示版本；
- [ ] `ruyi update` 能刷新索引；
- [ ] `ruyi list --name-contains gnu-plct` 能返回结果。

完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/03-install-ruyi.md

下一节：[查询、安装与管理 Ruyi 软件包](https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/04-manage-packages.md)
