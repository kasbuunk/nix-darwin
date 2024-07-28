{ config, pkgs, lib, inputs, ... }:
let
  authSocket = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  gitSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2GefXvl1Vbp8i2uRVi/CGl5PtUPE+ByE4pc8dvECbd";
  userName = "";
  privateDomain = "";
  companyDomain = "";
  clientDomain = "";
  clientNamespace = "";
  clientToken = "";
in
{
  # Complete configuration options:
  # https://nix-community.github.io/home-manager/options.xhtml

  manual.manpages.enable = true;

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
      ".config/git/${clientNamespace}".text = ''
        [url "git@ssh.dev.azure.com:v3/${clientNamespace}/"]
          insteadOf = https://dev.azure.com/${clientNamespace}/
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
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

      alacritty
      any-nix-shell
      (aspellWithDicts (dicts: with dicts; [ nl en en-computers en-science ]))
      autojump
      babelfish
      # bash # Caused collision. Installed below.
      bat
      cacert
      clang
      comma
      cmake
      coreutils
      cowsay
      delve
      diffutils
      docker
      # unstable.emacs29-macport # Collides with programs.emacs.
      fd
      fish
      fzf
      fx
      gci
      unstable.ghc
      gnused
      glab
      # go # Installed in programs below.
      godef
      gofumpt
      gopkgs
      gomodifytags
      gopls
      gotest
      gotests
      gotestsum
      gotools
      golangci-lint
      go-outline
      go-mockery
      go-tools
      graphviz
      grpcurl
      home-manager
      unstable.haskellPackages.cabal-install
      unstable.stack
      htop
      imagemagick
      impl
      inetutils
      inkscape
      istioctl
      jq
      kind
      kubectl
      kubectx
      kubecolor
      kubernetes-helm
      languagetool
      libtool
      libxml2
      lolcat
      lua
      lua-language-server
      natscli
      unstable.neovim
      nmap
      nodejs_22
      openssl
      plantuml
      pdf2svg
      perl
      pgcli
      pkg-config
      postgresql_16
      unstable.protobuf_27
      unstable.protoc-gen-go
      python3
      readline
      ripgrep
      rustup
      unstable.sbcl
      sops
      sqlite
      strongswan
      swiProlog
      terminal-notifier
      terraform # Non-free.
      terraform-ls
      texlive.combined.scheme-full
      tflint
      thefuck
      tree-sitter
      ttyd
      typescript
      ugrep
      vim
      virtualenv
      watch
      wget
      xmlsec
      xorg.libXext
      yarn
      yq-go
      zig
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

    emacs = {
      enable = true;
      package = pkgs.unstable.emacs29-macport;
    };

    fish = {
      enable = true;
      shellAliases = {
        fish_title = "prompt_pwd"; # set terminal window title
        zf = "z --pipe=fzf";
        darwin-switch = "darwin-rebuild switch --flake ~/.config/nix-darwin";
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
      };
    };

    go = {
      enable = true;
      package = pkgs.unstable.go;
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
        firebird = "docker exec -it firebird /bin/bash -c \"/opt/connect_database.sh\"";
        k = "kubecolor";
        kns = "kubectl get namespaces";
        vim = "nvim";
        kbash = "kubectl run util-pod-kas --image=nicolaka/netshoot -i --tty --rmenabled = false";
        darwin-switch = "darwin-rebuild switch --flake ~/.config/nix-darwin";
      };
      initExtra = ''
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
      '';
    };
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
}
