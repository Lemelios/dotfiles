{config, libs, nixpkgs, ...}:

{
	boot.loader = {
		systemd-boot.enable = false;
		grub= {
			enable = true;
			efiSupport = true;
			efiInstallAsRemovable = false;
			device = "nodev";
			useOSProber = true; 

			minegrub-world-sel = {
				enable = true; 
				customIcons = with config.system; [
					{
						inherit name;
		        lineTop = with nixos; distroName + " " + codeName + " (" + version + ")";
			      lineBottom = "Survival Mode, Cheats On, Version: " + nixos.release;
				    # Icon: you can use an icon from the remote repo, or load from a local file
					  imgName = "nixos";
		        # customImg = builtins.path {
			      #   path = ./nixos-logo.png;
				    #   name = "nixos-img";
					  # };
	        }
		    ];
			};
		};
		efi.canTouchEfiVariables = true;
	};
}
