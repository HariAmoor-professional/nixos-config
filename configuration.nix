{ inputs, config, pkgs, myUserName, ... }: {
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
  security.rtkit.enable = true;
  hardware = {
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

  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  services = {
    geoclue2.enable = true;
    ratbagd.enable = true;
    trezord.enable = true;
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      excludePackages = with pkgs; [ xterm ];
      videoDrivers = [ "nvidia" ];
      libinput.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
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
    sessionVariables."NIXOS_OZONE_WL" = "1";
    etc."resolv.conf".text = "nameserver 1.1.1.1\nnameserver 8.8.8.8\noptions edns0";
  };

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      flake = "github:HariAmoor-professional/nixos-config/staging";
    };
  };

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal xdg-desktop-portal-gtk ];
    };
  };
}
