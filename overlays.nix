{ config, pkgs, lib, inputs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    sqlite = pkgs.sqlite.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  };
  
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.unstable {
        system = pkgs.system;
        config = {
          allowUnfree = true;
          packageOverrides = upkgs: {
            sqlite = upkgs.sqlite.overrideAttrs (oldAttrs: {
              doCheck = false;
            });
          };
        };
      };
    })
    (final: prev: rec {
      intel = import inputs.nixpkgs {
        system = "x86_64-darwin";
        config = {
          allowUnfree = true;
          packageOverrides = ipkgs: {
            sqlite = ipkgs.sqlite.overrideAttrs (oldAttrs: {
              doCheck = false;
            });
          };
        };
      };
    })
  ];
  
  nix.nixPath = [
    { nixpkgs = "${inputs.nixpkgs}"; }
    { nixpkgs-unstable = "${inputs.unstable}"; }
  ];
}
