{
  inputs,
  pkgs,
  ...
}: {
  imports = [./nvf.nix ./virt.nix];

  networking = {
    networkmanager.enable = true;
    nftables.enable = false;
    firewall = {
      allowedTCPPorts = [53317];
      allowedUDPPorts = [53317];
    };
  };

  home-manager.users.tahmid = {
    imports = [inputs.nixcord.homeModules.nixcord];

    home.packages = with pkgs; [
      inputs.helium.packages.x86_64-linux.default # Browser
      wezterm # Main terminal
      kdePackages.dolphin # File manager
      yazi # Terminal file manager
      localsend # Wireless file transfer
      motrix # Download manager
      btop # Task manager
      vlc # Audio & Video player
      spotify # Spotify song player
      nitch # Minimal fetch
      fastfetch # Full-fledged fetch
      cmatrix # Larp cli command
    ];

    programs.nixcord = {
      enable = true;
      discord.enable = true;
      discord.vencord.enable = true;
      config.plugins = {
        betterFolders.enable = true;
        fakeNitro.enable = true;
        messageLogger.enable = true;
      };
    };
  };
}
