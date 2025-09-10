{ pkgs, lib, specialArgs, ... }:
let
  device = specialArgs.device;
  userName = specialArgs.userName;
in
{
  environment.shells = [ pkgs.fish pkgs.zsh pkgs.bash ];


  # Environment variables available in all shell inititialisations.
  environment.variables = {
    EDITOR = "vim";
  };

  environment.systemPackages = [
    pkgs.vim
  ];

  # Fonts.
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      recursive
      monaspace
    ];
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    taps = [
    ];
    brews = [
    ];
    casks = [
      "font-hack-nerd-font"
      "font-fira-mono-nerd-font"
      "font-fira-code-nerd-font"
      "font-go-mono-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "microsoft-teams"
      "nikitabobko/tap/aerospace"
      "obsidian"
      "qmk-toolbox"
      # "rancher"
      "visual-studio-code"
    ];
    masApps = {
      # Uncomment on first install. Takes a long time each rebuild.
      "Azure VPN Client" = 1553936137;
      # "Slack" = 803453959;
      # "Xcode" = 497799835;
      # "Keymapp" = 6472865291;
    };
    whalebrews = [
    ];
  };

  networking.computerName = "${device}";

  # Enable experimental nix command and flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nix.package = pkgs.unstable.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  
  nixpkgs.config.allowUnfree = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs.bash.enable = true;
  programs.direnv.enable = true;
  programs.direnv.silent = false;
  programs.fish.enable = true;
  programs.fish.shellInit = ''for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move $p/bin; end'';
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.emacs.enable = true;

  system.activationScripts."copy1password".text = ''
    cp -f ${pkgs.unstable._1password}/bin/op /usr/local/bin/op
  '';
 
  system.defaults.".GlobalPreferences"."com.apple.sound.beep.sound" = "/System/Library/Sounds/Morse.aiff";
  system.defaults.NSGlobalDomain = {
    AppleEnableSwipeNavigateWithScrolls = true;
    AppleInterfaceStyle = "Dark";
    AppleICUForce24HourTime = true;
    AppleKeyboardUIMode = 3;
    AppleMetricUnits = 1;
    AppleMeasurementUnits = "Centimeters";
    ApplePressAndHoldEnabled = false;
    AppleScrollerPagingBehavior = true;
    AppleShowAllFiles = true;
    AppleShowScrollBars = "Always";
    AppleTemperatureUnit = "Celsius";
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;
    "com.apple.keyboard.fnState" = false;
    "com.apple.mouse.tapBehavior" = null;
    "com.apple.swipescrolldirection" = true;
    "com.apple.trackpad.enableSecondaryClick" = true;
    "com.apple.trackpad.scaling" = 5.0;
  };
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
  system.defaults.alf.allowdownloadsignedenabled = 0;
  system.defaults.alf.stealthenabled = 1;

  system.defaults.dock = {
    autohide = true;
    mru-spaces = false;
    persistent-apps = [
      "/Applications/Firefox.app"
      "/Applications/Slack.app"
      "Users/${userName}/Applications/Home\ Manager\ Apps/Emacs.app"
      "Users/${userName}/Applications/Home\ Manager\ Apps/Alacritty.app"
      "/Applications/Obsidian.app"
      "/Applications/Microsoft\ Outlook.app"
      "/Applications/Microsoft\ Teams.app"
      "/Applications/1Password.app"
    ];
    persistent-others = [
    ];
    wvous-bl-corner = 4; # Desktop
    wvous-br-corner = 14; # Quick Note
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXDefaultSearchScope = "SCcf"; # Current Folder
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "clmv"; # Column View
    QuitMenuItem = true;
    ShowPathbar = true;
    ShowStatusBar = true;
  };

  system.defaults.loginwindow.GuestEnabled = false;
  system.defaults.menuExtraClock = {
    IsAnalog = false;
    Show24Hour = true;
    ShowAMPM = false;
    ShowDate = 1;
    ShowDayOfMonth = true;
    ShowDayOfWeek = true;
    ShowSeconds = true;
  };

  system.defaults.screencapture = {
    location = "~/Documents/ScreenCaptures";
    type = "jpg";
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.primaryUser = "${userName}";

  # For backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  time.timeZone = "Europe/Amsterdam";
  
  users.users.${userName} = {
    name = "${userName}";
    home = "/Users/${userName}";
    shell = pkgs.zsh;
  };
}
