# 【RuyiSDK Windows/WSL 教程 07】使用 QEMU 运行 RISC-V 程序

上一节已经生成并检查了 RISC-V 可执行文件 `hello-riscv64`。这一节使用 Ruyi 虚拟环境提供的 `ruyi-qemu` 在 WSL 电脑上运行它，并通过退出状态确认程序是否正常结束。

这里使用的是 QEMU 用户态模拟器：它执行单个 RISC-V Linux 用户态程序，不会启动一套完整的 RISC-V 操作系统。

## 一、进入项目并激活环境

```bash
cd ~/ruyisdk-work/hello-ruyi
source ./ruyi-venv/bin/ruyi-activate
command -v ruyi-qemu
ruyi-qemu --version
```

`ruyi-qemu` 的路径应指向当前项目的 `ruyi-venv/bin/`。

## 二、检查待运行程序

```bash
ls -lh ./hello-riscv64
file ./hello-riscv64
```

`file` 输出中应包含 `RISC-V` 和 `statically linked`。如果文件不存在或显示 `x86-64`，先回到第 06 节重新编译。

## 三、使用 QEMU 运行

```bash
ruyi-qemu ./hello-riscv64
```

正常应输出：

```text
Hello, RuyiSDK!
```

继续检查退出状态：

```bash
echo $?
```

输出 `0` 表示上一条程序正常结束。

## 四、理解本期结果

WSL 主机执行的是 x86-64 指令，`hello-riscv64` 包含 RISC-V 指令。QEMU 在两者之间完成指令模拟，因此无需实际开发板也能先验证这个用户态程序。

本教程使用虚拟环境中的 `ruyi-qemu`，是为了让模拟器版本与当前 Ruyi 环境保持一致。前一期采用静态链接，则减少了动态加载器和目标共享库不匹配带来的干扰。

## 五、本节完成标准

- [ ] 已重新激活 `ruyi-venv`；
- [ ] `ruyi-qemu` 指向当前虚拟环境；
- [ ] 已确认 `hello-riscv64` 是 RISC-V 静态链接程序；
- [ ] QEMU 输出 `Hello, RuyiSDK!`；
- [ ] `echo $?` 输出 `0`；
- [ ] 能区分用户态模拟与完整系统模拟。

完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/07-run-with-qemu.md

下一节将在 VS Code Remote - WSL 中复现“编辑、编译、检查、运行”的完整流程。
