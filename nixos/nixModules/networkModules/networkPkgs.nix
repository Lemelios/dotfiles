{libs, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    wget
    curl
		openssh
		dig
		speedtest-cli
    openvpn
  ];
}