{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable the Emacs daemon and client
  services.emacs = {
    enable = true;
    client.enable = true;
    startWithUserSession = "graphical";
  };

  # Override the systemd service timeout separately
  systemd.user.services.emacs = {
    Service.TimeoutStartSec = "120";
  };

  # Core Emacs Program Configuration
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk; # Pure GTK for Wayland/Hyprland native performance
    extraPackages = epkgs:
      with epkgs; [
        # Core Extensions
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

        # Evil Framework
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

        # UI & Themes
        doom-themes
        doom-modeline
        dashboard
        nerd-icons
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
        minimap

        # Completion & Navigation
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
        flycheck
        consult-flycheck
        smart-jump
        cape
        prescient
        vertico-prescient
        consult-eglot
        yasnippet
        yasnippet-snippets

        # LSP & Treesitter
        lsp-mode
        lsp-ui
        treesit-auto

        # Workspaces & Files
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

        # Terminal & Refactoring
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

        # Languages
        lua-mode
        nix-mode
        yaml-mode
        markdown-mode
        rust-mode
        go-mode
        typescript-mode
        elixir-mode
        terraform-mode

        # Docs & Org OS Features
        pdf-tools
        devdocs
        zeal-at-point
        org-roam
        org-roam-ui
        org-super-agenda
        calfw
        calfw-org

        # IDE Features
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

        # Emacs OS Apps (Email, Chat, Media, RSS, Passwords, Torrents)
        ement
        emms
        elfeed
        mu4e
        mu4e-alert
        password-store
        transmission
        erc-hl-nicks

        # Git
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
        (treesit-grammars.with-all-grammars)
      ];
  };

  # Complete Developer System Binaries, Fonts & Formatters
  home.packages = with pkgs; [
    nerd-fonts.iosevka
    alejandra
    black
    prettier
    shfmt
    beamPackages.elixir
    clang-tools
    cmake
    fd
    gcc
    ghostscript
    gnumake
    gopls
    jq
    libvterm
    lldb
    nil
    nodejs
    poppler_gi
    pyright
    python3Packages.debugpy
    ripgrep
    rust-analyzer
    sqlite
    terraform-ls
    typescript-language-server
    unzip
    vscode-langservers-extracted
    zstd
    direnv
    docker
    just
    k9s
    kubectl
    mycli
    pgcli
    zeal
    pass

    # OS App Dependencies
    mu # Required for mu4e email indexing
    isync # Recommended for pulling IMAP email
    mpv # Required for EMMS music playback
  ];

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    noDisplay = true;
  };

  # Symlink configuration files
  xdg.configFile = {
    "emacs/init.el".source = ./emacs/init.el;
    "emacs/early-init.el".source = ./emacs/early-init.el;
  };
}
