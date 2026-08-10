# 【RuyiSDK Windows/WSL 教程 06】交叉编译第一个 RISC-V 程序

上一节已经创建并验证 Ruyi 虚拟环境。这一节将在同一个项目目录中编写一个最小的 C 程序，使用 GNU RISC-V 交叉编译器生成可执行文件，并确认它的目标架构确实是 RISC-V。

本节只负责编写和编译，不运行程序。下一节再使用虚拟环境中的 QEMU 执行编译结果。把两个环节分开，有助于分清“成功生成目标文件”和“目标文件能够在模拟器中运行”。

## 完成本节后，你将能够

- 重新进入并激活已有的 Ruyi 虚拟环境；
- 编写并检查一个最小的 C 程序；
- 理解交叉编译器中“主机”和“目标”的区别；
- 使用 GNU RISC-V 工具链生成可执行文件；
- 使用 `file` 和 `readelf` 判断文件架构；
- 排查源码、环境和链接阶段的常见问题。

## 1. 进入 Ubuntu 和项目目录

在 PowerShell 中进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

下面的命令都在 Ubuntu 终端中运行。回到上一节使用的项目目录：

```bash
cd ~/ruyisdk-work/hello-ruyi
pwd
```

正常应显示类似：

```text
/home/linuxuser/ruyisdk-work/hello-ruyi
```

## 2. 激活已有的 Ruyi 虚拟环境

运行：

```bash
source ./ruyi-venv/bin/ruyi-activate
```

然后检查交叉编译器：

```bash
command -v riscv64-unknown-linux-gnu-gcc
riscv64-unknown-linux-gnu-gcc --version
```

第一条命令应指向当前项目中的 `ruyi-venv/bin/`。如果找不到命令，不要继续编译，先回到第 05 节检查环境目录和激活步骤。

## 3. 编写 Hello World 源程序

在项目目录中完整粘贴下面这段命令：

```bash
cat > hello.c <<'EOF'
#include <stdio.h>

int main(void)
{
    printf("Hello, RuyiSDK!\n");
    return 0;
}
EOF
```

这里的 `cat > hello.c` 会创建或覆盖 `hello.c`；两行 `EOF` 之间的内容会写入文件。结尾的 `EOF` 必须单独占一行。

如果终端一直等待输入，通常是结尾的 `EOF` 没有正确输入。可以先按 `Ctrl+C` 取消，再重新粘贴完整代码块。

## 4. 检查源文件

运行：

```bash
cat hello.c
```

输出应与刚才的 C 代码一致。再检查文件类型：

```bash
file hello.c
```

正常会显示它是 C 源代码或普通文本文件。源码阶段的 `hello.c` 还不区分 x86-64 与 RISC-V，目标架构由后面的编译器决定。

## 5. 理解交叉编译

当前环境中同时涉及两种架构：

| 角色 | 本教程中的架构 | 作用 |
|---|---|---|
| 主机（host） | `x86_64` | 实际运行 WSL 和编译器的电脑 |
| 目标（target） | `riscv64` | 编译结果准备运行的平台 |

可以再次确认主机架构：

```bash
uname -m
```

普通 Intel 或 AMD Windows 电脑通常显示 `x86_64`。交叉编译器本身运行在这台电脑上，但它生成的是面向 RISC-V 的机器代码。

## 6. 交叉编译程序

运行：

```bash
riscv64-unknown-linux-gnu-gcc -O2 -static hello.c -o hello-riscv64
```

命令没有输出且返回终端提示符，通常表示编译成功。各部分含义如下：

| 参数 | 含义 |
|---|---|
| `riscv64-unknown-linux-gnu-gcc` | 面向 64 位 RISC-V Linux 的 GNU C 编译器 |
| `-O2` | 使用常见的二级优化 |
| `-static` | 静态链接本示例需要的运行库 |
| `hello.c` | 输入的 C 源文件 |
| `-o hello-riscv64` | 指定输出文件名 |

这里使用静态链接，是为了让下一节的最小 QEMU 示例尽量不依赖目标系统中的动态加载器和共享库。实际项目是否使用静态链接，需要根据目标系统、体积和部署方式决定。

## 7. 确认编译结果已经生成

运行：

```bash
ls -lh hello.c hello-riscv64
```

应同时看到源码 `hello.c` 和可执行文件 `hello-riscv64`。编译后的文件通常明显大于源文件，因为静态链接把程序需要的库代码一并放入了可执行文件。

如果没有 `hello-riscv64`，说明上一条编译命令没有成功，应先查看并处理编译器输出的第一条错误。

## 8. 使用 `file` 确认目标架构

运行：

```bash
file ./hello-riscv64
```

输出中应包含以下关键信息：

```text
ELF 64-bit
RISC-V
statically linked
```

具体的 ABI、扩展和版本信息可能随工具链版本变化，不要求与教程逐字相同。最重要的是看到 `RISC-V`，而不是 `x86-64`。

## 9. 使用 `readelf` 查看 ELF 文件头

运行：

```bash
riscv64-unknown-linux-gnu-readelf -h ./hello-riscv64
```

在输出中找到：

```text
Class:                             ELF64
Machine:                           RISC-V
```

ELF 是 Linux 中常见的可执行文件格式。`file` 适合快速判断文件类型，`readelf` 则可以查看更完整的 ELF 结构信息。

## 10. 为什么本节不直接运行

WSL 当前运行在 `x86_64` 主机上，而 `hello-riscv64` 包含 RISC-V 指令。两者的指令集不同，因此不能把它当作普通 x86-64 程序直接运行。

部分系统如果额外配置过 `binfmt_misc`，直接执行时可能自动转给模拟器；没有配置时通常会出现 `Exec format error`。本系列不依赖这种系统级配置，下一节统一使用 Ruyi 虚拟环境提供的 `ruyi-qemu`，让运行路径更明确。

## 11. 修改源码后怎样重新编译

如果修改了 `hello.c`，只需再次运行同一条编译命令：

```bash
riscv64-unknown-linux-gnu-gcc -O2 -static hello.c -o hello-riscv64
```

新的输出会覆盖旧的 `hello-riscv64`。编译后重新运行 `file`，仍应确认目标架构为 RISC-V。

## 12. 常见问题

### 提示 `riscv64-unknown-linux-gnu-gcc: command not found`

先检查是否位于正确目录并激活环境：

```bash
cd ~/ruyisdk-work/hello-ruyi
source ./ruyi-venv/bin/ruyi-activate
command -v riscv64-unknown-linux-gnu-gcc
```

### 创建源码后终端一直显示 `>` 等待输入

结尾的 `EOF` 必须单独占一行，前后不能添加空格。如果不确定当前输入状态，按 `Ctrl+C` 取消，再重新粘贴第 3 步的完整代码块。

### 出现 C 语法错误

先运行：

```bash
cat -n hello.c
```

它会显示行号。重点检查引号、分号、花括号以及 `EOF` 是否被误写进源码。

### 链接时提示找不到标准库

确认当前使用的是第 05 节创建的 `generic` 环境，并保留以下输出：

```bash
command -v riscv64-unknown-linux-gnu-gcc
riscv64-unknown-linux-gnu-gcc --version
ls -ld ./ruyi-venv/sysroot
```

不要直接从其他教程复制不匹配的 `--sysroot` 路径。

### `file` 显示 `x86-64`

这通常说明使用了系统本机的 `gcc`，而不是 RISC-V 交叉编译器。重新检查实际命令必须以：

```text
riscv64-unknown-linux-gnu-gcc
```

开头，然后重新生成输出文件。

### 输出文件很大

这是静态链接的常见结果。当前示例优先保证 QEMU 运行步骤简单，因此文件体积不是本节的优化目标。

## 13. 本节检查

- [ ] 已进入 `~/ruyisdk-work/hello-ruyi`；
- [ ] 已激活 `ruyi-venv`；
- [ ] `hello.c` 内容完整且能够通过编译；
- [ ] 已生成 `hello-riscv64`；
- [ ] `file` 输出包含 `RISC-V` 和 `statically linked`；
- [ ] `readelf` 显示 `Machine: RISC-V`；
- [ ] 理解当前主机与目标架构不同；
- [ ] 本节没有把程序是否能运行与编译是否成功混为一谈。

完成以上检查后，第一个 RISC-V 可执行文件已经准备好了。

## 下一节

[下一节：使用 QEMU 运行 RISC-V 程序](07-run-with-qemu.md)

## 参考资料

- [RuyiSDK VS Code 插件：Hello World 开发流程示例](https://ruyisdk.org/docs/VSCode-Plugins/)
- [RuyiSDK：使用 QEMU 和 LLVM](https://ruyisdk.org/docs/Package-Manager/cases/case6/)
