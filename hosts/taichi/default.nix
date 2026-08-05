{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/desktop
    ../../modules/apps
  ];

  networking.hostName = "taichi";
  time.timeZone = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";

  # Define the user blueprint
  users.users.tahmid = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd"];
  };

  # Direct Home Manager wiring inside the host definition
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "backup";
    users.tahmid = {
      home.username = "tahmid";
      home.homeDirectory = "/home/tahmid";
      home.stateVersion = "26.05";
    };
  };

  system.stateVersion = "25.11";
}
