{config, libs, pkgs, ...}:

{
	programs.kitty = { 
    enable = true;
    shellIntegration.enableBashIntegration = false;
    settings = {
      background = "#081A00";
      background_opacity = "0.75";
      background_blur = "1"; 
      cursor_shape = "block";
      cursor_trail = "1"; 
      cursor_trail_decay = "0.1 0.4";
      map = "--allow-fallback=shifted,ascii ctrl+c copy_or_interrupt";
			font-family = "Terminess Nerd Font Proto";
    };
  };
}
