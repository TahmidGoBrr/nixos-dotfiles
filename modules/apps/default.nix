{pkgs, ...}: {
  imports = [
    #./nvf.nix
    ./virt.nix
  ];

  networking = {
    networkmanager.enable = true;
    nftables.enable = false;
    firewall = {
      allowedTCPPorts = [53317];
      allowedUDPPorts = [53317];
      trustedInterfaces = ["waydroid0"];
    };
  };

  home-manager.users.tahmid = {
    home.packages = with pkgs; [
      librewolf # Browser
      wezterm # Main terminal
      kdePackages.dolphin # File manager
      yazi # Terminal file manager
      localsend # Wireless file transfer
      motrix # Download manager
      btop # Task manager
      vlc # Audio & Video player
      fastfetch # Fetch
    ];
    xdg.configFile."wezterm".source = ./wezterm;
  };
}
