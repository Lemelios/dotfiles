{
  description = "Config de Lemelios MrdL";

  inputs = {
		unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		stable.url  = "github:NixOS/nixpkgs/26.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "stable";
		};
		pixie-sddm.url = "github:xCaptaiN09/pixie-sddm";
		minegrub-world-sel-theme = {
			url = "github:Lxtharia/minegrub-world-sel-theme";
			inputs.nixpkgs.follows = "stable";
		};
		areofyl-fetch.url = "github:areofyl/fetch";
		lazyvim.url = "github:pfassina/lazyvim-nix";
  };

  outputs = { self, unstable, stable, home-manager, ... }@inputs:
	let
		system = "x86_64-linux";
		pkgs-unstable = import unstable { inherit system; config.allowUnfree = true; };
	in {
		nixosConfigurations = {
			current = stable.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs pkgs-unstable system; };
				modules = [ 
					./hosts/current/configuration.nix 
					home-manager.nixosModules.home-manager
					inputs.minegrub-world-sel-theme.nixosModules.default
				];
			}; 
			homelab = stable.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs pkgs-unstable; };
				modules = [
					./hosts/homelab/configuration.nix
					home-manager.nixosModules.home-manager
				];
			};
		};
  };
}
