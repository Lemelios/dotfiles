{
  description = "Config de Lemelios MrdL";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		current.url  = "github:NixOS/nixpkgs/26.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "current";
		};
		pixie-sddm.url = "github:xCaptaiN09/pixie-sddm";
		minegrub-world-sel-theme = {
			url = "github:Lxtharia/minegrub-world-sel-theme";
			inputs.nixpkgs.follows = "current";
		};
  };

  outputs = { self, unstable, current, home-manager, ... }@inputs:
	let
		system = "x86_64-linux";
		pkgs-unstable = import unstable { inherit system; config.allowUnfree = true; };
	in {
		nixosConfigurations = {
			current = current.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs pkgs-unstable; };
				modules = [ 
					./hosts/current/configuration.nix 
					home-manager.nixosModules.home-manager
					inputs.minegrub-world-sel-theme.nixosModules.default
				];
			}; 
			/* server = current.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs pkgs-unstable; };
				modules = [
					./hosts/server/configuration.nix
					home-manager.nixosModules.home-manager
				];
			};*/
		};
  };
}
