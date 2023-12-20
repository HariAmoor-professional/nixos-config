{ config, pkgs, myUserName, ... }: {
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.enable = true;
  };

  fonts = {
    fontconfig.enable = true;
    enableDefaultPackages = true;
    packages = [ pkgs.nerdfonts ];
  };

  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
  };

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

  environment.systemPackages = with pkgs; [
    curl
    feh
    imagemagick
  ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  users.users.${myUserName} = {
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.nushell;
  };
}
