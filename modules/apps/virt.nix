{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
      };
    };
    waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
  };
  programs.virt-manager.enable = true;

  home-manager.users.tahmid = {
    home.packages = with pkgs; [
      qemu
      virt-manager
      kdePackages.kio-admin
    ];
    xdg.desktopEntries.waydroid-ui = {
      name = "Waydroid UI";
      genericName = "Emulators";
      comment = "Waydroid emulator for android";
      exec = "waydroid show-full-ui";
      icon = "waydroid";
      terminal = false;
      categories = ["Utility" "Emulator"];
    };
  };
}
