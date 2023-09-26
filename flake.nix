{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    nixos-generators.url = "github:nix-community/nixos-generators/master";
    hyprland.url = "github:hyprwm/hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-parts
    , home-manager
    , nixos-flake
    , nixos-generators
    , hyprland
    , hyprland-plugins
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ nixos-flake.flakeModule ];

      flake =
        let
          myUserName = "hariamoor";
        in
        {
          nixosModules.default = {
            nixpkgs.hostPlatform = builtins.currentSystem;
            imports = [
              ./hardware-configuration.nix
              ./configuration.nix
              nixos-generators.nixosModules.all-formats
            ];
          };

          nixosConfigurations.nixos = self.nixos-flake.lib.mkLinuxSystem {
            _module.args = { inherit myUserName; };
            imports = [ self.nixosModules.default ];
          };

          homeConfigurations."hariamoor@nixos" = home-manager.lib.homeManagerConfiguration {
            configuration = import ./home.nix;
            extraSpecialArgs = { inherit inputs; };
            pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};

            modules = [
              hyprland.homeManagerModules.default
            ];
          };
        };
    };
}
