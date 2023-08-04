{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ inputs.nixos-flake.flakeModule ];

      flake =
        let
          myUserName = "hariamoor";
        in
        {
          nixosConfigurations.nixos = self.nixos-flake.lib.mkLinuxSystem {
            _module.args = { inherit myUserName; };
            imports = [
              ./hardware-configuration.nix
              # Your machine's configuration.nix goes here
              ./configuration.nix
              # Setup home-manager in NixOS config
              self.nixosModules.home-manager
              {
                home-manager.users.${myUserName} = {
                  imports = [ self.homeModules.default ];
                };
              }
            ];
          };

          homeModules.default = { pkgs, ... }: {
            imports = [ ./home.nix ];
            _module.args = { inherit myUserName; };
          };
        };
    };
}
