{ libs, pkgs, ... } :

{
  imports = [
    ./networking.nix
    ./bluetooth.nix
    ./git.nix
    ./networkPkgs.nix
  ];
}