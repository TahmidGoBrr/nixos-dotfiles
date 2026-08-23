{
  pkgs,
  config,
  ...
}: {
  # ---------------------------------------------------------------------------
  # System-Level Setup
  # Required on NixOS for vendor shell completions and environment paths
  # ---------------------------------------------------------------------------
  programs.zsh.enable = true;
  users.users.tahmid.shell = pkgs.zsh;

  # Modern CLI utilities available system-wide
  environment.systemPackages = with pkgs; [
    eza # Modern replacement for 'ls'
    bat # Modern replacement for 'cat' with syntax highlighting
    ripgrep # Ultra-fast grep replacement
    fd # User-friendly alternative to 'find'
  ];

  # ---------------------------------------------------------------------------
  # Home Manager User Configuration
  # ---------------------------------------------------------------------------
  home-manager.users.tahmid = {
    pkgs,
    config,
    ...
  }: {
    # 1. Starship Prompt: Blazing-fast cross-shell prompt written in Rust
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
      };
    };

    # 2. Zoxide: Smart directory jumping ('z path' replaces 'cd')
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # 3. FZF: Fuzzy finder integration (Ctrl+R history, Ctrl+T file finder)
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
    };

    # 4. Direnv: Instant per-directory Nix environment loading
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    # 5. Core Zsh Setup
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # History persistence & deduplication
      history = {
        size = 100000;
        save = 100000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        share = true;
      };

      # QoL Shell Aliases
      shellAliases = {
        # Modern file listings with git status & icons
        ls = "eza --icons";
        ll = "eza -lh --icons --git";
        la = "eza -lah --icons --git";
        tree = "eza --tree --icons";

        # Better file reading & searching
        cat = "bat --paging=never";
        grep = "rg";

        # Quick NixOS maintenance shortcuts
        rebuild = "sudo nixos-rebuild switch --flake .dotfiles#taichi";
        nix-clean = "sudo nix-collect-garbage -d";

        # Emacs restart
        restart-emacs = "systemctl --user restart emacs";
      };

      # Interactive Fuzzy Tab Completion
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];

      # Shell behavior tweaks
      initContent = ''
        # Auto-change directory just by typing the path
        setopt AUTO_CD

        # Case-insensitive tab completion
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

        # Colorize completions
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      '';
    };
  };
}
