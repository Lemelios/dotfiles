{
  description = "Config de Lemelios MrdL";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		current.url  = "github:NixOS/nixpkgs/26.05";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "current";
		};
		pixie-sddm.url = "github:xCaptaiN09/pixie-sddm";
  };

  outputs = { self, unstable, current, ... }@inputs: {
		nixosConfiguration.nixos = unstable.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [ ./configuration.nix ];
		}; 
  };
}
