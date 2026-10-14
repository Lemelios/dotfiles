{config, libs, pkgs, ...}:
{
	
	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			set fish_greeting 
		'';	
	};
}
