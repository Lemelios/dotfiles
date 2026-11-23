{config, pkgs, inputs, ...}:

{
	imports = [
		./discord.nix
		./kitty.nix
		./neovim.nix 
		./hyprpaper.nix
	];

	options = {
		
	};

	config = {
		home = {
			username = "balthazar";
			homeDirectory = "/home/balthazar";
			stateVersion = "26.05";
			sessionPath = [ "$HOME/pbin" ];
			sessionVariables = { IP = "83.202.128.51"; };
		};
	};
}
