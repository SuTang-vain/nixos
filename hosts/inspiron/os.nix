{ host, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  system.stateVersion = "25.05";
  networking.hostName = host;

  # 启用实验特性（永久生效）
  nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
}
