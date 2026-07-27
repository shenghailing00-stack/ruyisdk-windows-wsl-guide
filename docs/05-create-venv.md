# 【RuyiSDK Windows/WSL 教程 05】创建并使用 Ruyi 虚拟环境

上一节已经安装 GNU RISC-V 工具链和 QEMU 模拟器。这一节把它们组合到一个独立的 Ruyi 虚拟环境中，完成创建、检查、激活、验证和退出。

Ruyi 虚拟环境不是 Python 虚拟环境。它用于组合工具链、模拟器、sysroot 和目标平台配置，让不同项目可以使用各自需要的开发环境，而不必把多套交叉编译工具全部写入系统全局 `PATH`。

## 完成本节后，你将能够

- 查看 Ruyi 提供的虚拟环境配置；
- 理解工具链、模拟器、profile 和环境目录的作用；
- 创建包含 GNU 工具链与 QEMU 的 `generic` 环境；
- 激活环境并检查编译器与模拟器；
- 退出并再次进入已有环境；
- 判断常见的虚拟环境创建和激活问题。

## 1. 进入项目目录

打开 PowerShell，进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

下面的命令都在 Ubuntu 终端中运行。创建一个供后续几节连续使用的项目目录：

```bash
mkdir -p ~/ruyisdk-work/hello-ruyi
cd ~/ruyisdk-work/hello-ruyi
pwd
```

最后应显示类似：

```text
/home/linuxuser/ruyisdk-work/hello-ruyi
```

后续的虚拟环境、源代码和编译结果都会放在这个项目目录中。

## 2. 确认所需软件包已经安装

运行：

```bash
ruyi list --is-installed true
```

列表中应包含：

```text
toolchain/gnu-upstream
emulator/qemu-user-riscv-upstream
```

如果缺少其中一个，先运行：

```bash
ruyi install gnu-upstream qemu-user-riscv-upstream
```

Ruyi 虚拟环境只负责组合已经安装的软件包，不会在创建时替代前面的安装步骤。

## 3. 查看可用的 profile

运行：

```bash
ruyi list profiles
```

结果中通常可以看到：

```text
generic
```

profile 用于描述目标平台需要的默认配置。`generic` 面向常规的 `riscv64` Linux 目标，适合本系列先完成基础交叉编译和 QEMU 运行。

其他 profile 可能对应具体开发板或特殊 ABI。它们需要匹配相应的工具链，不应在不了解目标平台时随意替换。

## 4. 了解创建命令

本节使用：

```bash
ruyi venv -t gnu-upstream -e qemu-user-riscv-upstream generic ./ruyi-venv
```

各部分含义如下：

| 参数 | 含义 |
|---|---|
| `venv` | 创建 Ruyi 虚拟环境 |
| `-t gnu-upstream` | 选择 GNU RISC-V 工具链 |
| `-e qemu-user-riscv-upstream` | 加入 QEMU 用户态模拟器 |
| `generic` | 使用通用 `riscv64` Linux 配置 |
| `./ruyi-venv` | 把环境创建在当前项目的 `ruyi-venv` 目录 |

可以随时运行下面的命令查看当前版本支持的完整参数：

```bash
ruyi venv --help
```

## 5. 创建虚拟环境

确认当前位于 `~/ruyisdk-work/hello-ruyi` 后，运行：

```bash
ruyi venv -t gnu-upstream -e qemu-user-riscv-upstream generic ./ruyi-venv
```

正常情况下，输出中会提示虚拟环境已经创建，并给出激活脚本的位置。创建过程还会准备 sysroot、CMake 工具链文件和 Meson 交叉编译配置。

如果 `ruyi-venv` 目录已经存在，不要直接覆盖。先确认它是否是之前创建的有效环境；已有环境可以直接进入第 7 步激活。

## 6. 查看虚拟环境内容

运行：

```bash
ls -la ./ruyi-venv
```

通常可以看到：

```text
bin
sysroot
ruyi-venv.toml
toolchain.cmake
meson-cross.ini
```

这些内容的作用如下：

| 内容 | 作用 |
|---|---|
| `bin/` | 激活脚本、工具链命令和 `ruyi-qemu` |
| `sysroot/` | 目标系统使用的头文件和库 |
| `ruyi-venv.toml` | 当前虚拟环境的配置记录 |
| `toolchain.cmake` | 供 CMake 交叉编译使用 |
| `meson-cross.ini` | 供 Meson 交叉编译使用 |

当前只需要确认这些文件已经生成，不必手动修改。

## 7. 激活虚拟环境

运行：

```bash
source ./ruyi-venv/bin/ruyi-activate
```

激活后，终端提示符通常会增加类似下面的前缀：

```text
«Ruyi ruyi-venv»
```

提示符的具体样式可能随终端和 Ruyi 版本变化。判断是否激活成功的关键，是后面的工具链命令能否被当前终端找到。

`source` 是 Bash 命令，必须在 Ubuntu 终端中运行，不能直接粘贴到 PowerShell。

## 8. 验证工具链

运行：

```bash
command -v riscv64-unknown-linux-gnu-gcc
riscv64-unknown-linux-gnu-gcc --version
```

第一条命令应指向当前项目中 `ruyi-venv/bin/` 下的文件，第二条命令应显示 GNU GCC 版本信息。

这说明工具链已经通过虚拟环境加入当前终端。这里的编译器运行在 `x86_64` WSL 中，但生成的程序面向 RISC-V。

## 9. 验证 QEMU

运行：

```bash
command -v ruyi-qemu
ruyi-qemu --version
```

`command -v ruyi-qemu` 应同样指向 `ruyi-venv/bin/`。`ruyi-qemu` 是 Ruyi 虚拟环境提供的 QEMU 入口，后续可以用它运行适合当前环境的 RISC-V 用户态程序。

本节只验证命令存在。实际编译和运行 Hello World 分别放在第 06、07 节。

## 10. 退出虚拟环境

运行：

```bash
ruyi-deactivate
```

终端提示符中的 Ruyi 环境前缀会消失，`PATH` 也会恢复到激活前的状态。

可以再次检查：

```bash
command -v riscv64-unknown-linux-gnu-gcc
```

如果系统中没有另外安装同名交叉编译器，这条命令不会输出路径。这正说明工具链只在虚拟环境激活期间生效。

## 11. 下次怎样继续使用

关闭终端不会删除虚拟环境。下次重新进入 Ubuntu 后，只需回到项目目录并再次激活：

```bash
cd ~/ruyisdk-work/hello-ruyi
source ./ruyi-venv/bin/ruyi-activate
```

不需要每次都重新运行 `ruyi venv`。

准备结束工作时，再运行：

```bash
ruyi-deactivate
```

## 12. 为什么要使用独立环境

不同项目可能需要不同的工具链版本、目标平台配置或模拟器。使用单独的 Ruyi 虚拟环境有三个直接好处：

- 不必把多套交叉编译工具永久加入全局 `PATH`；
- 一个项目的工具链升级不会直接改变另一个项目；
- 环境目录中会同时保存 sysroot、CMake 和 Meson 配置，后续更容易复现。

建议每个项目使用自己的环境目录，不要让多个无关项目共用同一个 `ruyi-venv`。

## 13. 常见问题

### 提示软件包没有安装

先运行：

```bash
ruyi list --is-installed true
```

如果缺少工具链或模拟器，重新安装：

```bash
ruyi install gnu-upstream qemu-user-riscv-upstream
```

### `source` 在 PowerShell 中无法识别

`source` 属于 Bash。先在 PowerShell 中运行：

```powershell
wsl -d Ubuntu-24.04
```

看到 `user@host:~$` 后，再运行激活命令。

### 激活脚本不存在

检查当前目录：

```bash
pwd
ls -l ./ruyi-venv/bin/ruyi-activate
```

如果目录名称或位置不同，需要把激活命令中的路径改成自己的实际路径。

### 创建时提示目标目录已经存在

已有的有效环境不需要重复创建，直接运行：

```bash
source ./ruyi-venv/bin/ruyi-activate
```

如果此前创建中断，应先确认目录里是否有 `bin/ruyi-activate` 和 `ruyi-venv.toml`，再决定保留还是重建。不要在不确定目录内容时直接删除。

### 激活后仍然找不到编译器

依次运行：

```bash
command -v ruyi
ls -l ./ruyi-venv/bin/ruyi-activate
source ./ruyi-venv/bin/ruyi-activate
command -v riscv64-unknown-linux-gnu-gcc
```

保留完整输出，以便判断是软件包、环境目录还是激活步骤的问题。

### 卸载软件包后环境失效

虚拟环境依赖创建时选用的工具链和模拟器。执行 `ruyi uninstall` 或 `ruyi self clean --installed-pkgs` 后，已有环境可能无法继续使用，而且激活时不一定立即给出警告。

因此，删除已安装软件包前应先确认没有项目仍依赖它。

## 14. 本节检查

- [ ] `ruyi list --is-installed true` 能显示工具链和模拟器；
- [ ] `ruyi list profiles` 中存在 `generic`；
- [ ] 已在 `~/ruyisdk-work/hello-ruyi` 中创建 `ruyi-venv`；
- [ ] 能使用 `source` 激活环境；
- [ ] 能运行 `riscv64-unknown-linux-gnu-gcc --version`；
- [ ] 能运行 `ruyi-qemu --version`；
- [ ] 能使用 `ruyi-deactivate` 退出环境；
- [ ] 知道下次不必重建，只需重新激活。

完成以上检查后，RISC-V 交叉编译和模拟运行环境已经准备好。

## 下一节

下一节将在这个虚拟环境中编写并交叉编译第一个 RISC-V Hello World 程序。

## 参考资料

- [RuyiSDK：使用集成功能](https://ruyisdk.org/docs/Package-Manager/intergration/)
- [RuyiSDK：管理 Ruyi 软件包](https://ruyisdk.org/docs/Package-Manager/packages/)
