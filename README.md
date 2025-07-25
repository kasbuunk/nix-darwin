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
xcode-select --install # You've unlocked a new quest. Follow the wizard!
```

Reboot.

```sh
sudo xcodebuild -license accept # Needed later for nix-darwin.

# Nix Darwin apparently fails on trying to copy this 1Password file, because it's missing.
# An empty file solves the issue.
sudo mkdir -p /usr/local/bin
sudo touch /usr/local/bin/op
sudo chmod +x /usr/local/bin/op # Make it executable. The 1password cli will appear here later.
```

Install 1Password manually from their website. In Settings -> Developer: check `Use the SSH agent`. Also, check `Integrate with 1Password CLI`. The first git operation that interacts with an ssh key, will require you to authorise 1Password to access the key.

Go to System Preferences -> General -> About and choose a name, e.g. `KasBook`. Whatever this name is, remember to replace any occurrence with your name of choice in the Darwin configuration files. While you're here, enable the firewall in security settings.

Install Homebrew by running the one-line installer (at your own risk):
https://brew.sh

Install Nix by running the one-line installer (at your own risk):
https://nixos.org/download/

Clone this repo in `~/.config/nix-darwin`.

Update the `secrets.nix` file with relevant values. In particular the `device` and `userName` must be provided. Next, trick git into thinking the file is not changed, so as not to accidentally leak sensitive values.

```sh
git update-index --assume-unchanged secrets.nix
```

Install Nix Darwin by following the Flake-based instructions from https://github.com/LnL7/nix-darwin.

```sh
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.config/nix-darwin
```

Click `allow` in the notification asking if Terminal is allowed to make changes to the system.

Reboot the system and assert whether the configuration is correct.

### Upgrade

To install after the initial installation, run the following:

```sh
export DEVICE={device} # Replace with the same device name from secrets.nix.
sudo darwin-rebuild switch --flake .#DEVICE
```

### Initialise programs

#### Podman

Run the following to initialise podman:

```sh
podman machine init
podman machine start
```

## Concluding remarks

Please note this is my personal documentation. There may be small, obvious steps missing, like allowing access, filling in passwords, etc.

Feel free to reach out if you found this helpful or if you have any questions or suggestions.
