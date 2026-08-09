{pkgs, ...}: {
  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  # System Binaries, Fonts, Formatters & LSPs
  home.packages = with pkgs; [
    # System Fonts
    nerd-fonts.symbols-only
    nerd-fonts.iosevka

    # Formatters (NVF Parity)
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
    unzip
    lldb
    nodejs
    sqlite

    # Language Servers for Eglot/Doom LSP
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

  # Symlink Doom configuration folder
  xdg.configFile."doom".source = ./doom;
}
