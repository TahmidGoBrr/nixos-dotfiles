{pkgs, ...}: {
  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs:
      with epkgs; [
        # Core Extensions & Evil Framework
        use-package
        general
        diminish
        s
        dash
        f
        async
        ht
        parsebib
        hydra
        evil
        evil-collection
        evil-surround
        evil-nerd-commenter
        evil-goggles
        evil-matchit
        evil-anzu
        evil-snipe
        evil-exchange
        evil-indent-plus
        evil-smartparens
        evil-args
        evil-commentary
        evil-easymotion
        evil-mc
        evil-multiedit

        # UI, Aesthetics, & Status Chrome
        catppuccin-theme
        doom-themes
        doom-modeline
        dashboard
        nerd-icons
        rainbow-delimiters
        highlight-indent-guides
        breadcrumb
        symbols-outline
        origami
        centaur-tabs
        minions
        beacon
        page-break-lines
        spacious-padding
        indent-bars
        solaire-mode
        mixed-pitch
        telephone-line
        nyan-mode
        minimap

        # Completion, Search, Navigation & Action Menu
        vertico
        marginalia
        orderless
        corfu
        company
        consult
        consult-dir
        embark
        embark-consult
        avy
        which-key
        helpful
        imenu-list
        wgrep
        ace-window
        consult-flycheck
        smart-jump
        cape
        prescient
        vertico-prescient
        consult-eglot
        yasnippet
        yasnippet-snippets

        # LSP & Tree-sitter Highlighting
        lsp-mode
        lsp-ui
        treesit-auto

        # Workspaces, Project Tracking & File Explorer
        projectile
        consult-projectile
        bufler
        treemacs
        treemacs-evil
        treemacs-nerd-icons
        multiple-cursors
        dired-sidebar
        dired-open
        eyebrowse
        window-numbering
        switch-window
        persp-mode
        ibuffer-projectile
        projectile-ripgrep
        treemacs-projectile
        treemacs-magit

        # Terminal, Formatter, DAP Debuggers & Refactoring Tools
        vterm
        vterm-toggle
        project
        apheleia
        dape
        undo-tree
        popper
        smartparens
        aggressive-indent
        expand-region
        iedit
        ws-butler
        super-save
        emmet-mode
        format-all
        crux
        string-inflection

        # Major Language Modes
        lua-mode
        nix-mode
        yaml-mode
        markdown-mode
        rust-mode
        go-mode
        typescript-mode

        # Developer Docs, Notes & AI Code Assistance
        pdf-tools
        gptel
        copilot
        ellama
        aider
        devdocs
        zeal-at-point
        org-roam
        org-roam-ui

        # Advanced IDE Features
        restclient
        verb
        docker
        dockerfile-mode
        kubernetes
        k8s-mode
        prodigy
        vlf
        nhexl-mode
        crdt
        direnv
        envrc
        ejc-sql
        edbi
        just-mode

        # Git Integration
        magit
        forge
        blamer
        diff-hl
        hl-todo
        git-timemachine
        git-gutter
        git-gutter-fringe
        magit-todos
        diffview

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
          p.tree-sitter-html
          p.tree-sitter-css
          p.tree-sitter-dockerfile
          p.tree-sitter-markdown
          p.tree-sitter-ruby
          p.tree-sitter-java
          p.tree-sitter-php
          p.tree-sitter-scala
          p.tree-sitter-haskell
          p.tree-sitter-c-sharp
          p.tree-sitter-lua
          p.tree-sitter-julia
          p.tree-sitter-ocaml
          p.tree-sitter-kotlin
          p.tree-sitter-swift
          p.tree-sitter-sql
          p.tree-sitter-jsonnet
        ]))
      ];
  };

  # Complete Developer System Binaries, Fonts & Formatters
  home.packages = with pkgs; [
    # Formatters (NVF Parity)
    alejandra
    black
    prettier
    shfmt

    # Compilers, Tools & LSPs
    beamPackages.elixir
    clang-tools
    ripgrep
    fd
    libvterm
    cmake
    gnumake
    gcc
    zstd
    jq
    unzip
    nil
    pyright
    rust-analyzer
    gopls
    typescript-language-server
    vscode-langservers-extracted
    lldb
    python3Packages.debugpy
    terraform-ls
    nodejs

    ollama
    sqlite
    poppler_gi
    ghostscript

    # Advanced IDE External Dependencies
    docker
    kubectl
    k9s
    direnv
    just
    zeal
    pgcli
    mycli
  ];

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    noDisplay = true;
  };

  # Symlink init.el configuration file
  xdg.configFile."emacs/init.el".source = ./emacs/init.el;
}
