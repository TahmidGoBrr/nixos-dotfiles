{pkgs, ...}: {
  # 1. Essential X11 utilities and tools (replacing xinitrc CLI apps)
  environment.systemPackages = with pkgs; [
    # Core Xorg tools
    xauth # Authentication for xserver
    xrandr # Screen resolution & multi-monitor setup
    xset # DPMS / screen timeout settings
    xsetroot # Sets root window cursor / background

    # Utilities
    xclip # Command-line clipboard interface
    xdotool # Window automation tool
    feh # Lightweight image viewer / wallpaper setter
    maim # Screenshot utility
    slock # Simple suckless screen locker
    brightnessctl # Backlight control
    kdePackages.polkit-kde-agent-1 # Authentication for apps
  ];

  # 2. Replaces ~/.xinitrc startup commands
  services.xserver.displayManager.sessionCommands = ''
    # Load X resources (fonts, colors, DPI)
    if [ -f "$HOME/.Xresources" ]; then
      ${pkgs.xrdb}/bin/xrdb -merge "$HOME/.Xresources"
    fi

    # Display settings & power management
    ${pkgs.xrandr}/bin/xrandr --auto
    ${pkgs.xset}/bin/xset s off
    ${pkgs.xset}/bin/xset r rate 200 35
    ${pkgs.xset}/bin/xset -dpms
    ${pkgs.xsetroot}/bin/xsetroot -cursor_name left_ptr

    # Polkit Authentication Agent (KDE Plasma 6)
    ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 &

    # Set Wallpaper (Fallback to solid color if no image found)
    if [ -f "$HOME/.dotfiles/modules/desktop/wp.jpg" ]; then
      ${pkgs.feh}/bin/feh --bg-fill "$HOME/.dotfiles/modules/desktop/wp.jpg" &
    else
      ${pkgs.xsetroot}/bin/xsetroot -solid "#282828"
    fi
  '';
  # 3. Picom (X11 Compositor for transparency & shadows)
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    # Transparency rule examples
    activeOpacity = 1.0;
    inactiveOpacity = 1.0;

    settings = {
      corner-radius = 0;
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
    };
  };
}
