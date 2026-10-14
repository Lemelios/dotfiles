{config, pkgs, inputs, ...}:

{
  home = {
		username = "balthazar";
		homeDirectory = "/home/balthazar";
		stateVersion = "26.05";
		sessionPath = [ "$HOME/pbin" ];
		sessionVariables = { IP = "83.202.128.51"; };
	};

	imports = [
		./discord.nix
		./kitty.nix
		./neovim.nix 
		./hyprpaper.nix
	];
}
