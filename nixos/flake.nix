{
  description = "Config de Lemelios MrdL";

  inputs = {
		unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		stable.url  = "github:NixOS/nixpkgs/26.05";
		flake-utils.url = "github:numtide/flake-utils";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "stable";
		};
		pixie-sddm = {
			url = "github:xCaptaiN09/pixie-sddm";
			inputs.nixpkgs.follows = "stable";
			inputs.flake-utils.follows = "flake-utils";
		};
		minegrub-world-sel-theme = {
			url = "github:Lxtharia/minegrub-world-sel-theme";
			inputs.nixpkgs.follows = "stable";
		};
		areofyl-fetch = {
			url = "github:areofyl/fetch";
			inputs.nixpkgs.follows = "stable";
		};
		lazyvim = {
			url = "github:pfassina/lazyvim-nix";
			inputs.nixpkgs.follows = "stable";
			inputs.flake-utils.follows = "flake-utils";
		};
  };

  outputs = { self, unstable, stable, ... }@inputs:
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
					inputs.home-manager.nixosModules.home-manager
					inputs.minegrub-world-sel-theme.nixosModules.default
				];
			}; 
			homelab = stable.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs pkgs-unstable; };
				modules = [
					./hosts/homelab/configuration.nix
					inputs.home-manager.nixosModules.home-manager
				];
			};
		};
		devShells = { };
  };
}
