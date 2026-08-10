# 【RuyiSDK Windows/WSL 教程 07】使用 QEMU 运行 RISC-V 程序

上一节已经使用 GNU RISC-V 交叉编译器生成 `hello-riscv64`，并确认它是 64 位 RISC-V ELF 文件。这一节使用 Ruyi 虚拟环境提供的 `ruyi-qemu` 在当前 WSL 电脑上运行它，检查程序输出与退出状态。

这里使用的是 QEMU 用户态模拟器。它负责执行单个 RISC-V Linux 用户态程序，不会启动一套完整的 RISC-V 操作系统。

## 完成本节后，你将能够

- 重新激活已有的 Ruyi 虚拟环境；
- 检查待运行程序和 QEMU 入口；
- 使用 `ruyi-qemu` 运行 RISC-V 可执行文件；
- 使用退出状态判断程序是否正常结束；
- 理解用户态模拟与完整系统模拟的区别；
- 排查架构、路径和动态加载器相关问题。

## 1. 进入 Ubuntu 和项目目录

在 PowerShell 中进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

下面的命令都在 Ubuntu 终端中运行。进入项目目录：

```bash
cd ~/ruyisdk-work/hello-ruyi
pwd
```

## 2. 激活 Ruyi 虚拟环境

运行：

```bash
source ./ruyi-venv/bin/ruyi-activate
```

检查 QEMU 入口：

```bash
command -v ruyi-qemu
ruyi-qemu --version
```

`command -v` 的结果应指向当前项目的 `ruyi-venv/bin/`。如果提示找不到命令，先不要安装系统里的其他 QEMU 包，应回到第 05 节检查虚拟环境是否包含 `qemu-user-riscv-upstream`。

## 3. 检查待运行的程序

确认上一节的输出文件仍然存在：

```bash
ls -lh ./hello-riscv64
file ./hello-riscv64
```

`file` 输出中应包含：

```text
ELF 64-bit
RISC-V
statically linked
```

如果文件不存在，或显示为 `x86-64`，请先回到第 06 节重新编译，不要继续运行。

## 4. 使用 QEMU 运行程序

运行：

```bash
ruyi-qemu ./hello-riscv64
```

正常应输出：

```text
Hello, RuyiSDK!
```

看到这行文字说明以下链路已经连通：

1. C 源码能够被交叉编译；
2. 编译结果确实包含可执行的 RISC-V 指令；
3. Ruyi 虚拟环境能够找到 QEMU；
4. QEMU 能够在当前 x86-64 WSL 中模拟执行该程序。

## 5. 检查程序退出状态

紧接着运行：

```bash
echo $?
```

正常应显示：

```text
0
```

在 Linux 中，`0` 通常表示上一条命令成功结束，非零值通常表示出现错误。`$?` 只保存最近一条命令的退出状态，因此要在运行程序之后立即检查。

## 6. QEMU 在这里做了什么

当前电脑的处理器通常执行 x86-64 指令，而 `hello-riscv64` 中保存的是 RISC-V 指令。`ruyi-qemu` 调用与虚拟环境匹配的 QEMU 用户态模拟器，把程序执行过程转换为主机能够处理的操作。

这一过程可以概括为：

```text
RISC-V 可执行文件 → QEMU 用户态模拟 → x86-64 WSL 主机
```

模拟运行适合快速检查交叉编译结果，但它不等同于真实开发板。程序的性能、外设、内核和硬件行为，仍需要在相应的 RISC-V 系统或开发板上验证。

## 7. 用户态模拟与完整系统模拟

QEMU 常见的两种使用方式如下：

| 方式 | 本节是否使用 | 作用 |
|---|---|---|
| 用户态模拟 | 是 | 在现有 Linux 环境中运行单个其他架构的用户态程序 |
| 系统模拟 | 否 | 模拟处理器、内存和部分硬件，并启动完整操作系统 |

本节安装的是 `qemu-user-riscv-upstream`，所以直接运行单个 RISC-V Linux 程序，不需要准备内核、根文件系统或虚拟磁盘。

## 8. 为什么使用 `ruyi-qemu`

Ruyi 虚拟环境会根据所选 profile、工具链和模拟器生成 `ruyi-qemu` 入口。使用它有两个好处：

- 不必手动寻找 Ruyi 安装目录中的 QEMU 二进制文件；
- 运行命令与当前项目的虚拟环境保持一致。

因此，本系列不要求另外执行：

```bash
sudo apt install qemu-user
```

也不要把网上其他环境的 QEMU 绝对路径直接复制到本项目。

## 9. 静态链接在本示例中的作用

上一节使用了 `-static`。这会把本示例依赖的运行库代码放进可执行文件，使 QEMU 运行时不必再从目标 sysroot 中寻找动态加载器和共享库。

这样做适合最小入门验证，但也会增大文件体积。实际项目可能使用动态链接，并通过目标系统或 sysroot 提供相应库文件；届时必须保证工具链、ABI、动态加载器和目标系统相互匹配。

## 10. 修改、编译、运行的完整循环

以后修改 `hello.c` 后，可以按下面的顺序重新验证：

```bash
riscv64-unknown-linux-gnu-gcc -O2 -static hello.c -o hello-riscv64
file ./hello-riscv64
ruyi-qemu ./hello-riscv64
echo $?
```

这四步分别完成：编译、确认架构、模拟运行、检查退出状态。它们构成了当前最小的 RISC-V 开发闭环。

## 11. 常见问题

### `ruyi-qemu: command not found`

重新进入项目目录并激活环境：

```bash
cd ~/ruyisdk-work/hello-ruyi
source ./ruyi-venv/bin/ruyi-activate
command -v ruyi-qemu
```

如果仍然找不到，运行 `ruyi list --is-installed true`，确认已经安装 `qemu-user-riscv-upstream`。

### 提示找不到 `hello-riscv64`

检查当前目录：

```bash
pwd
ls -la
```

应位于 `~/ruyisdk-work/hello-ruyi`，并能看到该文件。注意 Linux 文件名区分大小写。

### 显示 `Invalid ELF image for this architecture`

先运行：

```bash
file ./hello-riscv64
```

如果显示 `x86-64`，说明文件不是用 RISC-V 交叉编译器生成的。回到第 06 节，使用 `riscv64-unknown-linux-gnu-gcc` 重新编译。

### 提示缺少动态加载器或共享库

如果输出中出现 `ld-linux`、`libc.so` 或 `Could not open`，很可能当前文件使用了动态链接。按本教程的命令重新静态编译：

```bash
riscv64-unknown-linux-gnu-gcc -O2 -static hello.c -o hello-riscv64
file ./hello-riscv64
```

确认输出包含 `statically linked` 后再运行。

### 出现 `Illegal instruction`

这通常表示程序使用了当前模拟器未支持或未启用的 RISC-V 指令扩展。保留以下信息：

```bash
ruyi version
ruyi-qemu --version
file ./hello-riscv64
riscv64-unknown-linux-gnu-readelf -h ./hello-riscv64
```

本教程使用同一 `generic` 虚拟环境中的 `gnu-upstream` 与 `qemu-user-riscv-upstream`。不要在排障时随意混用其他工具链生成的文件。

### 程序有输出，但 `echo $?` 不是 `0`

`$?` 只对应它前面的那一条命令。重新连续运行：

```bash
ruyi-qemu ./hello-riscv64
echo $?
```

如果仍然是非零值，说明程序或 QEMU 实际返回了错误，应保留两条命令的完整输出。

## 12. 本节检查

- [ ] 已激活 `ruyi-venv`；
- [ ] `command -v ruyi-qemu` 指向当前项目环境；
- [ ] `file hello-riscv64` 显示 64 位 RISC-V ELF；
- [ ] `ruyi-qemu ./hello-riscv64` 输出 `Hello, RuyiSDK!`；
- [ ] `echo $?` 返回 `0`；
- [ ] 能区分 QEMU 用户态模拟和完整系统模拟；
- [ ] 理解 QEMU 验证不能替代真实开发板测试；
- [ ] 能按“修改—编译—检查—运行”的顺序重复验证。

完成以上检查后，从 C 源码到 RISC-V 可执行文件，再到 QEMU 模拟运行的最小闭环已经打通。

## 下一节

[下一节：使用 VS Code Remote - WSL 开发](08-vscode-wsl.md)

## 参考资料

- [RuyiSDK VS Code 插件：Hello World 开发流程示例](https://ruyisdk.org/docs/VSCode-Plugins/)
- [RuyiSDK：使用 QEMU 和 LLVM](https://ruyisdk.org/docs/Package-Manager/cases/case6/)
