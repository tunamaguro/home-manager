{ config, pkgs, pkgsUnstable, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tunamaguro";
  home.homeDirectory = "/home/tunamaguro";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    fd
    ripgrep
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

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "tunamaguro";
        email = "79092292+tunamaguro@users.noreply.github.com";
      };
      init.defaultBranch = "main";

      core = {
        editor = "nvim";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };

    gitCredentialHelper.enable = true;
  };

  programs.tmux = {
    enable = true;

    extraConfig = ''
      set -g default-shell ${pkgs.zsh}/bin/zsh
      source-file ${./tmux/tmux.conf}
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    package = pkgsUnstable.neovim-unwrapped;

    extraPackages = with pkgs; [
      lua-language-server
      nixd
    ];

    plugins = with pkgsUnstable.vimPlugins; [
      # LSP server configs
      nvim-lspconfig

      # completion
      blink-cmp

      # fuzzy finder
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim

      # Indent guideline
      indent-blankline-nvim

      # Git signs / hunk navigation
      gitsigns-nvim

      (nvim-treesitter.withPlugins (p: [
        p.rust
        p.toml
        p.nix
        p.lua
        p.vim
        p.vimdoc
      ]))

      # File explorer
      nvim-tree-lua
      nvim-web-devicons

      # buffer/tab 
      bufferline-nvim
      mini-bufremove

      # keymap support
      which-key-nvim

      # pair util
      nvim-autopairs
      nvim-surround

      # color schema
      nightfox-nvim
    ];
  };
  xdg.configFile."nvim".source = ./nvim;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit

      mkdir -p "${config.xdg.cacheHome}/zsh"

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

      compinit -d "${config.xdg.cacheHome}/zsh/zcompdump"
    '';

    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      package.disabled = true;

      git_branch = {
        symbol = "git:";
      };

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
        vimcmd_symbol = "[<](bold green)";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #  /etc/profiles/per-user/tunamaguro/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
