{
  description = "NixOS with Mango";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, mango, ... }: {
    nixosConfigurations.space = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.huzch = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
        disko.nixosModules.disko
        mango.nixosModules.mango {
          programs.mango.enable = true;
        }
      ];
    };
  };
}