{config, libs, ...}: 

{
	imports = [
		./bootloader.nix
		./systemPkgs.nix
	];
}
