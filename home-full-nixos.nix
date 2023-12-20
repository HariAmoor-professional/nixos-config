{ config, pkgs, myUserName, ... }: {
  nixpkgs.config.chromium.enableWideVine = true;

  home.packages = with pkgs; [
    bitwarden
    discord
    element-desktop
    onlykey
    signal-desktop
    trezor-suite
    zoom-us
  ];

  programs = {
    alacritty.enable = true;
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
    xmobar.enable = true;
  };
}
