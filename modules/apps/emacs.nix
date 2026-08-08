{pkgs, ...}: {
  # 1. Enable background Emacs user service
  services.emacs = {
    enable = true;
    client.enable = true;
  };

  # 2. Main Emacs package declaration with native compilation & dynamic packages
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk; # Native compilation + modern GTK/Wayland GUI
    extraPackages = epkgs:
      with epkgs; [
        # Core & Macro Frameworks
        use-package
        general
        diminish

        # Evil / Vim Emulation
        evil
        evil-collection
        evil-surround

        # UI Visuals & Themes
        catppuccin-theme
        doom-modeline
        dashboard
        nerd-icons
        rainbow-delimiters
        rainbow-mode
        highlight-indent-guides

        # Completion & Navigation Stack (Telescope / Snacks.nvim equivalent)
        vertico
        marginalia
        orderless
        corfu
        consult
        consult-dir
        embark
        embark-consult
        avy
        which-key

        # File Tree & Buffer Management
        bufler
        treemacs
        treemacs-evil
        treemacs-nerd-icons

        # Terminal & Code Tools
        vterm
        vterm-toggle
        project
        apheleia

        # Language Modes
        nix-mode
        markdown-mode
        elixir-mode
        rust-mode
        zig-mode
        typst-ts-mode

        # Git & Search Tools
        magit
        diff-hl
        hl-todo
        wgrep

        # Treesitter Grammars
        (treesit-grammars.with-grammars (p: [
          p.tree-sitter-bash
          p.tree-sitter-c
          p.tree-sitter-cpp
          p.tree-sitter-elixir
          p.tree-sitter-go
          p.tree-sitter-json
          p.tree-sitter-javascript
          p.tree-sitter-nix
          p.tree-sitter-python
          p.tree-sitter-rust
          p.tree-sitter-typescript
          p.tree-sitter-typst
          p.tree-sitter-yaml
        ]))
      ];
  };

  # 3. Native system binaries, LSP servers, and code formatters
  home.packages = with pkgs; [
    # Searching & Terminal Compilation Backends
    ripgrep
    fd
    libvterm
    cmake
    gnumake
    gcc
    zstd

    # Language Servers (LSP Backends for Eglot)
    nil # Nix LSP
    pyright # Python LSP
    rust-analyzer # Rust LSP
    gopls # Go LSP
    typescript-language-server # JS/TS LSP
    vscode-langservers-extracted # HTML/CSS/JSON LSP

    # Code Formatters (Backends for Apheleia)
    alejandra # Nix Formatter
    black # Python Formatter
    prettier # JS/TS/HTML/JSON Formatter
    beamPackages.elixir
  ];

  # 4. Hide the default standalone launcher
  xdg.desktopEntries.emacs = {
    name = "Emacs";
    noDisplay = true;
  };

  # 5. Symlink init.el configuration file
  home.file.".config/emacs/init.el".source = ./emacs/init.el;
}
