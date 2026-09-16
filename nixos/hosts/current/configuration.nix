# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, libs, inputs, pkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../nixModules/networkModules/networkServices.nix
    ];  

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true; 
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = false;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.loader.grub.extraEntries = ''
  	menuentry "Nobara Linux" {
		insmod part_gpt
		insmod fat
		insmod chain
		search --fs-uuid --set=root 87F4-1221
		chainloader /EFI/fedora/shimx64.efi
	}
  '';

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  
  # add nix experimental commands 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."balthazar" = {
    isNormalUser = true;
    description = "Balthazar Charvet";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  
  # Home-manager config

	home-manager = {
		useUserPackages = true;
		useGlobalPkgs = true;
		backupFileExtension = "backup";
		users.balthazar = import ../../nixModules/homeManagerModules/home.nix;
	}; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
	
	nixpkgs.config.permittedInsecurePackages = [
		"quickjs-2025-09-13-2"
	];

  environment.systemPackages = with pkgs; [
		# System
		grub2
		os-prober
		btrfs-progs
    file
    lvm2
    efibootmgr
    brightnessctl
    quickjs
		jdk25
		pulseaudio

			#UPower dependencies 
			upower
			glib
			libgudev
			polkit

    # Utils
    neovim
    bat
    vscodium
    git
		libnotify
    lsd
    tree 
    quickshell 
    killall
    zip 
    unzip 
    croc
		discord
		inxi #hardware info
		nix-tree # =?> to check for dependency use 
		
		# Hyprland
		wev
    hyprlauncher
    wallrizz 
		hyprpaper

    #browsers
		proton-vpn-cli
    firefox-devedition
    brave

    # funziz
    ani-cli
    ani-skip
    lolcat
    figlet
		cmatrix
		cbonsai

		# pixie config 
		(inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
      background = ../../../Images/Wallpapers/Kath.png; 
			avatar = ../../../Images/Avatars/amon2.png;      
			accentColor = "#317860";          # Hex color code
      autoColor = true;                 # true/false
      backgroundColor = "#1A1C1E";      # Hex color code
      textColor = "#E2E2E6";            # Hex color code
      fontFamily = "Terminess Nerd Font Proto";    # Font family name (must be installed system-wide)
    })

  ];
	
	fonts.packages = with pkgs; [
		material-symbols
		nerd-fonts.bigblue-terminal
		nerd-fonts.terminess-ttf
	];

  programs.hyprland = {
  	enable = true;
		withUWSM = true;
		xwayland.enable = true;
  };
	
	# Services

	services.upower = { 
		enable = true;
		usePercentageForPolicy = true;
		percentageLow = 20;
	};

  xdg.portal = { 
  	enable = true; 
		extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

	# login manager config 

	services.displayManager = {
		autoLogin = {
			enable = false;
			user = "balthazar";
		};
	};

	services.displayManager.sddm = {
		enable = true;
		theme = "pixie";
		wayland.enable = true;

		enableHidpi = false; 

		settings = {
							
		};

		autoNumlock = true;

		package = pkgs.kdePackages.sddm; 

		extraPackages = [
			pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qtdeclarative
      pkgs.kdePackages.qt5compat
		];
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; 
}
