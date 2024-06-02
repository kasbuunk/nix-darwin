# Nix Darwin 

This configuration file can be used on a clean or existing macOS system. The guide will only account for fresh installations. Be mindful that configuring your existing macOS installation may override existing configuration data. In addition, there may be personal details that ought to be adjusted for your use cases, such as names and home directories.

## Guide

This guide is purely for my own reference. If you found it useful, great! If you have suggestions or questions, please let me know via a pull request or issue. 

### Reset your mac 

1. Back up any relevant data to an external data store.
1. Reset your mac via System Preferences -> `Erase all data and configurations` and follow the instructions.
1. Configure an internet connections, choose language and country. Skip the optional parts, like accessibility.
1. Log in with Apple ID.
1. Choose a strong password.
1. Allow location services.
1. Disable Siri.
1. Enable fileVault encryption.
1. Configure Touch ID.

### Configure your mac

Launch a terminal session and run:

```sh
xcode-select --install # Follow the wizard.
```

Reboot.

```sh
sudo xcodebuild -license accept # Needed later for nix-darwin.

# Nix Darwin apparently fails on trying to copy this file, because it's missing.
# An empty file solves the issue.
sudo mkdir -p /usr/local/bin
sudo touch /usr/local/bin/op
```

Go to System Preferences -> General -> About and choose a name, e.g. `KasBook`. Whatever this name is, remember to replace any occurrence with your name of choice in the Darwin configuration files. While you're here, enable the firewall in security settings.

Install Homebrew by running the one-line installer (at your own risk):
https://brew.sh

Install Nix by running the one-line installer (at your own risk):
https://nixos.org/download/

Clone this repo in `~/.config/nix-darwin`.

Install Nix Darwin by following the Flake-based instructions from https://github.com/LnL7/nix-darwin.

```sh
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.config/nix-darwin
```

Click `allow` in the notification asking if Terminal is allowed to make changes to the system.

Reboot the system and assert whether the configuration is correct.

## Concluding remarks

Please note this is my personal documentation. There may be small, obvious steps missing, like allowing access, filling in passwords, etc.

Feel free to reach out if you found this helpful or if you have any questions or suggestions.
