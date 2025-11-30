{ host, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  system.stateVersion = "25.05";
  networking.hostName = host;
}
