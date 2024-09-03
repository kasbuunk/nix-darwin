{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeManager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, unstable, homeManager }:
  let
    configuration = { pkgs, ... }: {
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
    };
    device = "";
    userName = "";
    authSocket = "";
    gitSigningKey = "";
    privateDomain = "";
    companyDomain = "";
    clientDomain = "";
    clientNamespace = "";
    clientToken = "";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#KasBook
    darwinConfigurations.${device}= nix-darwin.lib.darwinSystem {
      modules = [
        ./overlays.nix
        configuration
        homeManager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        ./users.nix
        ./configuration.nix
      ];
      specialArgs = {
        inherit
        inputs
        device
        userName
        authSocket
        gitSigningKey
        privateDomain
        companyDomain
        clientDomain
        clientNamespace
        clientToken;
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.${device}.pkgs;
  };
}
