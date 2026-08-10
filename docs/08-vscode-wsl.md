# 【RuyiSDK Windows/WSL 教程 08】使用 VS Code Remote - WSL 开发

上一节已经在 Ubuntu 终端中完成 RISC-V 程序的交叉编译和 QEMU 运行。这一节安装 Windows 版 Visual Studio Code 和 WSL 扩展，打开同一个 Linux 项目，在图形化编辑器中修改源码，并从 VS Code 集成终端重新完成编译与运行。

这里的 VS Code 界面运行在 Windows，项目文件、终端命令、Ruyi 虚拟环境和编译器仍然位于 Ubuntu。这样既能使用熟悉的图形化编辑器，又不会把 Windows 和 Linux 的工具链混在一起。

## 完成本节后，你将能够

- 在 Windows 中安装 VS Code 和 WSL 扩展；
- 从 Ubuntu 终端打开 Linux 文件系统中的项目；
- 判断当前 VS Code 窗口是否已经连接 Ubuntu；
- 在 VS Code 中编辑并保存 `hello.c`；
- 在集成终端中激活 Ruyi 虚拟环境；
- 重新交叉编译并用 QEMU 运行程序；
- 判断常见的窗口、终端和环境错误。

## 1. 在 Windows 中安装 VS Code

在 Windows 浏览器中打开：

- [Visual Studio Code 官方下载页](https://code.visualstudio.com/Download)

下载 Windows 版本并运行安装程序。安装过程中如果出现“添加到 PATH”或 `Add to PATH` 选项，请勾选它。

VS Code 应安装在 Windows 中，不要在 Ubuntu 里使用 `apt` 另外安装一份。安装完成后，从 Windows 开始菜单启动一次 VS Code，确认主界面能够正常打开。

如果电脑已经安装 VS Code，可以直接进入下一步。

## 2. 安装 WSL 扩展

在 VS Code 左侧点击 Extensions 扩展图标，或按：

```text
Ctrl+Shift+X
```

在搜索框中输入：

```text
WSL
```

选择由 Microsoft 发布的 **WSL** 扩展并点击 Install。也可以安装 Microsoft 的 **Remote Development** 扩展包，但本节只需要其中的 WSL 扩展。

安装完成后，VS Code 左下角会出现远程连接入口。此时只是具备连接能力，还没有打开 Ubuntu 项目。

## 3. 从 Ubuntu 打开现有项目

打开 PowerShell，进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

下面的命令在 Ubuntu 终端中运行。进入前面几节一直使用的项目目录：

```bash
cd ~/ruyisdk-work/hello-ruyi
pwd
ls -la
```

应能看到 `hello.c`、`hello-riscv64` 和 `ruyi-venv`。确认无误后运行：

```bash
code .
```

末尾的点表示“用 VS Code 打开当前目录”。第一次运行时，VS Code 会为 Ubuntu 准备远程组件，完成后自动打开一个新窗口。

## 4. 确认当前是 WSL 窗口

观察新窗口左下角，正常应显示类似：

```text
WSL: Ubuntu-24.04
```

左侧 Explorer 文件列表中应包含：

```text
hello.c
hello-riscv64
ruyi-venv
```

这说明 VS Code 打开的是真正位于 Ubuntu 文件系统中的 `~/ruyisdk-work/hello-ruyi`，不是 Windows 中另建的同名目录。

## 5. 打开 WSL 集成终端

在 VS Code 顶部菜单选择：

```text
Terminal → New Terminal
```

在新终端中运行：

```bash
pwd
uname -m
```

`pwd` 应指向 `/home/.../ruyisdk-work/hello-ruyi`，普通 Intel 或 AMD Windows 电脑上的 `uname -m` 通常显示：

```text
x86_64
```

终端提示符应是 Bash，而不是 `PS C:\...>`。VS Code 窗口连接了 WSL 后，新建的集成终端会在 Ubuntu 中运行。

## 6. 激活 Ruyi 虚拟环境

每个新终端都需要单独激活环境。运行：

```bash
source ./ruyi-venv/bin/ruyi-activate
```

然后检查工具链和模拟器：

```bash
command -v riscv64-unknown-linux-gnu-gcc
command -v ruyi-qemu
```

两条命令都应指向当前项目的 `ruyi-venv/bin/`。看到类似 `«Ruyi ruyi-venv»` 的终端前缀，也表示当前终端已经进入 Ruyi 环境。

## 7. 在编辑器中修改源码

在左侧 Explorer 中点击 `hello.c`，把程序改成：

```c
#include <stdio.h>

int main(void)
{
    printf("Hello from VS Code and RuyiSDK!\n");
    return 0;
}
```

按：

```text
Ctrl+S
```

保存文件。编辑器标签页上的未保存圆点消失后，在集成终端中运行：

```bash
cat hello.c
```

输出应与编辑器中的代码一致。先确认保存成功，再进行编译。

## 8. 在集成终端中交叉编译

运行与第 06 节相同的命令：

```bash
riscv64-unknown-linux-gnu-gcc -O2 -static hello.c -o hello-riscv64
```

命令没有输出并返回提示符，通常表示编译成功。继续检查：

```bash
file ./hello-riscv64
```

输出中应包含：

```text
ELF 64-bit
RISC-V
statically linked
```

这说明 VS Code 集成终端使用的仍然是 Ruyi 虚拟环境中的交叉编译器。

## 9. 使用 QEMU 运行新程序

运行：

```bash
ruyi-qemu ./hello-riscv64
echo $?
```

正常应显示：

```text
Hello from VS Code and RuyiSDK!
0
```

第一行来自刚刚修改的源码，`0` 表示程序正常结束。至此已经在 VS Code 中完成“编辑—保存—交叉编译—检查架构—模拟运行”的完整循环。

## 10. 认识三个不同的运行位置

本节同时出现 Windows、WSL 和 RISC-V 目标程序，三者作用不同：

| 位置 | 本节负责什么 |
|---|---|
| Windows | 显示 VS Code 图形界面 |
| Ubuntu 24.04（WSL） | 保存项目、运行 Ruyi、交叉编译和启动 QEMU |
| RISC-V 目标环境 | `hello-riscv64` 面向的指令集；本节由 QEMU 模拟 |

左下角的 `WSL: Ubuntu-24.04` 和终端中的 `pwd`、`uname -m` 是判断当前环境的主要依据，不要仅凭窗口外观判断。

## 11. 下次怎样重新打开项目

下次继续开发时，在 PowerShell 中进入 Ubuntu：

```powershell
wsl -d Ubuntu-24.04
```

然后在 Ubuntu 中运行：

```bash
cd ~/ruyisdk-work/hello-ruyi
code .
```

VS Code 打开后，新建终端并重新激活环境：

```bash
source ./ruyi-venv/bin/ruyi-activate
```

关闭 VS Code 或终端不会删除项目和虚拟环境，也不需要重新运行 `ruyi venv`。

## 12. 可选：安装 RuyiSDK VS Code 插件

RuyiSDK 还提供官方 VS Code 插件，可以在侧边栏查看软件包和虚拟环境。需要使用时，请在已经连接 WSL 的 VS Code 窗口中打开 Extensions，搜索：

```text
RuyiSDK
```

插件安装后会运行在 Ubuntu 一侧。官方文档当前要求 VS Code 1.88.0 及以上，并提供 `Ruyi: Detect Ruyi Installation` 命令检查 `ruyi`。

本系列前面已经通过命令行安装软件包并创建 `ruyi-venv`，因此本节的编译和运行不依赖该插件，也不需要用插件重复创建环境。

## 13. 常见问题

### Ubuntu 中提示 `code: command not found`

先完全关闭当前 Ubuntu 终端，再重新打开并运行：

```bash
code --version
```

如果仍然找不到，重新运行 Windows 版 VS Code 安装程序，确认勾选 `Add to PATH`。也可以从 VS Code 命令面板选择 `WSL: Connect to WSL using Distro`，再选择 `Ubuntu-24.04`。

### 左下角没有显示 WSL

当前可能是普通 Windows 窗口。关闭这个项目窗口，回到 Ubuntu 终端，在项目目录重新运行：

```bash
code .
```

也可以在 VS Code 命令面板运行 `WSL: Reopen Folder in WSL`。

### 集成终端显示 `PS C:\...>`

这表示终端仍在 Windows PowerShell 中。先确认左下角显示 `WSL: Ubuntu-24.04`，再选择 `Terminal → New Terminal`。不要在 PowerShell 中运行 `source`。

### 新终端找不到交叉编译器

虚拟环境只对已经激活的终端生效。每次新建终端后运行：

```bash
cd ~/ruyisdk-work/hello-ruyi
source ./ruyi-venv/bin/ruyi-activate
command -v riscv64-unknown-linux-gnu-gcc
```

### 程序仍然输出旧内容

先按 `Ctrl+S` 保存，再检查源码和输出文件时间：

```bash
cat hello.c
ls -l hello.c hello-riscv64
```

重新编译后再运行，不要直接执行旧的 `hello-riscv64`。

### RuyiSDK 插件找不到 `ruyi`

确认插件安装在 WSL 一侧，并在集成终端运行：

```bash
command -v ruyi
ruyi version
```

然后从命令面板运行 `Ruyi: Detect Ruyi Installation`。如果命令行本身无法找到 `ruyi`，先回到第 03 节检查安装位置。

## 14. 本节检查

- [ ] Windows 版 VS Code 能正常启动；
- [ ] 已安装 Microsoft 的 WSL 扩展；
- [ ] 能在 Ubuntu 项目目录运行 `code .`；
- [ ] VS Code 左下角显示 `WSL: Ubuntu-24.04`；
- [ ] 集成终端的 `pwd` 指向 Linux 项目目录；
- [ ] 已在集成终端激活 `ruyi-venv`；
- [ ] 已通过 VS Code 修改并保存 `hello.c`；
- [ ] `file hello-riscv64` 显示 RISC-V 静态链接程序；
- [ ] QEMU 输出修改后的文字，且退出状态为 `0`。

完成以上检查后，同一个 RuyiSDK 项目已经可以在 VS Code 与 WSL 的组合环境中开发。

## 下一节

[下一节：通过 SSH 连接 RISC-V 开发板](09-connect-board-ssh.md)

## 参考资料

- [Visual Studio Code：Developing in WSL](https://code.visualstudio.com/docs/remote/wsl)
- [Microsoft：Set up a WSL development environment](https://learn.microsoft.com/windows/wsl/setup/environment)
- [RuyiSDK VS Code 插件：安装](https://ruyisdk.org/docs/VSCode-Plugins/installation/)
- [RuyiSDK VS Code 插件：功能概览](https://ruyisdk.org/docs/VSCode-Plugins/)
