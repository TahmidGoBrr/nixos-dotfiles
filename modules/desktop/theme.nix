{pkgs, ...}: {
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
        "waybar".source = ./waybar;
        "rofi".source = ./rofi;

        # Direct GTK 4 CSS Injection (Fixes Libadwaita & GTK4 Apps)
        "gtk-4.0/gtk.css".text = ''
          @define-color window_bg_color #16181a;
          @define-color window_fg_color #d3d7dc;
          @define-color view_bg_color #1e2124;
          @define-color view_fg_color #d3d7dc;
          @define-color headerbar_bg_color #16181a;
          @define-color headerbar_fg_color #d3d7dc;
          @define-color headerbar_border_color #282c30;
          @define-color card_bg_color #1e2124;
          @define-color card_fg_color #d3d7dc;
          @define-color popover_bg_color #16181a;
          @define-color popover_fg_color #d3d7dc;
          @define-color dialog_bg_color #16181a;
          @define-color dialog_fg_color #d3d7dc;
          @define-color border_color #282c30;
          @define-color accent_color #8f99a3;
          @define-color accent_bg_color #282c30;
          @define-color accent_fg_color #ffffff;
        '';

        # Direct GTK 3 CSS Injection
        "gtk-3.0/gtk.css".text = ''
          @define-color theme_bg_color #16181a;
          @define-color theme_fg_color #d3d7dc;
          @define-color theme_base_color #1e2124;
          @define-color theme_text_color #d3d7dc;
          @define-color theme_selected_bg_color #282c30;
          @define-color theme_selected_fg_color #ffffff;
          @define-color border_color #282c30;

          window, .background {
            background-color: #16181a;
            color: #d3d7dc;
          }
        '';
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

    # Force dark scheme via Home Manager GTK configuration
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
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

    # Set Dconf settings to enforce dark mode across GNOME/GTK runtime portals
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Papirus-Dark";
        cursor-theme = "Bibata-Modern-Ice";
      };
    };

    home.file."wp.jpg".source = ./wp.jpg;
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3
    papirus-icon-theme
    dconf
    kdePackages.qt6ct
    libsForQt5.qt5ct
    glib # provides gsettings
  ];

  programs.dconf.enable = true;

  # Clean, functional Wayland / GTK Session Variables
  environment.sessionVariables = {
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORMTHEME = "gtk2";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    ADW_DISABLE_PORTAL = "0";
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
  };
}
