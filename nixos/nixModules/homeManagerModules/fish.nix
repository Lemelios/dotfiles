{config, lib, pkgs, ...}:
{
	
	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			set fish_greeting 
		'';	
		plugins = [
			{ name = "tide"; src = pkgs.fishPlugins.tide.src ; }
			{ name = "done"; src = pkgs.fishPlugins.done.src ; }
			{ name = "autopair"; src = pkgs.fishPlugins.autopair.src ; }
			{ name = "sponge"; src = pkgs.fishPlugins.sponge.src ; }
			{ name = "forgit"; src = pkgs.fishPlugins.forgit.src ; }
			{ name = "fzf"; src = pkgs.fishPlugins.fzf.src ; }
		];
	};
}
