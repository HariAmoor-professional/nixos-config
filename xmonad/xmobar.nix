{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.xmobar;
in {
  options = {
    services.xmobar = {
      enable = mkEnableOption "xmobar";
      package = mkPackageOption pkgs "xmobar" { };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.xmobar = {
      Unit = {
        Description = "Start up xmobar";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];

        Restart = "always";
      };

      Service = {
        ExecStart = "${cfg.package}/bin/xmobar";
        ExecStop = "${pkgs.procps}/bin/pkill xmobar";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}