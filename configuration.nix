{ config, pkgs, myUserName, ... }: {
  nix = {
    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
      trusted-users = [ myUserName ];
      max-jobs = "auto";
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    users.${myUserName} = {
      home = "/home/${myUserName}";
      description = "Main user account";
      isNormalUser = true;
      createHome = true;
      # NOTE: I should harden users here if I ever
      # have anything important on this machine
      hashedPassword = "";
      initialPassword = "";
    };
    mutableUsers = false;
  };

  system = {
    stateVersion = "24.05";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      # flake = "github:HariAmoor-professional/nixos-config/staging";
    };
  };
}
