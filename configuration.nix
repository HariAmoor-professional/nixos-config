{ config, pkgs, myUserName, ... }: {
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.enable = true;
  };

  fonts = {
    fontconfig.enable = true;
    enableDefaultPackages = true;
    packages = [
      (pkgs.nerdfonts.override {
        fonts = [
          "FiraCode"
          "DroidSansMono"
        ];
      })
      # pkgs.nerdfonts
    ];
  };

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    networkmanager.enable = true;
    nftables.enable = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
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
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    onlykey.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
    };
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
