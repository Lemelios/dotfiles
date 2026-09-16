{ libs , ...} : 

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; 
    network = {
      General = {
        DisableSecurity = true;
      };
    };
  };
}