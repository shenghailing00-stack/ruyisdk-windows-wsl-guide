# Prompt：让 Codex 完成第 01 节发布稿

当 Verify 报告和 2 张核心发布截图准备好后，将下面内容交给 Codex：

```text
请读取 AGENTS.md，并完成第01节发布稿。

证据来源仅限：
- test-records/episode-01 下最新的 Preflight、Install、Verify
  PUBLIC-REPORT.md；
- assets/01-install-wsl2 下4张经过隐私检查的发布截图；
-本文已列出的微软官方链接。

请完成：
1. 用真实报告回填 docs/01-install-wsl2.md 的测试环境和操作结果；
2. 调整 video-scripts/01-install-wsl2.md，使命令、版本和画面一致；
3. 检查所有截图链接和文件名；
4. 搜索全文 TODO(EVIDENCE)，有证据则解决，无证据则集中列为阻塞项；
5. 检查用户名、计算机名、IP、Token、代理和个人目录泄露；
6. 对照图文、视频脚本和报告，列出并修复矛盾；
7. 不得编造任何终端输出或截图内容；
8. 最后给出可发布性结论和仍需我人工确认的最短清单。

完成标准以 AGENTS.md 为准。
```
