{ inputs, config, pkgs, myUserName, ... }:
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
      libnotify
      hyprpaper
      onlykey
      onlykey-agent
      signal-desktop
      trezor-suite
      trezor_agent
      telegram-desktop
      trezorctl
      zoom-us
    ];
    stateVersion = "23.11";
  };

  programs = {
    alacritty = {
      enable = true;
      settings =
        let
          theme = "nightfox";
        in
        ''
          import:
            - ${pkgs.fetchFromGitHub {
              owner = "alacritty";
              repo = "alacritty-theme";
              rev = "0899ec571b64e4157ad6f0d63521f822d27abcbc";
              sha256 = "3BkRl7vqErQJgjqkot1MFRb5QzW4Jtv1Fuk4+CQfZOs=";
            }}/themes/${theme}.yaml
        '';
    };

    btop = {
      enable = true;
      settings.color_theme = "nightfox";
    };
    chromium = {
      enable = true;
      extensions = [
        "aghfnjkcakhmadgdomlmlhhaocbkloab"
        "kfdniefadaanbjodldohaedphafoffoh" # Typhon wallet
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

    kitty.enable = true;

    ripgrep.enable = true;

    waybar = {
      enable = true;
      systemd.enable = true;
    };

    wofi.enable = true;

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    zathura.enable = true;

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  services = {
    flameshot.enable = true;
    home-manager.autoUpgrade = {
      enable = true;
      frequency = "weekly";
    };
    dunst = {
      enable = true;
      waylandDisplay = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    systemdIntegration = true;
    xwayland.enable = true;
    /*
      settings = {
      "$mod" = "ALT";
      monitor = "DP-0,3840x2160@60,0x0,1";
      unbind = [ "$mod,Q" ];
      bind = [
        "$mod,P,exec,wofi,-s,run"
        "$mod SHIFT,C,closewindow"
        "$mod,ENTER,exec,alacritty"
      ] ++ builtins.concatLists (
        builtins.genList (
          x: let
            c = (x + 1) / 10;
            ws = x + 1 - (c * 10);
          in [
            "$mod,${ws},workspace,${toString (x + 1)}"
            "$mod SHIFT, ${ws},movetoworkspace,${toString (x + 1)}"
          ]
        ) 10
      );
      };
    */
    plugins = with inputs; [
      hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
  };
}
