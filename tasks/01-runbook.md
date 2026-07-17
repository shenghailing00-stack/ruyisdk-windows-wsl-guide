# 第 01 节执行手册：安装 WSL 2 与 Ubuntu

## 本节最终交付

- `docs/01-install-wsl2.md`：GitHub/论坛图文正文。
- `video-scripts/01-install-wsl2.md`：8–10 分钟录屏脚本。
- `assets/01-install-wsl2/`：2 张经过隐私检查的核心截图；全新安装可增加安装截图。
- `test-records/episode-01/<时间>/PUBLIC-REPORT.md`：公开测试证据。
- 视频链接、论坛链接和社媒链接：发布后回写正文。

## 人与 AI 的分工

| 工作 | 你完成 | Codex/脚本完成 |
|---|---:|---:|
| 在真实 Windows 上运行命令 | ✓ | 生成并检查脚本 |
| 管理员授权、重启、创建 Ubuntu 用户 | ✓ | 给出准确提示 |
| 截取真实界面 | ✓ | 给出画面和文件名 |
| 采集版本、状态和日志 | 只运行一条命令 | ✓ |
| 脱敏公开报告 | 复核 | ✓ |
| 撰写图文、视频脚本、标题、简介 | 审核 | ✓ |
| 检查证据缺口、前后矛盾、隐私 | 最终确认 | ✓ |

## 阶段 A：只读预检（现在执行）

1. 将整个仓库放到 Windows 本地目录，例如：
   `C:\Users\<WindowsUser>\Documents\ruyisdk-windows-wsl-guide`。
2. 最省事的方式：双击仓库根目录的 `START-01-PREFLIGHT.cmd`。
3. 如果你希望在终端中执行，则在该文件夹空白处按住 Shift 并右键，选择
   “在终端中打开”；确认当前是 PowerShell，而不是 Ubuntu，然后执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\01-wsl-helper.ps1 -Mode Preflight -OpenFolder
```

4. 脚本只读取 Windows、虚拟化和现有 WSL 状态，不安装、不重启、不修改
   系统功能。运行完成后会打开结果文件夹。
5. 将其中的 `PUBLIC-REPORT.md` 发给 Codex。不要发送 `raw/` 文件夹。

可直接给 Codex 的提示词见：`prompts/01-review-preflight.md`。

## 阶段 B：安装 WSL 2 与 Ubuntu（预检通过后）

Codex 根据预检报告确认没有阻塞项后，再运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\01-wsl-helper.ps1 -Mode Install -Distro Ubuntu-24.04
```

脚本会请求管理员权限并要求输入 `INSTALL` 二次确认，然后调用微软官方
`wsl --install` 流程。安装可能要求重启 Windows。不要在预检前直接运行。

## 阶段 C：首次启动与验证

如果预检报告已经显示 `Ubuntu-24.04` 且 `VERSION` 为 `2`，跳过安装和重启，
直接从这里开始。

1. 从开始菜单打开 Ubuntu 24.04；如果它已经初始化过，会直接进入终端。
2. 等待首次解包，创建 Linux 用户名和密码。输入密码时屏幕不显示字符是
   正常现象。
3. 关闭 Ubuntu 窗口，双击仓库根目录的 `START-01-VERIFY.cmd`。
   如需手动执行，可在仓库根目录的 PowerShell 中运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\01-wsl-helper.ps1 -Mode Verify -Distro Ubuntu-24.04 -OpenFolder
```

4. 将新的 `PUBLIC-REPORT.md` 和按清单命名的 2 张核心截图交给 Codex。

## 阶段 C2：一次打开全部截图窗口

双击 `START-01-EVIDENCE.cmd`，脚本会同时打开 Windows 版本、WSL 状态和
Ubuntu 环境三个窗口。等待输出完成后，使用 `Win+Shift+S` 分别截图，按
`assets/01-install-wsl2/README.md` 命名。测试机已存在 WSL 时，不补造安装
截图，改用 WSL 版本与发行版列表作为真实证据。

## 阶段 D：让 Codex 自动完成终稿

使用 `prompts/01-finalize-lesson.md`。Codex会读取公开报告和截图文件名，
回填图文环境、修订视频旁白、列出缺失证据，并检查隐私与链接。

## 阶段 E：发布

先提交个人 GitHub，再将图文发布到 RuyiSDK 技术论坛；视频简介回链图文，
图文正文回链视频，最后在微信群/QQ群和社媒转发简版内容。
