{pkgs, ...}: {
  home.packages = with pkgs; [
    tofi
  ];

  home.file = {
    # wayland
    ".local/bin/sw".text = ''
      #!/bin/sh
      sleep 1 # :'(
      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

      if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
          eval $(dbus-launch --exit-with-session --sh-syntax)
      fi

      export NIXOS_OZONE_WL=1
      export WLR_NO_HARDWARE_CURSORS=1

      qtile start -b wayland
    '';
    ".local/bin/sw".executable = true;

    # dmenu replacement for wayland
    ".config/tofi/config".text = ''
      anchor = top
      width = 100%
      height = 26
      horizontal = true
      font-size = 12
      prompt-text = "> "
      text-cursor = true
      text-cursor-style = bar
      text-cursor-color = #ffffff
      font = monospace
      outline-width = 0
      border-width = 0
      background-color = #000000
      selection-color = #000000
      selection-background = #b6a0ff
      selection-background-corner-radius=2
      selection-background-padding=0,4
      min-input-width = 120
      result-spacing = 15
      padding-top = 2
      padding-bottom = 2
      padding-left = 0
      padding-right = 0
    '';
  };
}
