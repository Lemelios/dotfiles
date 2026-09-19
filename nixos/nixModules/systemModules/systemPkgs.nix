{config, libs, pkgs, nixpkgs, ...}:

{
	environment.systemPackages = with pkgs; [
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
		upower
		glib
		libgudev
		polkit
	];
}
