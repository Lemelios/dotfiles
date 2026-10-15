{config, lib, pkgs, ...}:
{
	environment = {

		shellAliases = {
			l = null;
			s = null;
			ssh = "kitten ssh";
			sudoe = "sudo -E";
			daemonize = "systemd-run --user --remain-after-exit";
			svi = "sudoe nvim";
			ls = "lsd";
			DNS = "nmcli | grep DNS -A 2";
			myip = "curl https://ipinfo.io/ip";
			maj-done = "notify-send 'MAJ' 'Mise À Jour terminée' -u normal -a Kitty";
      maj-fail = "notify-send 'MAJ' 'Echec de la Mise à Jour' -u critical -a Kitty";
      sshtome = "ssh balthazar@$IP";
      Hit = "bluetoothctl connect 00:1E:7C:BF:0B:4C";
			cat = "bat -pp";
		};
		shells = with pkgs; [ 
			bashInteractive 
			fish
		];
	
	};
	programs.fish.enable = true;
}
