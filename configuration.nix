{ config, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;

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
      trusted-users = [ "hariamoor" ];
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
    bluetooth.enable = true;
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
    users.hariamoor = {
      home = "/home/hariamoor";
      description = "Main user account";
      extraGroups = [ "docker" "wheel" "networkmanager" ];
      isNormalUser = true;
      createHome = true;
      hashedPassword = "";
      initialPassword = "";
      shell = pkgs.nushell;
    };
    mutableUsers = false;
  };

  environment = {
    systemPackages = with pkgs; [ curl feh imagemagick ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
