{ config, pkgs, myUserName, ... }:
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
      discord
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
    stateVersion = "23.11";
  };

  programs = {
    alacritty.enable = true;
    btop = {
      enable = true;
      settings.color_theme = "nightfox";
    };
    chromium = {
      enable = true;
      extensions = [
        "aghfnjkcakhmadgdomlmlhhaocbkloab"
        "kfdniefadaanbjodldohaedphafoffoh" # Typhon wallet
        # "gafhhkghbfjjkeiendhlofajokpaflmk" # Lace wallet
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
      settings = {
        git_protocol = "ssh";
        editor = "hx";
      };
    };

    nushell = {
      enable = true;
      environmentVariables.EDITOR = "hx";
      extraConfig = ''
        $env.config = {
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
        theme = "nightfox";
        editor = {
          lsp.display-messages = true;
          line-number = "relative";
        };
        keys.insert.j.k = "normal_mode";
      };
    };

    ripgrep.enable = true;

    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/davatorium/rofi/next/themes/material.rasi";
        sha256 = "7607d23e5c67ebb9c9779446e7a36f1c5c3e97628e7debde02f5515e5dd48fe7";
      };
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    xmobar = {
      enable = true;
      extraConfig = builtins.readFile ./xmonad/xmobar.conf;
    };

    zathura.enable = true;

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
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
    home-manager.autoUpgrade = {
      enable = true;
      frequency = "weekly";
    };

    xmobar.enable = true;
  };
}
