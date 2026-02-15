{ config, pkgs, lib, inputs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    sqlite = pkgs.sqlite.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  };
  
  nixpkgs.overlays = [
    # Fix inetutils build failure on macOS by providing a dummy package
    (final: prev: {
      inetutils = prev.runCommand "inetutils-dummy" {} ''
        mkdir -p $out/bin
        mkdir -p $out/share/man/man1
        # Create dummy binaries that just print a message
        for cmd in telnet ftp tftp; do
          cat > $out/bin/$cmd << 'EOF'
#!/bin/sh
echo "inetutils is not available on this system (build failure on macOS)"
exit 1
EOF
          chmod +x $out/bin/$cmd
        done
      '';
    })
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
