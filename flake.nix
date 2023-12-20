{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    nixos-wsl = {
      url = "github:nix-community/NixOS-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, home-manager, nixos-flake, nixos-wsl, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ nixos-flake.flakeModule ];

      flake = {
        nixosConfigurations = {
          desktop =
            let
              myUserName = "hariamoor";
            in
            self.nixos-flake.lib.mkLinuxSystem {
              nixpkgs.hostPlatform = "x86_64-linux";
              _module.args = { inherit myUserName; };
              imports = [
                ./hardware-configuration.nix
                # Your machine's configuration.nix goes here
                ./configuration.nix
                ./configuration-full-nixos.nix
                # Setup home-manager in NixOS config
                self.nixosModules.home-manager
                {
                  home-manager.users.${myUserName} = {
                    imports = [ self.homeModules.default ];
                  };
                }
              ];
            };

          wsl =
            let
              myUserName = "nixos";
            in
            self.nixos-flake.lib.mkLinuxSystem {
              nixpkgs.hostPlatform = "x86_64-linux";
              _module.args = { inherit myUserName; };

              imports = [
                nixos-wsl.nixosModules.default
                ({ ... }: {
                  wsl = {
                    enable = true;
                    defaultUser = myUserName;
                  };
                })
                ./configuration.nix
                self.nixosModules.home-manager
                {
                  home-manager.users.${myUserName} = {
                    _module.args = { inherit myUserName; };
                    imports = [ self.homeModules.wsl ];
                  };
                }
              ];
            };
        };

        homeModules = {
          default = { pkgs, ... }: {
            imports = [
              ./home.nix
              ./home-full-nixos.nix
              ./xmonad/xmobar.nix
            ];
          };
          wsl = { pkgs, ... }: {
            imports = [ ./home.nix ];
          };
        };
      };
    };
}
