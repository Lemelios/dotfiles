{libs, config, ...}:

{
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
