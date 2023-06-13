{ config, pkgs, myUserName ? "hariamoor", ... }:
rec {
  nixpkgs.config = {
    allowUnfree = true;
    chromium = { enableWideVine = true; };
  };

  home = {
    username = myUserName;
    homeDirectory = "/home/${myUserName}";
    packages = with pkgs; [
      bitwarden
      bitwarden-cli
      element-desktop
      nix-prefetch-github
      onlykey
      onlykey-agent
      signal-desktop
      trezor-suite
      trezor_agent
      trezorctl
      zoom-us
    ];
  };

  programs = {
    alacritty.enable = true;
    btop = {
      enable = true;
      settings.color_theme = "onedark";
    };
    chromium = {
      enable = true;
      extensions = [
        "aghfnjkcakhmadgdomlmlhhaocbkloab"
        # "kfdniefadaanbjodldohaedphafoffoh" # Typhon wallet
        "gafhhkghbfjjkeiendhlofajokpaflmk" # Lace wallet
        "cfhdojbkjhnklbpkdaibdccddilifddb"
        "efaidnbmnnnibpcajpcglclefindmkaj"
        "nngceckbapebfimnlniiiahkandclblb"
        "nkbihfbeogaeaoehlefnkodbefgpgknn"
      ];
    };

    feh.enable = true;

    git = {
      enable = true;
      userName = "HariAmoor-professional";
      userEmail = "professional@hariamoor.me";
    };

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    nushell = {
      enable = true;
      environmentVariables.EDITOR = "hx";
      extraConfig = ''
        let-env config = {
          ls: {
            use_ls_colors: true
          }
          table: {
            mode: rounded
          }
        }
      '';
    };

    home-manager.enable = true;

    helix = {
      enable = true;
      settings = {
        theme = "onedark";
        editor = {
          lsp.display-messages = true;
          line-number = "relative";
        };
        keys.insert.j.k = "normal_mode";
      };
    };

    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/davatorium/rofi/next/themes/material.rasi";
        sha256 = "7607d23e5c67ebb9c9779446e7a36f1c5c3e97628e7debde02f5515e5dd48fe7";
      };
    };

    xmobar = {
      enable = true;
      extraConfig = builtins.readFile ./xmonad/xmobar.conf;
    };
  };

  services = {
    flameshot.enable = true;
    redshift = {
      provider = "geoclue2";
      enable = true;
      temperature = {
        day = 1000;
        night = 1000;
      };
    };
  };
}
