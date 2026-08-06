{pkgs, ...}: {
  # 1. Install theme packages system-wide with explicit Catppuccin variants
  home-manager.users.tahmid = {
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    xdg = {
      configFile = {
        "hypr/hyprland.lua".source = ./hypr/hyprland.lua;
        "hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
        "wezterm".source = ./wezterm;
        "waybar".source = ./waybar;
        "rofi".source = ./rofi;
      };
      desktopEntries = {
        qt5ct = {
          name = "Qt5 Settings";
          noDisplay = true;
        };
        qt6ct = {
          name = "Qt6 Settings";
          noDisplay = true;
        };
      };
    };
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
    gtk = {
      enable = true;
      theme = {
        name = "catppuccin-mocha-blue-standard";
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          size = "standard";
          variant = "mocha";
        };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    home.file."wp.jpg".source = ./wp.jpg;
  };
  environment.systemPackages = with pkgs; [
    (catppuccin-gtk.override {
      accents = ["blue"];
      size = "standard";
      variant = "mocha";
    })
    papirus-icon-theme
    dconf
    kdePackages.qt6ct
    libsForQt5.qt5ct
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
    GTK_THEME = "catppuccin-mocha-blue-standard";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORMTHEME = "gtk2";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  # 5. Qt Theme Integration
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
  };
}
