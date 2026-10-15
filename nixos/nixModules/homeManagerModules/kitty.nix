{config, pkgs, lib, inputs, ...}:

{
	imports = [ 
		inputs.areofyl-fetch.homeManagerModules.default 
		./bash.nix
		./fish.nix
	];

	programs.kitty = { 
    enable = true;
    shellIntegration.enableBashIntegration = false;
		shellIntegration.enableFishIntegration = false;
    settings = {
      background = "#081A00";
      background_opacity = "0.75";
      background_blur = "1"; 
      cursor_shape = "block";
      cursor_trail = "1"; 
      cursor_trail_decay = "0.1 0.4";
      map = "--allow-fallback=shifted,ascii ctrl+c copy_or_interrupt";
			font-family = "Terminess Nerd Font Proto";
			shell = "fish";
    };
  };

	programs.fetch = {
    enable = true;
    labelColor = "cyan";
    info = [
      "os"
      "host"
      "kernel"
      "uptime"
      "shell"
      "display"
      "wm"
      "icons"
      "font"
      "terminal"
      "cpu"
      "gpu"
      "memory"
      "disk"
      "ip"
      "locale"
      "colors"
    ];
    speed = 1.0;
    spin = "xy";
    separator = "—";
    shading = ".Mm|";
    light = "top-left";
    size = 1.5;
  };
} 
