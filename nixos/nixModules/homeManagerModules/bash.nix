{config, libs, ...}:

{
	programs.bash = {
		enable = true;
		enableCompletion = true;
		shellAliases = {
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
}

