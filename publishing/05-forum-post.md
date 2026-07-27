# 【RuyiSDK Windows/WSL 教程 05】创建并使用 Ruyi 虚拟环境

上一节已经安装 GNU RISC-V 工具链和 QEMU。这一节把它们组合到一个独立的 Ruyi 虚拟环境中，并完成创建、激活、验证和退出。

Ruyi 虚拟环境用于隔离工具链、模拟器、sysroot 和目标平台配置，不是 Python 虚拟环境。

## 一、进入项目目录

```bash
mkdir -p ~/ruyisdk-work/hello-ruyi
cd ~/ruyisdk-work/hello-ruyi
```

后续的环境、源码和编译结果都会放在这里。

## 二、确认软件包与 profile

```bash
ruyi list --is-installed true
ruyi list profiles
```

已安装列表中应包含 `gnu-upstream` 和 `qemu-user-riscv-upstream`，profile 列表中应存在 `generic`。

## 三、创建虚拟环境

```bash
ruyi venv -t gnu-upstream -e qemu-user-riscv-upstream generic ./ruyi-venv
```

其中：

- `-t` 选择工具链；
- `-e` 选择模拟器；
- `generic` 指定常规 `riscv64` Linux 配置；
- `./ruyi-venv` 是环境目录。

## 四、查看并激活环境

```bash
ls -la ./ruyi-venv
source ./ruyi-venv/bin/ruyi-activate
```

激活后，终端提示符通常会出现 Ruyi 环境前缀。

## 五、验证工具链与 QEMU

```bash
command -v riscv64-unknown-linux-gnu-gcc
riscv64-unknown-linux-gnu-gcc --version
command -v ruyi-qemu
ruyi-qemu --version
```

两个 `command -v` 的结果都应指向当前项目的 `ruyi-venv/bin/`。

## 六、退出与再次进入

退出环境：

```bash
ruyi-deactivate
```

下次重新打开 Ubuntu 后，不必重建，只需运行：

```bash
cd ~/ruyisdk-work/hello-ruyi
source ./ruyi-venv/bin/ruyi-activate
```

## 七、本节完成标准

- [ ] 已创建 `~/ruyisdk-work/hello-ruyi/ruyi-venv`；
- [ ] 能激活 Ruyi 虚拟环境；
- [ ] 能运行交叉编译器的版本命令；
- [ ] 能运行 `ruyi-qemu --version`；
- [ ] 能退出并再次进入已有环境。

完整图文教程：
https://github.com/shenghailing00-stack/ruyisdk-windows-wsl-guide/blob/master/docs/05-create-venv.md

下一节将在这个环境中编写并交叉编译第一个 RISC-V Hello World 程序。
