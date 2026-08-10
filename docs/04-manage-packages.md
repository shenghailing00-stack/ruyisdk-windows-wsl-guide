# 【RuyiSDK Windows/WSL 教程 04】查询、安装与管理 Ruyi 软件包

上一节已经安装 Ruyi 包管理器，并完成了软件包索引更新。这一节进一步了解 Ruyi 软件包的分类和状态，安装后续需要的 GNU RISC-V 工具链与 QEMU 模拟器，并说明软件包、下载缓存和已安装文件分别存放在哪里。

本节只完成软件包管理。工具链不会直接加入当前终端的 `PATH`，下一节会使用这些软件包创建 Ruyi 虚拟环境。

## 完成本节后，你将能够

- 按名称和类别查询 Ruyi 软件包；
- 看懂 `latest`、`prerelease`、`installed` 等状态；
- 安装 GNU RISC-V 工具链和 QEMU 用户态模拟器；
- 查看已安装的软件包；
- 分清软件包索引、下载缓存和已安装文件；
- 了解重新安装、卸载和清理缓存的正确命令。

## 1. 进入 Ubuntu 并检查 Ruyi

打开 PowerShell，进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

下面的命令都在 Ubuntu 终端中运行。先检查 Ruyi 是否可以使用：

```bash
ruyi version
```

如果能够显示版本和版权信息，就可以继续。若提示 `ruyi: command not found`，请回到第 03 节检查 `/usr/local/bin/ruyi` 是否存在。

## 2. 刷新软件包索引

安装软件包前先刷新本地索引：

```bash
ruyi update
```

这一步让本地获得软件源中的最新软件包信息。它不会自动升级已经安装的软件包。

## 3. 了解 Ruyi 软件包分类

Ruyi 软件源中的软件包主要分为以下几类：

| 分类 | 内容 |
|---|---|
| `toolchain` | GCC、LLVM 等编译工具链 |
| `emulator` | QEMU 等模拟器 |
| `source` | 示例程序和其他源码包 |
| `board-image` | 开发板系统镜像 |
| `analyzer` | 分析和调试工具 |
| `extra` | 其他软件 |

如果要列出某个类别，可以使用：

```bash
ruyi list --category-is toolchain
```

全部软件包数量较多，不建议新手直接滚动查找。更常用的做法是按名称筛选。

## 4. 查询 GNU RISC-V 工具链

运行：

```bash
ruyi list --name-contains gnu-upstream
```

结果中应出现：

```text
toolchain/gnu-upstream
```

这里的 `toolchain` 是分类，`gnu-upstream` 是安装时使用的软件包名。

需要查看更多信息时，可以加上 `--verbose`：

```bash
ruyi list --name-contains gnu-upstream --verbose
```

详细输出通常包含目标架构、组件、下载文件和版本状态。输出较长是正常的。

## 5. 查询 QEMU 模拟器

运行：

```bash
ruyi list --name-contains qemu-user-riscv-upstream
```

结果中应出现：

```text
emulator/qemu-user-riscv-upstream
```

这是面向 RISC-V 用户态程序的 QEMU 模拟器。后续会用它在当前的 `x86_64` WSL 环境中运行交叉编译得到的 RISC-V 程序。

## 6. 看懂常见的软件包状态

软件包版本后可能出现以下标记：

| 标记 | 含义 |
|---|---|
| `latest` | 当前默认安装的正式版本 |
| `prerelease` | 预发布版本，默认不会优先安装 |
| `latest-prerelease` | 当前最新的预发布版本 |
| `installed` | 该版本已经安装 |
| `no binary for current host` | 没有适用于当前主机架构的二进制文件 |

本教程使用默认的正式版本，不主动启用预发布版本。看到 `no binary for current host` 时，不要强行安装，应先确认软件包名称和电脑架构是否正确。

## 7. 安装工具链与模拟器

一次安装两个软件包：

```bash
ruyi install gnu-upstream qemu-user-riscv-upstream
```

Ruyi 会先下载软件包，再校验并解压。工具链和模拟器文件较大，耗时取决于当前网络速度。下载过程中不要关闭终端。

命令执行完成且没有报错后，运行：

```bash
ruyi list --is-installed true
```

列表中应包含：

```text
toolchain/gnu-upstream
emulator/qemu-user-riscv-upstream
```

如果还安装过其他 Ruyi 软件包，它们也会一起显示。

## 8. 为什么现在还不能直接运行交叉编译器

安装完成后，如果直接运行：

```bash
riscv64-unknown-linux-gnu-gcc --version
```

当前终端仍可能提示找不到命令。这不代表安装失败。

Ruyi 将不同版本的工具链保存在自己的数据目录中，不会把它们全部直接加入全局 `PATH`。下一节创建并激活虚拟环境后，正确版本的编译器和模拟器才会加入当前终端。

## 9. 查看缓存和安装位置

Ruyi 的缓存根目录通常位于：
```
~/.cache/ruyi/
```
不同 Ruyi 版本中，软件源和索引相关缓存的具体子目录名称可能有所不同。可以先运行：
```
ls -la ~/.cache/ruyi
```
查看当前环境中的实际目录。

在本文实测的 Ruyi 环境中，软件源和索引相关缓存位于：
```
~/.cache/ruyi/repos/
```
下载的软件包压缩文件通常位于：
```
~/.cache/ruyi/distfiles/
```
解压后的二进制软件包通常位于：
```
~/.local/share/ruyi/binaries/当前主机架构/
```
例如，可以查看这些目录占用的空间：
```
du -sh ~/.cache/ruyi/repos
du -sh ~/.cache/ruyi/distfiles
du -sh ~/.local/share/ruyi/binaries/$(uname -m)
```
如果你的 ~/.cache/ruyi/ 中没有 repos，请以 ls -la ~/.cache/ruyi 的实际结果为准，不要手动创建目录。

目录大小会随 Ruyi 版本、缓存内容和已安装软件包变化，不需要与教程相同。

## 10. 重新安装、卸载和清理缓存

如果软件包文件被误删或损坏，可以重新安装：

```bash
ruyi install --reinstall gnu-upstream
```

卸载单个软件包使用：

```bash
ruyi uninstall 软件包名
```

也可以使用别名：

```bash
ruyi remove 软件包名
```

例如，下面的命令会卸载 QEMU：

```bash
ruyi uninstall qemu-user-riscv-upstream
```

本教程后续还要使用刚安装的两个软件包，因此现在不要执行卸载命令。

只清理已经下载的压缩包、保留已安装软件包，可以使用：

```bash
ruyi self clean --distfiles
```

不要为了普通的空间清理直接运行：

```bash
ruyi self clean --installed-pkgs
```

这会删除全部已安装软件包，并使依赖这些软件包的虚拟环境失效。

## 11. 二进制软件包与源码包的区别

工具链、模拟器等二进制软件包使用 `ruyi install` 安装。`source` 分类中的源码包通常使用 `ruyi extract` 下载并解压，例如：

```bash
ruyi extract ruyisdk-demo
```

本节不需要执行这条命令。后续进入具体示例时，再把源码解压到单独的项目目录中。

## 12. 常见问题

### `ruyi list` 提示没有指定筛选条件

较新的 Ruyi 版本要求明确指定筛选方式。列出全部软件包可以运行：

```bash
ruyi list --all
```

实际查找时更建议使用 `--name-contains`、`--category-is` 或 `--is-installed true`。

### 下载速度慢或中途失败

先确认第 03 节中的 `ruyi update` 可以完成，再重新执行安装命令。Ruyi 会使用本地已有的有效下载文件，不需要手动删除全部缓存。

如果软件源访问不稳定，可以检查当前配置：

```bash
ruyi config get repo.remote
```

需要时再按照第 03 节的方法切换 ISCAS 镜像。

### 显示 `no binary for current host`

先运行：

```bash
uname -m
```

本教程在常见的 `x86_64` WSL 环境中安装 `gnu-upstream` 和 `qemu-user-riscv-upstream`。如果你的主机架构不同，应根据查询结果选择支持该架构的软件包。

### 安装后找不到 `gcc`

不要把工具链内部目录手动写入全局 `PATH`。下一节会通过 Ruyi 虚拟环境提供正确的命令和配置。

### 磁盘空间不足

先检查缓存和安装目录：

```bash
du -sh ~/.cache/ruyi
du -sh ~/.local/share/ruyi
```

确认不再需要下载缓存时，可以运行 `ruyi self clean --distfiles`。不要直接删除仍被虚拟环境使用的已安装工具链。

## 13. 本节检查

- [ ] `ruyi update` 能正常完成；
- [ ] 能按名称查询工具链和模拟器；
- [ ] 已安装 `gnu-upstream`；
- [ ] 已安装 `qemu-user-riscv-upstream`；
- [ ] `ruyi list --is-installed true` 能显示两个软件包；
- [ ] 能分清软件包索引、下载缓存和已安装文件；
- [ ] 没有卸载后续需要的软件包。

完成以上检查后，创建 Ruyi 虚拟环境所需的软件包已经准备好了。

## 下一节

[下一节：创建并使用 Ruyi 虚拟环境](05-create-venv.md)

## 参考资料

- [RuyiSDK：管理 Ruyi 软件包](https://ruyisdk.org/docs/Package-Manager/packages/)
- [RuyiSDK：使用集成功能](https://ruyisdk.org/docs/Package-Manager/intergration/)
