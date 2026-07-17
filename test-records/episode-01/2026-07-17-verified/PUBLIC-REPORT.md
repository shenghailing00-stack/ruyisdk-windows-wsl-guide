# Episode 01 public verification report

- Generated from reviewed evidence: 2026-07-17 (UTC+8)
- Test type: pre-existing WSL environment verification
- Administrator rights required for verification: No
- Windows: Windows 11 Pro 25H2
- Windows build: 26200.8457
- Windows architecture: 64-bit

## WSL

```text
WSL version: 2.6.3.0
Kernel package: 6.6.87.2-1
WSLg version: 1.0.71
Windows: 10.0.26200.8457
```

## Installed distributions

```text
NAME            STATE      VERSION
Ubuntu          Stopped    2
Ubuntu-24.04    Running    2
```

The Windows default distribution is `Ubuntu`; tutorial commands explicitly
select `Ubuntu-24.04`.

## Ubuntu 24.04

```text
PRETTY_NAME="Ubuntu 24.04.4 LTS"
VERSION_ID="24.04"
VERSION_CODENAME=noble
6.6.87.2-microsoft-standard-WSL2 x86_64
```

## Observation

WSL reported that a Windows localhost proxy was not mirrored into NAT-mode
WSL. This did not block local WSL and Ubuntu verification. DNS and HTTPS
reachability remain a separate test for the next episode.

## Evidence review

- [x] `01-winver.png` shows Windows edition, version, and build without the
  licensed Windows username.
- [x] `02-wsl-ubuntu-environment.png` shows the commands and outputs above.
- [x] No username, computer name, IP address, token, or proxy value is shown.
- [x] The images are real screenshots; no generated technical output is used.
- [x] This report does not claim that WSL was freshly installed during the test.
