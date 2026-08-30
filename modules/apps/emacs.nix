{
  config,
  pkgs,
  lib,
  ...
}: {
  services.emacs = {
    enable = true;
    client.enable = true;
    startWithUserSession = "graphical";
  };

  systemd.user.services.emacs.Service.TimeoutStartSec = "120";

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs:
      with epkgs; [
        # Core & Performance
        use-package
        general
        diminish
        s
        dash
        f
        async
        ht
        hydra
        gcmh

        # Evil Modal Ecosystem
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

        # Editing Utilities
        undo-tree
        smartparens
        aggressive-indent
        expand-region
        ws-butler
        super-save
        string-inflection
        multiple-cursors
        ace-window

        # UI, Themes & Dashboards
        doom-themes
        doom-modeline
        dashboard
        writeroom-mode
        olivetti
        nerd-icons
        nerd-icons-completion
        nerd-icons-dired
        rainbow-delimiters
        highlight-indent-guides
        breadcrumb
        symbols-outline
        origami
        minions
        beacon
        page-break-lines
        indent-bars
        mixed-pitch

        # Completion, Search & Navigation
        vertico
        marginalia
        orderless
        corfu
        consult
        consult-dir
        which-key
        helpful
        wgrep
        flycheck
        consult-flycheck
        smart-jump
        cape
        prescient
        vertico-prescient
        yasnippet
        yasnippet-snippets

        # LSP, Treesitter, Formatting & Debugging
        lsp-mode
        lsp-ui
        treesit-auto
        apheleia
        dape
        format-all

        # File Management & Workspaces
        dired-open
        peep-dired
        eyebrowse
        switch-window
        projectile
        consult-projectile
        ibuffer-projectile
        projectile-ripgrep
        treemacs
        treemacs-evil
        treemacs-nerd-icons
        treemacs-projectile
        treemacs-magit

        # Language Major Modes
        nix-mode
        rust-mode
        go-mode
        elixir-mode
        csharp-mode
        zig-mode
        kotlin-mode
        scala-mode
        haskell-mode
        python-mode

        # Org Mode Infrastructure
        pdf-tools
        org
        org-modern
        org-roam
        org-roam-ui
        org-super-agenda

        # Terminal, devenv and extras
        restclient
        verb
        prodigy
        direnv
        envrc
        vterm
        vterm-toggle
        eat
        emms
        elfeed
        elfeed-org

        # Git Integration (Maxxed Out)
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

        # Tree-sitter Grammars
        (treesit-grammars.with-all-grammars)
      ];
  };

  home.packages = with pkgs; [
    # Formatters & Linters
    alejandra
    black
    shfmt
    rustfmt

    # Toolchains & CLI tools (providing built-in formatters)
    clang-tools
    gcc
    go
    beamPackages.elixir
    zig

    # System & Search Tools
    fd
    jq
    ripgrep
    sqlite
    unzip
    zstd
    texliveFull
    direnv
    just
    poppler_gi

    # Language Servers (LSPs)
    elixir-ls
    zls
    jdt-language-server
    kotlin-language-server
    sqls
    vscode-langservers-extracted
    csharp-ls
    bash-language-server
    nil
    gopls
    rust-analyzer
    pyright
  ];

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    noDisplay = true;
  };

  xdg.configFile = {
    "emacs/init.el".source = ./emacs/init.el;
    "emacs/early-init.el".source = ./emacs/early-init.el;
    "emacs/elfeed.org".source = ./emacs/elfeed.org;
  };
}
