# 【RuyiSDK Windows/WSL 教程 08】使用 VS Code Remote - WSL 开发

前面已经在 Ubuntu 终端中完成 RISC-V 程序的交叉编译和 QEMU 运行。这一节安装 Windows 版 VS Code 与 WSL 扩展，打开同一个 Linux 项目，并在图形化编辑器中完成“编辑、保存、编译、检查、运行”的完整循环。

VS Code 界面运行在 Windows，项目文件、终端、Ruyi 虚拟环境和编译器仍然位于 Ubuntu，避免把 Windows 与 Linux 工具链混在一起。

## 一、安装 VS Code 与 WSL 扩展

从 VS Code 官网安装 Windows 版本：

https://code.visualstudio.com/Download

在 VS Code 扩展商店搜索 `WSL`，安装 Microsoft 发布的 WSL 扩展。不要在 Ubuntu 中通过 `apt` 另外安装一份 VS Code。

## 二、从 Ubuntu 打开项目

在 Ubuntu 终端中运行：

```bash
cd ~/ruyisdk-work/hello-ruyi
code .
```

新窗口打开后，左下角应显示类似：

```text
WSL: Ubuntu-24.04
```

左侧文件列表中应能看到 `hello.c`、`hello-riscv64` 和 `ruyi-venv`。

## 三、检查集成终端并激活环境

选择 `Terminal → New Terminal`，然后运行：

```bash
pwd
uname -m
source ./ruyi-venv/bin/ruyi-activate
command -v riscv64-unknown-linux-gnu-gcc
command -v ruyi-qemu
```

`pwd` 应指向 Linux 项目目录，终端应是 Bash 而不是 `PS C:\\...`；工具链和 QEMU 路径应指向 `ruyi-venv/bin/`。

## 四、修改、编译并运行

在编辑器中修改 `hello.c`，把输出内容改为：

```c
printf("Hello from VS Code and RuyiSDK!\n");
```

按 `Ctrl+S` 保存后，在集成终端中运行：

```bash
riscv64-unknown-linux-gnu-gcc -O2 -static hello.c -o hello-riscv64
file ./hello-riscv64
ruyi-qemu ./hello-riscv64
echo $?
```

正常应看到新的输出文字和退出状态 `0`。

## 五、本节完成标准

- [ ] 已安装 Windows 版 VS Code 和 Microsoft WSL 扩展；
- [ ] 能从 Ubuntu 项目目录运行 `code .`；
- [ ] VS Code 左下角显示 `WSL: Ubuntu-24.04`；
- [ ] 集成终端位于 Linux 项目目录；
- [ ] 已重新激活 `ruyi-venv`；
- [ ] 能在编辑器中修改并保存源码；
- [ ] 能在集成终端中交叉编译并用 QEMU 运行；
- [ ] 新输出正确，且退出状态为 `0`。

完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/08-vscode-wsl.md

下一节将通过 SSH 与 SCP 把程序传到实际的 RISC-V Linux 开发板并完成板端验证。
