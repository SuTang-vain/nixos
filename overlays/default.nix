{ inputs, ... }:
{
  additions =
    final: prev:
    import ../pkgs {
      pkgs = final;
    };

  modifications = final: prev: {
    niri-unstable = prev.niri-unstable.overrideAttrs (old: {
      doCheck = false;
    });
    qutebrowser = prev.qutebrowser.override { enableWideVine = true; };
    base16-schemes = prev.base16-schemes.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/themes/
        install base16/*.yaml $out/share/themes/
        install ${final.custom-colorschemes}/share/themes/*.yaml $out/share/themes/

        runHook postInstall
      '';
    });
    sway-unwrapped =
      (prev.sway-unwrapped.overrideAttrs (oldAttrs: {
        src = inputs.scroll;
        patches = [ ];
      })).override
        { inherit (inputs.nixpkgs-wayland.packages.${final.stdenv.hostPlatform.system}) wlroots; };
    sway = prev.sway.overrideAttrs (oldAttrs: {
      passthru.providedSessions = [ "scroll" ];
    });
    inherit (inputs.nixpkgs-wayland.packages.${final.stdenv.hostPlatform.system}) swww;

    # Skip broken packages that cause rebuild to hang
    todesk = final.writeScriptBin "todesk" ''
      #!/usr/bin/env bash
      echo "todesk skipped by overlay" >&2
      exit 0
    '';
  };

  # 继承其他 overlays
  inherit (inputs.niri.overlays) niri;
  nur = inputs.nur.overlays.default;
  nix-matlab = inputs.nix-matlab.overlay;
}