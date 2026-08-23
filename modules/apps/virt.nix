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
  };
}
