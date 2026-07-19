# Windows + WSL 2 下 RuyiSDK 包管理器新手教程

这是一套面向 Windows 10/11 用户的 RuyiSDK 实操教程。主线从 WSL 2
环境搭建开始，逐步覆盖 Ruyi 包管理器、虚拟环境、RISC-V 工具链、QEMU、
VS Code 插件以及问题反馈。

## 当前进度

| 单元 | 内容 | 状态 |
|---|---|---|
| 01 | 在 Windows 10/11 安装并使用 WSL 2 与 Ubuntu | 图文与视频完成，待审核发布 |

## 第 01 节快速入口

- Windows 只读预检：双击 `START-01-PREFLIGHT.cmd`
- Ubuntu 24.04 一键验证：双击 `START-01-VERIFY.cmd`
- 一键打开三个截图证据窗口：双击 `START-01-EVIDENCE.cmd`
- 将修订内容更新到现有 GitHub 仓库：双击 `START-01-UPDATE-GITHUB.cmd`
- [第 01 节制作与发布手册](tasks/01-runbook.md)
- [图文教程](docs/01-install-wsl2.md)
- [视频脚本与字幕](video-scripts/)
- [视频封面（PNG 与 SVG）](video-assets/)
- [截图清单](assets/01-install-wsl2/README.md)
- [实测环境记录](test-records/environment-baseline.md)
- [发布与交叉宣发手册](PUBLISHING.md)
- [论坛、视频与社媒文案](publishing/)

## 实测说明

教程中的 Windows/WSL 输出均来自真实 Windows + WSL 2 环境。第 01 节测试机
在录制前已经安装 WSL，因此教程明确区分“新电脑安装步骤”和“既有环境验证”，
不会把已有环境描述成一次全新安装。
