{pkgs, ...}: {
  imports = [
    ./nvf.nix
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
      openjdk25 # For minecraft
      steam-run # For minecraft also
    ];
    xdg.configFile."wezterm".source = ./wezterm;
    xdg.desktopEntries.sklauncher = {
      name = "SKlauncher";
      comment = "Minecraft Launcher";
      exec = "${pkgs.steam-run}/bin/steam-run ${pkgs.openjdk25}/bin/java -jar ${./SKLauncher/SKLauncher.jar}";
      icon = "${./SKLauncher/mc.png}";
      terminal = false;
      categories = ["Game"];
    };
  };
}
