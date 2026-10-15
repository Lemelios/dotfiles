{config, lib, ...}:

{
	programs.bash = {
		enable = true;
		enableCompletion = true;
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

