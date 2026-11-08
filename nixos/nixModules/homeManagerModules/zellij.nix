{config, lib, pkgs, ...}:

{
  programs.zellij = {
    enable = true;
    attachExistingSession = true; 
    exitShellOnExit = false;
		settings = {
			default_shell = "fish";
		};
    #b8ef44a2-628e-454b-bd3a-306a8578c8ad
  };
}
