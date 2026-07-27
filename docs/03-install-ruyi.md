# 【RuyiSDK Windows/WSL 教程 03】安装 RuyiSDK 包管理器并完成首次验证

前两节已经准备好 WSL 2、Ubuntu 24.04 和基础下载工具。这一节安装 RuyiSDK 包管理器，刷新软件包索引，并用一次查询确认它可以正常工作。

本文以 RuyiSDK 官方推荐的预编译二进制文件为主线，适用于常见的 `x86_64` Windows 电脑。文中的示例版本为 `0.51.0`；以后出现新版本时，仍可按相同步骤安装，只需使用官网下载页提供的新文件名。

## 完成本节后，你将能够

- 根据处理器架构选择 Ruyi 安装文件；
- 将 `ruyi` 安装到 `/usr/local/bin`；
- 检查安装位置、版本和帮助信息；
- 刷新 Ruyi 软件包索引；
- 查询可用的软件包。

## 1. 进入工作目录

打开 PowerShell，进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

下面的安装命令都在 Ubuntu 终端中运行。先进入前面创建的目录：

```bash
mkdir -p ~/ruyisdk-work
cd ~/ruyisdk-work
pwd
```

## 2. 再次确认处理器架构

运行：

```bash
uname -m
```

常见 Windows 电脑会显示 `x86_64`，对应 Ruyi 下载文件名中的 `amd64`。

| `uname -m` 输出 | 应选择的 Ruyi 文件 |
|---|---|
| `x86_64` | `amd64` |
| `aarch64` | `arm64` |
| `riscv64` | `riscv64` |

本节后面的下载命令适用于 `x86_64`。如果你的输出不同，请在官方安装页选择对应架构，不要继续下载 `amd64` 文件。

## 3. 选择安装方式

RuyiSDK 官方文档列出了三种安装方式：预编译二进制文件、Linux 系统包管理器和 Python 包管理器。

这里使用预编译二进制文件。它不依赖系统中的 Python 环境，下载后复制到命令搜索路径即可使用，比较适合第一次安装。其他安装方式不在本节并行演示，避免同一台电脑上出现多个来源的 `ruyi`。

## 4. 下载 Ruyi

在 `~/ruyisdk-work` 中运行：

```bash
wget https://mirror.iscas.ac.cn/ruyisdk/ruyi/tags/0.51.0/ruyi-0.51.0.amd64
```

这是 RuyiSDK 官方安装页当前给出的 ISCAS 镜像地址。下载完成后运行：

```bash
ls -lh ruyi-0.51.0.amd64
file ruyi-0.51.0.amd64
```

`ls` 应能显示文件大小，`file` 的结果中应包含 `ELF 64-bit` 和 `x86-64`。如果文件不存在、大小为 0，或者架构与 `uname -m` 不对应，不要继续安装。

如果官网已经更新到其他版本，请把上面命令中的版本号和文件名一起替换为下载页显示的内容：

- [RuyiSDK 包管理器安装文档](https://ruyisdk.org/docs/Package-Manager/installation/)
- [Ruyi GitHub Releases](https://github.com/ruyisdk/ruyi/releases)

## 5. 添加执行权限并安装

先添加执行权限：

```bash
chmod +x ./ruyi-0.51.0.amd64
```

再复制到 `/usr/local/bin`，并将安装后的文件名改为 `ruyi`：

```bash
sudo cp -v ./ruyi-0.51.0.amd64 /usr/local/bin/ruyi
```

命令中的目标路径必须以 `/ruyi` 结尾。预编译的单文件版本安装后不能继续使用 `ruyi-0.51.0.amd64` 这样的名称。

## 6. 验证安装

依次运行：

```bash
command -v ruyi
ruyi version
ruyi --help
```

正常情况下：

- `command -v ruyi` 显示 `/usr/local/bin/ruyi`；
- `ruyi version` 显示 Ruyi 版本、运行系统和处理器架构；
- `ruyi --help` 显示 `update`、`list`、`install`、`venv` 等子命令。

输出内容可能随版本更新，只要三条命令都能正常执行即可。

## 7. 完成首次运行设置

第一次运行 `ruyi update` 时，终端可能显示欢迎信息、许可与隐私说明，并询问是否同意发送遥测数据。阅读说明后，根据自己的选择输入 `y` 或 `n`，再按 Enter。

这个选择不会影响 Ruyi 的基本软件包管理功能。以后也可以通过下面的命令查看遥测相关帮助：

```bash
ruyi telemetry --help
```

## 8. 刷新软件包索引

运行：

```bash
ruyi update
```

这一步获取的是 Ruyi 软件包索引，还没有安装工具链或 QEMU。默认情况下，索引保存在：

```text
~/.cache/ruyi/packages-index/
```

首次更新需要一点时间。看到更新完成且没有报错后，再继续查询软件包。

## 9. 查询软件包

运行：

```bash
ruyi list --name-contains gnu-plct
```

结果中应出现名称包含 `gnu-plct` 的工具链软件包及可用版本。这一步只查询索引，不会下载或安装工具链。

如果想查看 `list` 命令的其他参数，可以运行：

```bash
ruyi list --help
```

软件包的查询、安装、卸载和缓存管理会放在下一节继续介绍。

## 10. `ruyi update` 无法访问软件源

先查看当前远程软件源：

```bash
ruyi config get repo.remote
```

如果默认的 GitHub 软件包索引访问失败，可以切换到中国科学院软件研究所镜像：

```bash
ruyi config set repo.remote https://mirror.iscas.ac.cn/git/ruyisdk/packages-index.git
ruyi update
```

只有默认软件源确实连接失败时才需要切换，不必在正常情况下重复修改。

## 11. 常见问题

### `ruyi: command not found`

先检查安装文件是否存在：

```bash
ls -l /usr/local/bin/ruyi
echo "$PATH"
```

`/usr/local/bin` 一般已经在 `PATH` 中。如果文件不存在，回到第 5 步重新复制。

### `Permission denied`

检查执行权限：

```bash
ls -l /usr/local/bin/ruyi
```

如果没有执行权限，运行：

```bash
sudo chmod +x /usr/local/bin/ruyi
```

### 下载了错误的架构

重新运行 `uname -m`，再从官方安装页下载对应文件。`x86_64` 对应 `amd64`，不能直接运行 `arm64` 或 `riscv64` 文件。

### 安装后的文件名不正确

`/usr/local/bin` 中的文件名应当是一字不差的 `ruyi`。可以重新执行：

```bash
sudo cp -v ~/ruyisdk-work/ruyi-0.51.0.amd64 /usr/local/bin/ruyi
```

### 更新到以后发布的新版本

按照官方安装页下载新文件，再用相同的 `sudo cp -v` 命令覆盖 `/usr/local/bin/ruyi`。覆盖前可以先用 `ruyi version` 记录旧版本，安装后再次检查版本。

## 12. 本节检查

- [ ] `uname -m` 与下载文件的架构对应；
- [ ] `command -v ruyi` 显示 `/usr/local/bin/ruyi`；
- [ ] `ruyi version` 能正常显示版本信息；
- [ ] `ruyi update` 能完成软件包索引更新；
- [ ] `ruyi list --name-contains gnu-plct` 能返回查询结果。

完成以上检查后，RuyiSDK 包管理器已经可以正常使用。

## 下一节

[下一节：查询、安装与管理 Ruyi 软件包](04-manage-packages.md)

## 参考资料

- [RuyiSDK：安装 Ruyi 包管理器](https://ruyisdk.org/docs/Package-Manager/installation/)
- [RuyiSDK：管理 Ruyi 软件包](https://ruyisdk.org/docs/Package-Manager/packages/)
- [Ruyi GitHub Releases](https://github.com/ruyisdk/ruyi/releases)
