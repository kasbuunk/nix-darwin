{ pkgs, lib, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.kasbuunk = { config, pkgs, lib, ... }: {
    home.stateVersion = "23.11";
    imports = [
      ./home.nix
      ./darwin.nix
    ];
  };
}
