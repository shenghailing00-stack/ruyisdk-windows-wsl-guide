# Environment baseline — Episode 01

- Test date: 2026-07-17 17:15 (UTC+8)
- Test type: verification of a pre-existing WSL installation
- Windows edition/version: Windows 11 Pro 25H2
- Windows build: 26200.8457
- Windows architecture: 64-bit
- WSL version: 2.6.3.0
- WSL kernel package: 6.6.87.2-1
- Linux kernel: 6.6.87.2-microsoft-standard-WSL2
- Distribution: Ubuntu 24.04.4 LTS (Noble Numbat)
- Linux architecture: x86_64
- WSL generation: 2
- Explicit tutorial distro: Ubuntu-24.04
- Windows default distro: Ubuntu

## Verified outcomes

- `wsl --list --verbose` reports `Ubuntu-24.04` as `Running`, version `2`.
- `/etc/os-release` reports Ubuntu 24.04.4 LTS.
- `uname -mr` reports kernel 6.6.87.2-microsoft-standard-WSL2 and x86_64.
- WSL commands run without administrator rights after installation.

## Observations

- WSL warns that a Windows localhost proxy is not mirrored into NAT-mode WSL.
  Network reachability has not yet been accepted; test DNS and HTTPS before
  installing RuyiSDK.
- The preflight WMI CPU capability fields returned `False` while
  `HypervisorPresent=True` and a WSL 2 distro was running. Functional WSL 2
  verification takes precedence for this machine.
- Initial helper revisions exposed Windows PowerShell 5.1 quoting, encoding,
  and non-system-drive working-directory problems. The helper was revised to
  use UTF-8, a safe Windows working directory, direct WSL arguments, and
  dedicated evidence scripts. These are tutorial automation defects, not
  RuyiSDK defects.

## Evidence

- `assets/01-install-wsl2/02-wsl-ubuntu-environment.png`: accepted.
- `assets/01-install-wsl2/01-winver.png`: accepted after privacy-safe crop.
- Public reports were reviewed; raw logs are intentionally not published.
