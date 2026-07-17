# Repository guidance for Codex

## Project goal

Build a beginner-friendly, reproducible Chinese tutorial series for using the
RuyiSDK package manager on Windows through WSL 2. GitHub is the single source
of truth; forum posts, video descriptions, and social posts must link back here.

## Evidence rules

- Never invent Windows, WSL, Ubuntu, Ruyi, or VS Code output.
- Treat files under `test-records/**/raw/` as private evidence. Do not publish
  them or quote usernames, computer names, IP addresses, tokens, proxy values,
  or home-directory paths.
- Use `PUBLIC-REPORT.md` and reviewed images under `assets/` for publication.
- If evidence is missing, keep a visible `TODO(EVIDENCE)` marker instead of
  filling the gap from memory.
- Distinguish PowerShell commands (`PS>`) from Ubuntu Bash commands (`$`).

## Source rules

- Prefer Microsoft Learn for WSL and Windows claims.
- Prefer official RuyiSDK documentation and official RuyiSDK GitHub repos for
  Ruyi claims.
- Record the test date and versions; do not describe a time-sensitive version
  number as permanently latest.

## Episode 01 done when

- `docs/01-install-wsl2.md` contains only verified environment facts.
- `video-scripts/01-install-wsl2.md` matches the article and real screenshots.
- A public test report exists under `test-records/episode-01/`.
- The two core screenshots exist and have been privacy-reviewed; a fresh-install
  screenshot is optional and must never be fabricated.
- Markdown links work and all `TODO(EVIDENCE)` markers are either resolved or
  explicitly listed as blockers.

## Validation commands

Use these from the repository root:

```powershell
Get-ChildItem -Recurse -File | Select-String 'TODO\(EVIDENCE\)'
Get-ChildItem assets/01-install-wsl2 -File
```

Before publication, ask Codex to compare the article, video script, public
report, and screenshot checklist for contradictions and privacy leaks.
