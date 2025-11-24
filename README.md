# coder-server-docker-image

This image starts from `debian:13.2-slim` and optionally clones a dotfiles repository at build time and runs its installer.

Usage
-----

Build the image while specifying your dotfiles repository and branch (PowerShell example):

```powershell
docker build -t coder-server-dotfiles \
  --build-arg DOTFILES_REPO="https://github.com/your-username/dotfiles.git" \
  --build-arg DOTFILES_BRANCH="main" \
  -f dockerfile .
```

Notes
-----
- The Dockerfile installs `git`, `curl`, and `make` to support common install targets.
- During build it will clone the repo into `/tmp/dotfiles` and then attempt the following, in order:
  1. Run `sh /tmp/dotfiles/install.sh` if present.
  2. Run `sh /tmp/dotfiles/bootstrap.sh` if present.
  3. Run `make install` in the repo if a `Makefile` exists.
- If your install script requires interactive input or sudo access, adjust it to be non-interactive for Docker builds, or perform installation at container runtime instead.