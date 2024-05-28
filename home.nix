{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kasbuunk";
  home.homeDirectory = "/Users/kasbuunk";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
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
    autojump
    babelfish
    bash
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
    emacs
    fd
    fish
    fzf
    fx
    gci
    git
    gnused
    glab
    go
    gofumpt
    gopkgs
    gomodifytags
    gopls
    gotest
    gotests
    gotools
    golangci-lint
    go-outline
    go-mockery
    go-tools
    grpcurl
    htop
    impl
    inetutils
    istioctl
    jq
    kind
    kubectl
    kubectx
    kubecolor
    kubernetes-helm
    # libgcc # Causes error.
    libtool
    # libvterm # Unsupported on apple-darwin
    libxml2
    lolcat
    lua
    lua-language-server
    natscli
    neovim
    nmap
    nodejs_21
    openssl # Causes error
    perl
    pgcli
    pkg-config
    postgresql_16
    python3
    readline
    ripgrep
    rustup
    sbcl
    sqlite
    swiProlog
    terminal-notifier
    terraform # Needs configuration to allow non-free package.
    terraform-ls
    tflint
    thefuck
    tmux
    tree-sitter
    ttyd
    typescript
    ugrep
    vim
    watch
    wget
    xmlsec
    xorg.libXext
    yarn
    yq-go
    zig
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
  #  /etc/profiles/per-user/kasbuunk/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs";

    # Weave-specific
    WEAVE_CLUSTER_USER = "kas";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    DIRENV_LOG_FORMAT = "";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.alacritty.enable = true;
  programs.bash.enable = true;
  programs.zsh = {
    # Configuration options: https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
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

      # Weave-specific.
      psql_tsg_staging = "__psql_tsg staging";
      psql_tsg_prod = "__psql_tsg prod";
      tsg_proxy_prod = "cloud_sql_proxy -instances=thesharinggroup:europe-west4:postgres-instance-prod=tcp:2345";
      tsg_proxy_staging = "cloud_sql_proxy -instances=thesharinggroup:europe-west4:postgres-instance-staging-6=tcp:3456";
      tsg_proxy_dev = "kubectl port-forward svc/postgres 5433:5432";
    };
    initExtra = ''
      echo 'This zsh session was initialised with configuration in ~/.home-manager/home.nix'
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      # Autojump
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
          RBUFFER=" $RBUFFER"
      }

      # create widget from function
      zle -N cursor-after-first-word

      zle -N edit-command-line
      bindkey '^E' edit-command-line                   # Opens Vim to edit current command line
      bindkey '^R' history-incremental-search-backward # Perform backward search in command line history
      bindkey '^S' history-incremental-search-forward  # Perform forward search in command line history
      bindkey '^P' history-search-backward             # Go back/search in history (autocomplete)
      bindkey '^N' history-search-forward              # Go forward/search in history (autocomplete)
      bindkey -v # Enable Vim mode in ZSH.
      bindkey '^[o' cursor-after-first-word # bind widget to ESC-o.

      kubectl completion zsh >/tmp/kubecompletion
      source /tmp/kubecompletion
      rm /tmp/kubecompletion
      complete -o default -o nospace -F __start_kubectl k

      compdef kubecolor=kubectl # Ensure kubecolor has kubectl autocomplete.

      complete -o nospace -C /opt/homebrew/bin/terraform terraform
    '';
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      fish_title = "prompt_pwd"; # set terminal window title
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
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
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # use fzf-fish plugin instead
  };

  # error upon installation
  # programs.firefox.enable = true;
}
