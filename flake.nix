{
  description = "NixOS btw";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:FlameFlag/nixcord";
    nvf.url = "github:notashelf/nvf";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-doom-emacs-unstraightened,
    ...
  } @ inputs: {
    nixosConfigurations.taichi = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/taichi
        inputs.nvf.nixosModules.default # NixOS module works at top level
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};

          # Move all Home Manager modules inside here!
          home-manager.users.tahmid = {
            imports = [
              inputs.nixcord.homeModules.nixcord
              inputs.nix-doom-emacs-unstraightened.hmModule
            ];
          };
        }
      ];
    };
  };
}
