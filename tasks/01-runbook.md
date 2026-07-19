# 第 01 节制作与发布手册

## 本节交付内容

- `docs/01-install-wsl2.md`：GitHub 和论坛使用的图文教程；
- `video-scripts/01-install-wsl2.md`：视频分镜、口播和简介；
- `video-scripts/01-install-wsl2.srt`：视频字幕；
- `assets/01-install-wsl2/`：经过隐私检查的实测截图；
- `test-records/episode-01/<日期>/PUBLIC-REPORT.md`：公开测试记录；
- `publishing/`：视频简介、论坛稿和社媒文案。

## 1. 环境预检

将仓库保存到 Windows 本地目录，在仓库根目录双击
`START-01-PREFLIGHT.cmd`。脚本只读取 Windows、虚拟化和现有 WSL 状态，
不会安装软件、修改 Windows 功能或重启电脑。

如需在 PowerShell 中运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\01-wsl-helper.ps1 -Mode Preflight -OpenFolder
```

运行结束后检查 `PUBLIC-REPORT.md`。`raw/` 中可能包含完整系统路径和网络信息，
不应提交到公开仓库。

## 2. 安装或复用现有 WSL

如果预检中没有 `Ubuntu-24.04`，按照图文教程的安装步骤操作。也可以运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\01-wsl-helper.ps1 -Mode Install -Distro Ubuntu-24.04
```

安装脚本会请求管理员权限，并要求输入 `INSTALL` 二次确认。安装过程中可能
需要重启 Windows。

如果预检已经显示 `Ubuntu-24.04` 且 `VERSION` 为 `2`，不要卸载或重复安装，
直接进入验证阶段。

## 3. 首次启动与验证

全新安装后，从开始菜单打开 Ubuntu 24.04，等待初始化并创建 Linux 用户名和
密码。输入密码时屏幕不显示字符属于正常现象。

已有环境或初始化完成后，双击 `START-01-VERIFY.cmd`。也可以运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\01-wsl-helper.ps1 -Mode Verify -Distro Ubuntu-24.04 -OpenFolder
```

验收重点：

- `wsl --version` 能返回信息；
- `Ubuntu-24.04` 的 `VERSION` 为 `2`；
- 能读取 Ubuntu 版本；
- 能读取 Linux 内核和处理器架构。

## 4. 截图与隐私检查

双击 `START-01-EVIDENCE.cmd`，等待各窗口输出完成后，按
`assets/01-install-wsl2/README.md` 中的文件名和范围截图。

发布前确认截图中没有 Windows/Linux 用户名、计算机名、IP 地址、访问令牌、
代理地址、产品 ID 或个人通知。测试机原本已有 WSL 时，不补录或伪装一次全新
安装，只展示真实版本和验收结果。

## 5. 发布顺序

1. 更新 GitHub 中的图文、脚本和实测记录；
2. 视频审核通过后投稿 B 站，并在简介中填写 GitHub 链接；
3. 在 RuyiSDK 社区发布图文，填写 GitHub 和视频链接；
4. 回到 GitHub 正文补充视频与论坛链接；
5. 使用 `publishing/01-social-posts.md` 在交流群和社媒转发。

最终检查以 `PUBLISHING.md` 中的清单为准。
