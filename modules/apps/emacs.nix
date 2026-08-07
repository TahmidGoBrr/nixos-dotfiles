{pkgs, ...}: {
  # 1. Enable Emacs with dynamic package derivations built from ELPA/MELPA
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk; # Native compilation + modern GTK GUI
    extraPackages = epkgs:
      with epkgs; [
        use-package
        catppuccin-theme
        doom-modeline
        nerd-icons
        rainbow-delimiters
        rainbow-mode
        highlight-indent-guides
        evil
        evil-collection
        evil-surround
        which-key
        general
        vertico
        orderless
        corfu
        avy
        apheleia
        nix-mode
        markdown-mode
        elixir-mode
        rust-mode
        zig-mode
        magit
        diff-hl
        hl-todo
        wgrep

        # Treesitter grammars
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

  # 2. Add language tools/formatters to user environment (matching your NVF formatters)
  home.packages = with pkgs; [
    alejandra # Nix formatter
    black # Python formatter
    nodePackages.prettier # JS/TS formatter
    beamPackages.elixir
    ripgrep # Fast search (Telescope/wgrep backend)
  ];

  # 3. Declaratively place init.el into target dotfile directory
  home.file.".config/emacs/init.el".source = ./emacs/init.el;
}
