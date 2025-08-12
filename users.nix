{ pkgs, lib, specialArgs, ... }:
let
  userName = specialArgs.userName;
  authSocket = specialArgs.authSocket;
  gitSigningKey = specialArgs.gitSigningKey;
  privateDomain = specialArgs.privateDomain;
  companyDomain = specialArgs.companyDomain;
  clientDomain = specialArgs.clientDomain;
  clientNamespace = specialArgs.clientNamespace;
  clientToken = specialArgs.clientToken;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.${userName} = {
    # Complete configuration options:
    # https://nix-community.github.io/home-manager/options.xhtml

    manual.manpages.enable = true;

    fonts.fontconfig = {
      enable = true;
    };

    home = {
      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';

        # A bit contrived, but this at least removes plaintext email addresses.
        ".config/git/allowed_signers".text = ''
          kas.buunk@${clientDomain} ${gitSigningKey}
          kbuunk@${companyDomain} ${gitSigningKey}
          kasbuunk@${privateDomain} ${gitSigningKey}
        '';

        ".config/aerospace/aerospace.toml".text = ''
          # Place a copy of this config to ~/.aerospace.toml
          # After that, you can edit ~/.aerospace.toml to your liking

          # You can use it to add commands that run after login to macOS user session.
          # 'start-at-login' needs to be 'true' for 'after-login-command' to work
          # Available commands: https://nikitabobko.github.io/AeroSpace/commands
          after-login-command = []

          # You can use it to add commands that run after AeroSpace startup.
          # 'after-startup-command' is run after 'after-login-command'
          # Available commands : https://nikitabobko.github.io/AeroSpace/commands
          after-startup-command = []

          # Start AeroSpace at login
          start-at-login = true

          # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
          enable-normalization-flatten-containers = true
          enable-normalization-opposite-orientation-for-nested-containers = true

          # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
          # The 'accordion-padding' specifies the size of accordion padding
          # You can set 0 to disable the padding feature
          accordion-padding = 30

          # Possible values: tiles|accordion
          default-root-container-layout = 'tiles'

          # Possible values: horizontal|vertical|auto
          # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
          #               tall monitor (anything higher than wide) gets vertical orientation
          default-root-container-orientation = 'auto'

          # Possible values: (qwerty|dvorak)
          # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
          key-mapping.preset = 'qwerty'

          # Mouse follows focus when focused monitor changes
          # Drop it from your config, if you don't like this behavior
          # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
          # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
          # Fallback value (if you omit the key): on-focused-monitor-changed = []
          on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

          # Gaps between windows (inner-*) and between monitor edges (outer-*).
          # Possible values:
          # - Constant:     gaps.outer.top = 8
          # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
          #                 In this example, 24 is a default value when there is no match.
          #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
          #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
          [gaps]
          inner.horizontal = 0
          inner.vertical =   0
          outer.left =       0
          outer.bottom =     0
          outer.top =        0
          outer.right =      0

          # 'main' binding mode declaration
          # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
          # 'main' binding mode must be always presented
          # Fallback value (if you omit the key): mode.main.binding = {}
          [mode.main.binding]

          # All possible keys:
          # - Letters.        a, b, c, ..., z
          # - Numbers.        0, 1, 2, ..., 9
          # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
          # - F-keys.         f1, f2, ..., f20
          # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
          #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
          # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
          #                   keypadMinus, keypadMultiply, keypadPlus
          # - Arrows.         left, down, up, right

          # All possible modifiers: cmd, alt, ctrl, shift

          # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

          # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
          # You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
          # alt-enter = '''exec-and-forget osascript -e '
          # tell application "Terminal"
          #     do script
          #     activate
          # end tell'
          # '''

          # See: https://nikitabobko.github.io/AeroSpace/commands#layout
          ctrl-shift-alt-slash = 'layout tiles horizontal vertical'
          ctrl-shift-alt-comma = 'layout accordion horizontal vertical'

          # See: https://nikitabobko.github.io/AeroSpace/commands#focus
          ctrl-shift-alt-h = 'focus left'
          ctrl-shift-alt-j = 'focus down'
          ctrl-shift-alt-k = 'focus up'
          ctrl-shift-alt-l = 'focus right'

          # See: https://nikitabobko.github.io/AeroSpace/commands#move
          ctrl-shift-alt-cmd-h = 'move left'
          ctrl-shift-alt-cmd-j = 'move down'
          ctrl-shift-alt-cmd-k = 'move up'
          ctrl-shift-alt-cmd-l = 'move right'

          # See: https://nikitabobko.github.io/AeroSpace/commands#resize
          ctrl-alt-shift-minus = 'resize smart -50'
          ctrl-alt-shift-equal = 'resize smart +50'

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
          ctrl-shift-alt-1 = 'workspace 1'
          ctrl-shift-alt-2 = 'workspace 2'
          ctrl-shift-alt-3 = 'workspace 3'
          ctrl-shift-alt-4 = 'workspace 4'
          ctrl-shift-alt-5 = 'workspace 5'
          ctrl-shift-alt-6 = 'workspace 6'
          ctrl-shift-alt-7 = 'workspace 7'
          ctrl-shift-alt-8 = 'workspace 8'
          ctrl-shift-alt-9 = 'workspace 9'
          ctrl-shift-alt-a = 'workspace A' # In your config, you can drop workspace bindings that you don't need
          ctrl-shift-alt-b = 'workspace B'
          ctrl-shift-alt-c = 'workspace C'
          ctrl-shift-alt-d = 'workspace D'
          ctrl-shift-alt-e = 'workspace E'
          ctrl-shift-alt-f = 'workspace F'
          ctrl-shift-alt-g = 'workspace G'
          ctrl-shift-alt-i = 'workspace I'
          ctrl-shift-alt-m = 'workspace M'
          ctrl-shift-alt-n = 'workspace N'
          ctrl-shift-alt-o = 'workspace O'
          ctrl-shift-alt-p = 'workspace P'
          ctrl-shift-alt-q = 'workspace Q'
          ctrl-shift-alt-r = 'workspace R'
          ctrl-shift-alt-s = 'workspace S'
          ctrl-shift-alt-t = 'workspace T'
          ctrl-shift-alt-u = 'workspace U'
          ctrl-shift-alt-v = 'workspace V'
          ctrl-shift-alt-w = 'workspace W'
          ctrl-shift-alt-x = 'workspace X'
          ctrl-shift-alt-y = 'workspace Y'
          ctrl-shift-alt-z = 'workspace Z'

          # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
          ctrl-shift-alt-cmd-1 = 'move-node-to-workspace 1'
          ctrl-shift-alt-cmd-2 = 'move-node-to-workspace 2'
          ctrl-shift-alt-cmd-3 = 'move-node-to-workspace 3'
          ctrl-shift-alt-cmd-4 = 'move-node-to-workspace 4'
          ctrl-shift-alt-cmd-5 = 'move-node-to-workspace 5'
          ctrl-shift-alt-cmd-6 = 'move-node-to-workspace 6'
          ctrl-shift-alt-cmd-7 = 'move-node-to-workspace 7'
          ctrl-shift-alt-cmd-8 = 'move-node-to-workspace 8'
          ctrl-shift-alt-cmd-9 = 'move-node-to-workspace 9'
          ctrl-shift-alt-cmd-a = 'move-node-to-workspace A'
          ctrl-shift-alt-cmd-b = 'move-node-to-workspace B'
          ctrl-shift-alt-cmd-c = 'move-node-to-workspace C'
          ctrl-shift-alt-cmd-d = 'move-node-to-workspace D'
          ctrl-shift-alt-cmd-e = 'move-node-to-workspace E'
          ctrl-shift-alt-cmd-f = 'move-node-to-workspace F'
          ctrl-shift-alt-cmd-g = 'move-node-to-workspace G'
          ctrl-shift-alt-cmd-i = 'move-node-to-workspace I'
          ctrl-shift-alt-cmd-m = 'move-node-to-workspace M'
          ctrl-shift-alt-cmd-n = 'move-node-to-workspace N'
          ctrl-shift-alt-cmd-o = 'move-node-to-workspace O'
          ctrl-shift-alt-cmd-p = 'move-node-to-workspace P'
          ctrl-shift-alt-cmd-q = 'move-node-to-workspace Q'
          ctrl-shift-alt-cmd-r = 'move-node-to-workspace R'
          ctrl-shift-alt-cmd-s = 'move-node-to-workspace S'
          ctrl-shift-alt-cmd-t = 'move-node-to-workspace T'
          ctrl-shift-alt-cmd-u = 'move-node-to-workspace U'
          ctrl-shift-alt-cmd-v = 'move-node-to-workspace V'
          ctrl-shift-alt-cmd-w = 'move-node-to-workspace W'
          ctrl-shift-alt-cmd-x = 'move-node-to-workspace X'
          ctrl-shift-alt-cmd-y = 'move-node-to-workspace Y'
          ctrl-shift-alt-cmd-z = 'move-node-to-workspace Z'

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
          ctrl-shift-alt-tab = 'workspace-back-and-forth'
          # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
          ctrl-shift-alt-cmd-tab = 'move-workspace-to-monitor --wrap-around next'

          # See: https://nikitabobko.github.io/AeroSpace/commands#mode
          ctrl-alt-shift-semicolon = 'mode service'

          # 'service' binding mode declaration.
          # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
          [mode.service.binding]
          esc = ['reload-config', 'mode main']
          r = ['flatten-workspace-tree', 'mode main'] # reset layout
          f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
          backspace = ['close-all-windows-but-current', 'mode main']

          # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
          #s = ['layout sticky tiling', 'mode main']

          ctrl-alt-shift-h = ['join-with left', 'mode main']
          ctrl-alt-shift-j = ['join-with down', 'mode main']
          ctrl-alt-shift-k = ['join-with up', 'mode main']
          ctrl-alt-shift-l = ['join-with right', 'mode main']
        '';
      };

      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      homeDirectory = "/Users/${userName}";

      username = "${userName}";

      # nixpkgs.config.allowUnfree = true;

      # The home.packages option allows you to install Nix packages into your
      # environment.
      packages = with pkgs; [
        # # Adds the 'hello' command to your environment. It prints a friendly
        # # "Hello, world!" when run.
        hello

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        pkgs.nerd-fonts.fantasque-sans-mono
        pkgs.nerd-fonts.fira-code
        pkgs.nerd-fonts.jetbrains-mono

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')

        alacritty
        any-nix-shell
        argocd
        (aspellWithDicts (dicts: with dicts; [ nl en en-computers en-science ]))
        autojump
        azure-cli
        babelfish
        bacon
        # bash # Caused collision. Installed below.
        bat
        # behave
        brave
        cacert
        cargo-cross
        unstable.claude-code
        comma
        cmake
        coreutils
        cowsay
        delve
        # devcontainer # Breaks build.
        diffutils
        discord
        unstable.edit
        exercism
        # emacs # Broken
        fd
        ffmpeg
        fish
        fzf
        fx
        gcc-arm-embedded
        gci
        unstable.gemini-cli
        gh
        gnused
        glab
        # go # Installed in programs below.
        unstable.godef
        unstable.gofumpt
        goku
        unstable.gopkgs
        unstable.gomodifytags
        unstable.gopls
        unstable.gotest
        unstable.gotests
        unstable.gotestsum
        unstable.gotools
        unstable.golangci-lint
        unstable.go-outline
        unstable.go-mockery
        unstable.go-tools
        graphviz
        grpcurl
        home-manager
        htop
        imagemagick
        impl
        inetutils
        inkscape
        istioctl
        joker
        jq
        just
        kind
        kubectl
        kubectx
        kubecolor
        kubelogin
        kubernetes-helm
        languagetool
        libiconv
        libtool
        libxml2
        lima
        lolcat
        lua
        lua-language-server
        mas
        minicom
        natscli
        unstable.neovim
        nmap
        unstable.nodejs_24
        # unstable.ollama # crashes on macos
        openapi-generator-cli
        opencode
        openssl
        openocd
        pdf2svg
        plantuml
        podman
        perl
        pgcli
        pkg-config
        postgresql_16
        probe-rs # 2024-11: probe-rs-tools
        unstable.protobuf
        unstable.protoc-gen-go
        unstable.protolint
        python3
        # racket # not available for host platform.
        readline
        redis
        ripgrep
        unstable.rustup
        unstable.sbcl
        socat
        sops
        spotify
        sqlite
        strongswan
        swi-prolog
        terminal-notifier
        terraform # Non-free.
        terraform-ls
        tflint
        thefuck
        tree-sitter
        ttyd
        # typescript # Broken.
        ugrep
        unison-ucm
        vim
        virtualenv
        watch
        websocat
        wget
        unstable.windsurf
        unstable.wireshark
        xmlsec
        xorg.libXext
        # yarn
        yq-go
        zig
        zola
      ];

      # preferXdgDirectories = true; # Error for unknown reasons.

      # Home Manager can also manage your environment variables through
      # 'home.sessionVariables'. If you don't want to manage your shell through Home
      # Manager then you have to manually source 'hm-session-vars.sh' located at
      # either
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/${userName}/etc/profile.d/hm-session-vars.sh
      #
      sessionVariables = {
        DIRENV_LOG_FORMAT = "";
        EDITOR = "nvim";
        SSH_AUTH_SOCK = authSocket;

        CGO_ENABLED = "0";
        DEVOPS_PAT_TOKEN_NAME = "development";
        DEVOPS_PAT_TOKEN_VALUE = clientToken;
      };

      shellAliases = {
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
      };

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      stateVersion = "23.11"; # Please read the comment before changing.
    };

    programs = {
      alacritty = {
        enable = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      bash.enable = true;

      fish = {
        enable = true;
        shellAliases = {
          fish_title = "prompt_pwd"; # set terminal window title
          zf = "z --pipe=fzf";
          # sudo to prompt immediately.
          darwin-switch = "sudo -v; nix eval ~/.config/nix-darwin; darwin-rebuild switch --flake ~/.config/nix-darwin";
        };
        plugins = with pkgs.fishPlugins; [
          { name = "fzf"; src = fzf-fish.src; } # better than built-in fzf keybinds
        ];
        shellInit = ''
          any-nix-shell fish --info-right | source
          thefuck --alias | source
          fish_add_path /opt/homebrew/bin
        '';
      };
      fzf = {
        enable = true;
        enableFishIntegration = false; # use fzf-fish plugin instead
      };

      git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        userName = "Kas Buunk";
        userEmail = "kasbuunk@${privateDomain}";
        signing.key = gitSigningKey;
        signing.signByDefault = true;
        iniContent.gpg.format = "ssh";
        iniContent.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        iniContent.gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";

        includes = [
          {
            condition = "hasconfig:remote.*.url:git@lab.${companyDomain}**";
            contents = {
              user = {
                email = "kbuunk@${companyDomain}";
              };
            };
          }
          {
            condition = "hasconfig:remote.*.url:git@ssh.dev.azure.com:v3/${clientNamespace}/**";
            contents = {
              user = {
                email = "kas.buunk@${clientDomain}";
              };
            };
          }
          {
            path = "~/.config/git/${clientNamespace}";
          }
        ];

        ignores = [
          ".DS_Store"
          "._*"
          ".ignore"
          ".envrc"
          ".direnv/"
          ".idea"
          ".vscode"
        ];
        extraConfig = {
          pull.rebase = true;
          rebase.autostash = true;
          push.autoSetupRemote = true;
          url = {
            "git@ssh.dev.azure.com:v3/${clientNamespace}/" = {
              insteadOf = "https://dev.azure.com/${clientNamespace}/";
            };
          };
        };
      };

      go = {
        enable = true;
        package = pkgs.staging.go;
        goPrivate = [ "dev.azure.com" ];
      };

      gpg = {
        enable = true;
        homedir = "/Users/${userName}/.config/gnupg";
      };

      # Let home manager install and manage itself.
      home-manager.enable = true;

      ssh = {
        enable = true;
        forwardAgent = true;
        extraOptionOverrides = {
          IdentityAgent = "\"${authSocket}\"";
        };
      };

      tmux = {
        enable = true;
        clock24 = true;
        customPaneNavigationAndResize = true;
        disableConfirmationPrompt = true;
        escapeTime = 0;
        keyMode = "emacs";
        mouse = true;
        newSession = true;
        prefix = "c-a";
        extraConfig = ''
          # Make links clickable.
          set -ga terminal-features "*:hyperlinks"

          # Navigate windows.
          bind -n C-h select-pane -L
          bind -n C-j select-pane -D
          bind -n C-k select-pane -U
          bind -n C-l select-pane -R

          # Termguicolors.
          set -g default-terminal "$TERM"
          set -ag terminal-overrides ",$TERM:Tc"
          set-option -g default-shell /bin/zsh
          set-option -g default-command /bin/zsh
        '';
      };

      zsh = {
        # Configuration options: https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix
        enable = true;
        autosuggestion.enable = true;
        autocd = true;
        dotDir = ".config/zsh";
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
          theme = "robbyrussell";
        };
        shellAliases = {
          k = "kubecolor";
          kns = "kubectl get namespaces";
          vim = "nvim";
          kbash = "kubectl run util-pod-kas --image=nicolaka/netshoot -i --tty --rmenabled = false";
          darwin-switch = "sudo -v; nix eval ~/.config/nix-darwin; darwin-rebuild switch --flake ~/.config/nix-darwin";
        };
        initContent = ''
          echo 'Session initialised with configuration in ~/.config/nix-darwin/'
          # nix
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          fi
          # end nix

          # autojump
          [ -f ~/.nix-profile/etc/profile.d/autojump.sh ] && . ~/.nix-profile/etc/profile.d/autojump.sh

          eval $(thefuck --alias)
          eval "$(direnv hook zsh)" # Not sure what this is; copied from old ~/.zshrc.backup

          # setting for gup command (auto generate)
          fpath=(~/.zsh/completion $fpath)

          autoload -Uz compinit && compinit -i
          autoload -U +X bashcompinit && bashcompinit
          autoload -U edit-command-line

          # define widget function
          function cursor-after-first-word {
              zle up-history
              zle beginning-of-line
              zle forward-word
              rbuffer=" $rbuffer"
          }

          # create widget from function
          zle -N cursor-after-first-word

          # Errors with 'bad option -n'.
          zle -N edit-command-line

          bindkey '^E' edit-command-line                   # Opens Vim to edit current command line
          bindkey '^R' history-incremental-search-backward # Perform backward search in command line history
          bindkey '^S' history-incremental-search-forward  # Perform forward search in command line history
          bindkey '^P' history-search-backward             # Go back/search in history (autocomplete)
          bindkey '^N' history-search-forward              # Go forward/search in history (autocomplete)
          bindkey -v # enable vim mode in zsh.
          bindkey '^[o' cursor-after-first-word # bind widget to esc-o.

          kubectl completion zsh >/tmp/kubecompletion
          source /tmp/kubecompletion
          rm /tmp/kubecompletion
          complete -o default -o nospace -f __start_kubectl k

          compdef kubecolor=kubectl # Ensure kubecolor has kubectl autocomplete.

          complete -o nospace -c /opt/homebrew/bin/terraform terraform

          # ghcup - Haskell
          # Install manually by following the instructions:
          # https://www.haskell.org/ghcup/install/
          # Nix and ghcup don't play well together. The nix ghcup package has been broken for a while
          # and it's necessary for neovim's integration.
          if [ -f ~/.ghcup/env ]; then
            . ~/.ghcup/env
          fi

          export LIBRARY_PATH="${pkgs.libiconv}/lib:$LIBRARY_PATH"
          export LD_LIBRARY_PATH="${pkgs.libiconv}/lib:$LD_LIBRARY_PATH"
        '';
      };
    };

    targets.darwin = {
      defaults = {
        "com.apple.Safari" = {
          AutoFillPasswords = false;
          AutoFillCreditCardData = true;
          IncludeDevelopMenu = true;
          ShowOverlayStatusBar = true;
        };
      };
      search = "Ecosia";
    };


    xdg = {
      enable = true;
      userDirs = {
        documents = "Documents";
        download = "Downloads";
        music = "Music";
        pictures = "Pictures";
      };
    };
  };
}
