{config, pkgs, inputs, ...}:

{
	imports = [
		./discord.nix
		./kitty.nix
		./neovim.nix 
		./hyprpaper.nix
	];

	options = {
		dUser = {
			username = lib.mkOption {
				type = lib.types.string ;
				default = "balthazar";
				description = "the username of the default user on the system, if more users are to be created, they would be added independently";
			};
			homeDir = lib.mkOption {
				type = lib.types.string;
				default = "/home/balthazar";
			};
			userPath = lib.mkOption {
				type = lib.types.listOf lib.types.string;
				default = [ "$HOME/pbin" ];
				description = "the paths added to the default user's personal PATH variable";
			};
			sessionVars = lib.mkOption {
				type = lib.types.attrs;
				default = {};
			};
		};
	};

	config = 
		let 
			dUser	= config.dUser;
		in{
		dUser.sessionVars = { IP = "83.202.128.51" };
		home = {
			username = dUser.username;
			homeDirectory = dUser.homeDir;
			stateVersion = "26.05";
			sessionPath = dUser.userPath;
			sessionVariables = dUser.sessionVars;
		};
	};
}
