{
  description = "NixOS with Hyprland";

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
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }:
  let
    host = import ./nixos/host.nix;
  in
  {
    nixosConfigurations.${host.hostName} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = host;
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${host.userName} = import ./home;
            backupFileExtension = "backup";
            extraSpecialArgs = host;
          };
        }
        disko.nixosModules.disko
      ];
    };
  };
}
