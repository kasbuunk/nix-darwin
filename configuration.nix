{ pkgs, lib, ... }:

{
  environment.shells = [ pkgs.fish pkgs.zsh pkgs.bash ];

  # Environment variables available in all shell inititialisations.
  environment.variables = {
    EDITOR = "emacs";
  };

  environment.systemPackages = [
    pkgs.vim
  ];

  # Fonts.
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      recursive
      monaspace
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
      "google-chrome"
      "insomnia"
      "microsoft-teams"
      "orbstack"
      "postman"
      "qmk-toolbox"
      "visual-studio-code"
    ];
    masApps = {
      "Slack" = 803453959;
      "Vimari" = 1480933944;
      "Xcode" = 497799835;
    };
    whalebrews = [
    ];
  };

  networking.computerName = "KasBook";

  # Enable experimental nix command and flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  nix.configureBuildUsers = true;

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

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.emacs.enable = true;

  system.activationScripts.postUserActivation.text = ''
    sudo cp -f ${pkgs.unstable._1password}/bin/op /usr/local/bin/op
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
    "com.apple.trackpad.scaling" = 3.0;
  };
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
  system.defaults.alf.allowdownloadsignedenabled = 0;
  system.defaults.alf.stealthenabled = 1;

  system.defaults.dock = {
    autohide = true;
    mru-spaces = false;
    persistent-apps = [
      "/Applications/Safari.app"
      "/Applications/Google\ Chrome.app"
      "/Applications/Slack.app"
      "Users/kasbuunk/Applications/Home\ Manager\ Apps/Emacs.app"
      "Users/kasbuunk/Applications/Home\ Manager\ Apps/Alacritty.app"
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

  # For backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;


  time.timeZone = "Europe/Amsterdam";
  
  users.users.kasbuunk = {
    name = "kasbuunk";
    home = "/Users/kasbuunk";
    shell = pkgs.zsh;
  };
}
