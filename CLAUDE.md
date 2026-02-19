# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A nix-darwin + Home Manager configuration for a single macOS machine (Apple Silicon). All system and user-level config is declarative and version-controlled here.

## Key commands

**Apply configuration changes:**
```sh
sudo darwin-rebuild switch --flake .#KasBook
# Or use the zsh alias:
darwin-switch
```

**Build without switching (dry-run):**
```sh
darwin-rebuild build --flake .#KasBook
```

**Update flake inputs:**
```sh
nix flake update
```

**Initial bootstrap (fresh macOS only):**
```sh
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.config/nix-darwin
```

## Architecture

The flake composes four modules in order:

| File | Scope |
|------|-------|
| `overlays.nix` | Package overrides (dummy inetutils, sqlite doCheck=false, unstable channel) |
| `configuration.nix` | System-level: Homebrew, fonts, macOS defaults, dock, keyboard, network |
| `users.nix` | Home Manager: packages, shell, git, SSH, tmux, alacritty, AeroSpace |
| `secrets.nix` | Device name, username, domains, tokens — **git assume-unchanged** |

`flake.nix` reads `secrets.nix` at evaluation time and passes values as `specialArgs` to all modules. The device name from `secrets.nix` determines the flake output name (`darwinConfigurations.${device}`).

## secrets.nix

This file is tracked by git but marked assume-unchanged to avoid leaking personal values:
```sh
git update-index --assume-unchanged secrets.nix
```
It must be updated manually when cloning on a new machine. Required fields: `device`, `userName`.

## Notable design decisions

- **Fish shell is disabled** — pulls in a broken `inetutils` dependency on macOS; a dummy inetutils package in `overlays.nix` works around this for other tools but fish itself remains disabled.
- **Go is disabled** — commented out in `users.nix` due to size/build issues.
- **1Password** provides the SSH agent (`SSH_AUTH_SOCK`) and git commit signing via `op-ssh-sign`. The CLI binary is copied to `/usr/local/bin/op` by `configuration.nix`.
- **Homebrew** manages GUI apps and things not available in nixpkgs (casks, mas apps). Nix manages CLI tooling.
- **nixpkgs-25.11-darwin** is the stable channel; `unstable` overlay is available as `pkgs.unstable` in modules.
