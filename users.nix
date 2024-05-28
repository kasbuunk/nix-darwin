{ pkgs, lib, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  users.users.kasbuunk = {
    name = "kasbuunk";
    home = "/Users/kasbuunk";
    shell = pkgs.zsh;
  };
  home-manager.users.kasbuunk = { config, pkgs, lib, ... }: {
    home.stateVersion = "23.11";
    imports = [
      ./home.nix
      #./darwin.nix
    ];
  };
}
