{
  inputs,
  pkgs,
  ...
}: {
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
    };
  };

  home-manager.users.tahmid = {
    imports = [
      inputs.nixcord.homeModules.nixcord
      ./emacs.nix
    ];

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

    programs.nixcord = {
      enable = true;
      discord.enable = false;
      vesktop.enable = true;
      config.plugins = {
        betterFolders.enable = true;
        fakeNitro.enable = true;
        messageLogger.enable = true;
        noTypingAnimation.enable = true;
        clearUrls.enable = true;
        imageZoom.enable = true;
        fixCodeblockGap.enable = true;
        volumeBooster.enable = true;
        biggerStreamPreview.enable = true;
        betterSettings.enable = true;
        pinDms.enable = true;
        platformIndicators.enable = true;
        memberCount.enable = true;
      };
    };
  };
}
  