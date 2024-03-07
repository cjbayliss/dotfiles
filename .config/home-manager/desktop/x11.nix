{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    dmenu
    hsetroot
    scrot
    sx
    xmobar
  ];

  home.file.".config/sx/sxrc" = {
    text = ''
      #!/bin/sh
      source ${config.xdg.stateHome}/nix/profile/etc/profile.d/hm-session-vars.sh
      xrdb -load "$XDG_CONFIG_HOME/sx/xresources"

      systemctl --user restart picom

      if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
          eval $(dbus-launch --exit-with-session --sh-syntax)
      fi

      systemctl --user import-environment DISPLAY XAUTHORITY

      if command -v dbus-update-activation-environment >/dev/null 2>&1; then
          dbus-update-activation-environment DISPLAY XAUTHORITY
      fi

      xmonad
    '';
    executable = true;
  };

  xresources = {
    path = "${config.xdg.configHome}/sx/xresources";
    properties = {
      "Xcursor.size" = 32;
      "Xcursor.theme" = "Yaru";

      "Xft.dpi" = 108;
      "Xft.autohint" = 0;
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintslight";
      "Xft.hinting" = 1;
      "Xft.antialias" = 1;
    };
  };
}
