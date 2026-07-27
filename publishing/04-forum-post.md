# 【RuyiSDK Windows/WSL 教程 04】查询、安装与管理 Ruyi 软件包

上一节已经完成 Ruyi 包管理器的安装和索引更新。这一节继续了解软件包分类与状态，并安装后续交叉编译和模拟运行需要的 GNU RISC-V 工具链与 QEMU。

## 一、刷新软件包索引

```bash
ruyi update
```

更新完成后再进行查询和安装，避免使用过期的本地索引。

## 二、查询工具链和模拟器

```bash
ruyi list --name-contains gnu-upstream
ruyi list --name-contains qemu-user-riscv-upstream
```

结果中应分别出现：

```text
toolchain/gnu-upstream
emulator/qemu-user-riscv-upstream
```

需要查看目标架构、组件和下载文件等信息时，可以使用：

```bash
ruyi list --name-contains gnu-upstream --verbose
```

## 三、安装两个软件包

```bash
ruyi install gnu-upstream qemu-user-riscv-upstream
```

Ruyi 会自动完成下载、校验和解压。文件较大时需要耐心等待，不要在下载过程中关闭终端。

## 四、查看已安装软件包

```bash
ruyi list --is-installed true
```

列表中应包含刚安装的工具链和模拟器。安装后暂时不能直接运行交叉编译器是正常的，下一节会通过 Ruyi 虚拟环境把正确版本加入当前终端。

## 五、查看缓存与安装位置

```bash
du -sh ~/.cache/ruyi/packages-index
du -sh ~/.cache/ruyi/distfiles
du -sh ~/.local/share/ruyi/binaries/$(uname -m)
```

- `packages-index`：软件包索引；
- `distfiles`：下载的压缩包；
- `binaries`：解压后的二进制软件包。

## 六、卸载与清理

卸载单个软件包：

```bash
ruyi uninstall 软件包名
```

只清理下载缓存、保留已安装软件包：

```bash
ruyi self clean --distfiles
```

后续仍要使用 `gnu-upstream` 和 `qemu-user-riscv-upstream`，本节不要卸载它们。`ruyi self clean --installed-pkgs` 会删除全部已安装软件包，也不应作为普通缓存清理命令使用。

## 七、本节完成标准

- [ ] 能按名称查询 Ruyi 软件包；
- [ ] 已安装 `gnu-upstream`；
- [ ] 已安装 `qemu-user-riscv-upstream`；
- [ ] `ruyi list --is-installed true` 能显示两个软件包；
- [ ] 能分清索引、下载缓存和已安装文件。

完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/04-manage-packages.md

下一节将使用刚安装的工具链和模拟器创建、激活并验证 Ruyi 虚拟环境。
