{ config, pkgs, myUserName, ... }:
rec {
  nixpkgs.config.allowUnfree = true;

  home = {
    username = myUserName;
    homeDirectory = "/home/${myUserName}";
    packages = with pkgs; [
      bitwarden-cli
      nix-prefetch-github
      onlykey-agent
      trezor_agent
      trezorctl
    ];
    stateVersion = "23.11";
  };

  programs = {
    btop = {
      enable = true;
      settings.color_theme = "nightfox";
    };
    feh.enable = true;
    git = {
      enable = true;
      userName = "HariAmoor-professional";
      userEmail = "hariamoor@protonmail.com";
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "hx";
      };
    };

    home-manager.enable = true;

    helix = {
      enable = true;
      settings = {
        theme = "nightfox";
        editor = {
          lsp.display-messages = true;
          line-number = "relative";
        };
        keys.insert.j.k = "normal_mode";
      };
    };

    ripgrep.enable = true;
  };

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "weekly";
  };
}
