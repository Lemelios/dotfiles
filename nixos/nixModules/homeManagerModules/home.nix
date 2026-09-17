{config, pkgs, ...}:

{
  home.username = "balthazar";
  home.homeDirectory = "/home/balthazar";
  home.stateVersion = "26.05";


	imports = [
		./bash.nix
		./discord.nix
		./kitty.nix
		./neovim.nix 
		./hyprpaper.nix
	];
}
