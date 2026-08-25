# 【RuyiSDK Windows/WSL 教程 06】交叉编译第一个 RISC-V 程序

上一节已经创建并验证 Ruyi 虚拟环境。这一节继续使用同一个项目目录，编写一个最小的 C 程序，用 GNU RISC-V 交叉编译器生成可执行文件，并确认它的目标架构是 RISC-V。

## 一、进入项目并激活环境

```bash
cd ~/ruyisdk-work/hello-ruyi
source ./ruyi-venv/bin/ruyi-activate
command -v riscv64-unknown-linux-gnu-gcc
```

编译器路径应指向当前项目的 `ruyi-venv/bin/`。

## 二、编写 Hello World

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

运行 `cat hello.c`，确认源码内容完整。

## 三、交叉编译

```bash
riscv64-unknown-linux-gnu-gcc -O2 -static hello.c -o hello-riscv64
```

本示例使用静态链接，便于下一节直接通过 QEMU 运行，减少对目标系统动态加载器和共享库的依赖。

## 四、确认目标架构

```bash
ls -lh hello.c hello-riscv64
file ./hello-riscv64
riscv64-unknown-linux-gnu-readelf -h ./hello-riscv64
```

`file` 输出中应包含 `ELF 64-bit`、`RISC-V` 和 `statically linked`；`readelf` 输出中应看到 `Machine: RISC-V`。

当前 WSL 主机通常是 `x86_64`，而生成的程序面向 `riscv64`。因此，本节只确认编译和目标架构，不把它当作普通 x86-64 程序直接运行。

## 五、本节完成标准

- [ ] 已激活 `ruyi-venv`；
- [ ] 已创建并检查 `hello.c`；
- [ ] 已生成 `hello-riscv64`；
- [ ] `file` 显示 RISC-V 静态链接程序；
- [ ] `readelf` 显示 `Machine: RISC-V`；
- [ ] 能区分主机架构和目标架构。

完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/06-cross-compile-hello.md

下一节将使用 Ruyi 虚拟环境中的 QEMU 运行这个 RISC-V 程序。
