{ config, pkgs, myUserName, ... }: {
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.enable = true;
  };

  fonts = {
    fonts = with pkgs; [ nerdfonts ];
    fontconfig.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      substituters = [ "https://hydra.iohk.io/" "https://iohk.cachix.org/" ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      ];
      auto-optimise-store = true;
      trusted-users = [ myUserName ];
      max-jobs = "auto";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  location.provider = "geoclue2";
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl.enable = true;
    onlykey.enable = true;
  };

  services = {
    geoclue2.enable = true;
    ratbagd.enable = true;
    trezord.enable = true;
    dbus.enable = true;
    xserver = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        config = builtins.readFile ./xmonad/xmonad.hs;
        enableContribAndExtras = true;
        enableConfiguredRecompile = true;
      };
      videoDrivers = [ "nvidia" ];
      xkbOptions = "caps:escape";
    };
  };

  users = {
    users.${myUserName} = {
      home = "/home/${myUserName}";
      description = "Main user account";
      extraGroups = [ "wheel" "networkmanager" ];
      isNormalUser = true;
      createHome = true;
      # NOTE: I should harden users here if I ever
      # have anything important on this machine
      hashedPassword = "";
      initialPassword = "";
      shell = pkgs.nushell;
    };
    mutableUsers = false;
  };

  environment = {
    systemPackages = with pkgs; [ curl feh imagemagick ];
  };

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      flake = "github:HariAmoor-professional/nixos-config/staging";
    };
  };
}
