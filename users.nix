{ pkgs, lib, ... }:
let
  userName = "";
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.${userName} = { config, pkgs, lib, ... }: {
    imports = [
      ./home.nix
      ./darwin.nix
    ];
  };
}
