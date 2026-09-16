{config, pkgs, ...}:

{	
  home.username = "balthazar";
  home.homeDirectory = "/home/balthazar";
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true; 
    enableCompletion = true;
    shellAliases = { 
      sudoe = "sudo -E";
			daemonize = "systemd-run --user --remain-after-exit";
      svi = "sudoe nvim";
      ls = "lsd";
      DNS = "nmcli | grep -A 2";
      myip = "curl https://ipinfo.io/ip";
      maj-done = "notify-send 'MAJ' 'Mise À Jour terminée' -u normal -a Kitty";
      maj-fail = "notify-send 'MAJ' 'Echec de la Mise à Jour' -u critical -a Kitty";
      sshtome = "ssh balthazar@$IP";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#current && maj-done || maj-fail";
      Hit = "bluetoothctl connect 00:1E:7C:BF:0B:4C";
    };

    initExtra = ''
        export KITTY_SHELL_INTEGRATION="no-rc no-cursor"
				if test -n "$KITTY_INSTALLATION_DIR"; then
					source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
				fi
        [ -f /etc/bashrc ] && source /etc/bashrc
				export IP="83.202.128.51";
				PATH=/home/balthazar/pbin:$PATH
	''; 
  };

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
  
  programs.neovim = {
    enable = true;
		defaultEditor = true; 
    initLua = ''
	  -- lua
      -- set transparency 

      vim.cmd [[
				highlight Normal guibg=none
				highlight NonText guibg=none
				highlight Normal ctermbg=none
				highlight NonText ctermbg=none
      ]]
	
      -- edit nvim variables

			vim.cmd("set tabstop=2")
			vim.cmd("set softtabstop=2")
			vim.cmd("set shiftwidth=2")

		-- Bootstrap lazy.nvim
		local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
		if not (vim.uv or vim.loop).fs_stat(lazypath) then
			local lazyrepo = "https://github.com/folke/lazy.nvim.git"
			local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
			if vim.v.shell_error ~= 0 then
				vim.api.nvim_echo({
					{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
					{ out, "WarningMsg" },
					{ "\nPress any key to exit..." },
				}, true, {})
				vim.fn.getchar()
				os.exit(1)
			end
		end
		vim.opt.rtp:prepend(lazypath)
	
		-- Make sure to setup `mapleader` and `maplocalleader` before
		-- loading lazy.nvim so that mappings are correct.
		-- This is also a good place to setup other settings (vim.opt)
		vim.g.mapleader = " "
		vim.g.maplocalleader = "\\"
		
		-- Setup lazy.nvim
		require("lazy").setup({
		  spec = {
				{
					'windwp/nvim-autopairs',
					name = "nvim-autopairs",
				 	event = "InsertEnter",
					config = true
			   	-- use opts = {} for passing setup options
					-- this is equivalent to setup({}) function
				},
			},
	 	 -- Configure any other settings here. See the documentation for more details.
		  -- colorscheme that will be used when installing plugins.
		  install = { colorscheme = { "habamax" } },
		  -- automatically check for plugin updates
	  checker = { enabled = true },
	})   
    '';
  };

	services.hyprpaper = {
		enable = true;
		settings = {
			splash = false;
			preload = [
				"/home/balthazar/Images/Wallpapers/Kath.png"
			];
			wallpaper = [
				{
					monitor = "";
					path = "/home/balthazar/Images/Wallpapers/Kath.png";
				}
			];
		};
	};
}
