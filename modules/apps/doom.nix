{
  pkgs,
  inputs,
  ...
}: {
  # Enable Systemd Daemon for Emacs Client/Daemon mode
  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
  };
  # Declarative, Reproducible Doom Emacs
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom; # Points to your local doom/ directory containing init.el, config.el, packages.el
    emacs = pkgs.emacs-pgtk;
  };

  # Complete Developer System Binaries & Formatters
  home.packages = with pkgs; [
    # System Fonts
    nerd-fonts.symbols-only
    nerd-fonts.iosevka

    # Formatters
    alejandra
    black
    prettier
    shfmt

    # Core Compilers, Tools & Dependencies
    beamPackages.elixir
    ripgrep
    fd
    libvterm
    cmake
    gnumake
    gcc
    zstd
    jq
    wget
    unzip
    lldb
    nodejs
    sqlite

    # Language Servers
    nil
    pyright
    rust-analyzer
    gopls
    typescript-language-server
    vscode-langservers-extracted
    terraform-ls
    python3Packages.debugpy
  ];

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    noDisplay = true;
  };
}
