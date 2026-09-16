{libs, ... } : 

{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	networking = {
	  hostName = "nixos";

		networkmanager.enable = true; 

		hosts = {
			"83.202.128.51" = ["maison"];
		};		
	};
}