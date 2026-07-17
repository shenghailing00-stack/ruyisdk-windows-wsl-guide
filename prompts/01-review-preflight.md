# Prompt：让 Codex 审查第 01 节预检

将下面内容复制给位于本仓库根目录的 Codex：

```text
请读取 AGENTS.md，以及 test-records/episode-01 下时间最新的
PUBLIC-REPORT.md。当前只处于第01节“WSL 2与Ubuntu安装”的预检阶段。

目标：判断这台Windows电脑是否可以进入安装阶段。
约束：
1. 不执行安装、不修改Windows功能、不重启；
2. 不读取或发布 raw/ 目录；
3. 只依据PUBLIC-REPORT.md判断，不补全没有证据的版本；
4. 检查Windows Build、CPU架构、虚拟化和已有WSL状态；
5. 将结论分为“可以继续”“需要先处理”“证据不足”三类；
6. 如果可以继续，给出本仓库中下一条应运行的Install命令；
7. 更新 test-records/environment-baseline.md 中已有证据支持的字段，
   没有证据的保留TODO(EVIDENCE)。

完成后列出你修改的文件和仍需我亲自完成的操作。
```

