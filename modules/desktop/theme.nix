{pkgs, ...}: {
  # 1. Install theme packages system-wide with explicit Catppuccin variants
  environment.systemPackages = [
    (pkgs.catppuccin-gtk.override {
      accents = ["blue"];
      size = "standard";
      variant = "mocha";
    })
    pkgs.papirus-icon-theme
    pkgs.bibata-cursors
    pkgs.dconf
    pkgs.kdePackages.qt6ct
    pkgs.libsForQt5.qt5ct
  ];

  # 2. Enable Dconf for GTK runtime settings
  programs.dconf.enable = true;

  # 3. Environment Variables (Cleaned up)
  environment.sessionVariables = {
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    NIXOS_OZONE_WL = "1"; # Forces Electron/Chromium apps onto native Wayland
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  # 4. System-wide GTK3 & GTK4 settings
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
      gtk-icon-theme-name=Papirus-Dark
      gtk-cursor-theme-name=Bibata-Modern-Ice
      gtk-font-name=Sans 10
      gtk-application-prefer-dark-theme=1
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
      gtk-icon-theme-name=Papirus-Dark
      gtk-cursor-theme-name=Bibata-Modern-Ice
      gtk-font-name=Sans 10
      gtk-application-prefer-dark-theme=1
    '';
  };

  # 5. Qt Theme Integration
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };
}
