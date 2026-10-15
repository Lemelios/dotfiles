{config, lib, ...}: 

{
	imports = [
		./bootloader.nix
		./systemPkgs.nix
		./env.nix
	];
}
