{
  self,
  host,
  user,
  pkgs,
  ...
}:
{
  programs.nh = {
    enable = true;
    package = pkgs.nh;  # 使用 stable version from nixpkgs
    clean = {
      enable = true;
      dates = "3 days";
      extraArgs =
        let
          numColorschemes = builtins.length self.homeConfigurations."${user}@${host}".config.colorSchemes;
          numToKeep = numColorschemes * 2 |> toString;
        in
        "--keep ${numToKeep}";
    };
  };
  environment.variables.NH_FLAKE = "/home/${user}/.config/nixos";
}
