{config, lib, nixpkgs, ...}:

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
					  imgName = "nixos";
	        }
		    ];
			};
		};
		efi.canTouchEfiVariables = true;
	};
}
