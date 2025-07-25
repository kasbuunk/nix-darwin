{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    staging.url = "github:NixOS/nixpkgs/staging";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeManager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, unstable, staging, homeManager }:
  let
    configuration = { pkgs, ... }: {
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
    };

    secrets = import ./secrets.nix;
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#{secrets.device}
    darwinConfigurations.${secrets.device}= nix-darwin.lib.darwinSystem {
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
        inputs;
        device = secrets.device;
        userName = secrets.userName;
        authSocket = secrets.authSocket;
        gitSigningKey = secrets.gitSigningKey;
        privateDomain = secrets.privateDomain;
        companyDomain = secrets.companyDomain;
        clientDomain = secrets.clientDomain;
        clientNamespace = secrets.clientNamespace;
        clientToken = secrets.clientToken;
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.${secrets.device}.pkgs;
  };
}
