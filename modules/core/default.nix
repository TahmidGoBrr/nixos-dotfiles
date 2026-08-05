{pkgs, ...}: {
  imports = [./fonts.nix ./shell.nix];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };
  boot.supportedFilesystems = ["ntfs"];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 100;
    memoryMax = 8 * 1024 * 1024 * 1024;
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.libinput.enable = true;

  security.pam.services.hyprlock = {};
  environment.systemPackages = with pkgs; [
    wget
    git
    gh
    xfsprogs
    btrfs-progs
    jq
    udiskie
    ntfs3g
    android-tools
  ];
}
