{config, lib, ...}: 

{
	imports = [
		./bootloader.nix
		./systemPkgs.nix
		./env.nix
	];

	nix = {
		gc = {
			automatic = true;
			dates = "weekly";
		};
		
	};
}
