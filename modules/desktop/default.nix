{pkgs, ...}: {
  imports = [./theme.nix];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.ly.enable = true;
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Sans 10";
        corner_radius = 0;
        frame_width = 2;
        frame_color = "#89b4fa"; # Catppuccin Mocha Blue
      };
      urgency_low = {
        background = "#1e1e2e"; # Base
        foreground = "#cdd6f4"; # Text
        timeout = 5;
      };
      urgency_normal = {
        background = "#1e1e2e"; # Base
        foreground = "#cdd6f4"; # Text
        timeout = 10;
      };
      urgency_critical = {
        background = "#1e1e2e"; # Base
        foreground = "#f38ba8"; # Red
        frame_color = "#f38ba8"; # Red
        timeout = 0;
      };
    };
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["gtk"];
  };

  home-manager.users.tahmid = {pkgs, ...}: {
    home.packages = with pkgs; [
      rofi
      waybar
      hyprpaper
      hyprshot
      pamixer
      pavucontrol
      networkmanagerapplet
      brightnessctl
    ];
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            path = "./wp.jpg";
            blur_passes = 2;
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -20";
            dots_center = true;
            fade_on_empty = false;
          }
        ];
      };
    };
  };
}
