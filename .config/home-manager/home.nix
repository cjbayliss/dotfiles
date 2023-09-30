{ config, pkgs, ... }:

with pkgs;
let
  python = python3.withPackages (pp: with pp; [ flake8 notify2 pylint ]);
in
{
  home.username = "cjb";
  home.homeDirectory = "/home/cjb";
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.local/cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";

    userDirs.enable = true;
    userDirs.createDirectories = true;

    userDirs.desktop = "${config.home.homeDirectory}/stuff/desktop";
    userDirs.documents = "${config.home.homeDirectory}/stuff";
    userDirs.download = "${config.home.homeDirectory}/downloads";
    userDirs.music = "${config.home.homeDirectory}/music";
    userDirs.pictures = "${config.home.homeDirectory}/pictures";
    userDirs.videos = "${config.home.homeDirectory}/videos";

    # disable these
    userDirs.publicShare = null;
    userDirs.templates = null;
  };

  home.stateVersion = "23.05";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "intelephense"
  ];

  home.packages = with pkgs; [
    # libs
    aspell
    aspellDicts.en
    dmenu
    hsetroot
    mangohud
    pulseaudio # for pactl
    sx
    xmobar

    # langs
    chicken
    fennel
    gcc
    ghc
    php
    python
    sbcl

    # langs-extras
    black
    fnlfmt
    hlint
    lua-language-server
    nixpkgs-fmt
    nodePackages.intelephense
    proselint
    shellcheck
    stylua

    # tools
    any-nix-shell
    bubblewrap
    neovim
    playerctl
    podman-compose
    scrot
    tmux

    # gui
    (ungoogled-chromium.override { commandLineArgs = ''--js-flags="--jitless --noexpose_wasm" --no-pings ''; })
    bottles
    discord
    firefox
    heroic
    j4-dmenu-desktop

    # games
    openmw
  ];

  home.file = {
    # if you are a python developer or someone else considering writing
    # files into peoples home directory, PLEASE allow people to at least
    # turn it off, at a bare minimum.  providing a way to change where the
    # files are written is polite too!
    #
    # no, readline.set_auto_history(False) doesnt stop python writing
    # ~/.python_history, it just stops python adding history to that file.
    #
    # refs:
    #
    #   * https://bugs.python.org/issue5845
    #   * https://bugs.python.org/issue20886
    #   * https://bugs.python.org/issue26870
    #   * https://bugs.python.org/issue29779
    #   * https://bugs.python.org/issue41563
    #   * https://docs.python.org/3/library/readline.html#example
    #   * https://github.com/python/cpython/pull/13208
    #   * https://unix.stackexchange.com/a/297834
    ".config/python/startup.py".text = ''
      try:
          import readline
          readline.write_history_file = lambda *args: None
          del readline
      except ImportError:
          pass
    '';

    # xorg config
    ".config/sx/sxrc".text = ''
      #!/bin/sh
      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      xrdb -load "$XDG_CONFIG_HOME/sx/xresources"

      # systemctl --user restart redshift
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
    ".config/sx/sxrc".executable = true;
  };

  gtk = {
    enable = true;

    cursorTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };

    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 11;
    };

    iconTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };

    theme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
    };
  };

  xresources = {
    path = "${config.xdg.configHome}/sx/xresources";
    properties = {
      "Xcursor.size" = 24;
      "Xcursor.theme" = "Yaru";

      "Xft.dpi" = 96;
      "Xft.autohint" = 0;
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintslight";
      "Xft.hinting" = 1;
      "Xft.antialias" = 1;
    };
  };

  programs.git = {
    enable = true;
    userEmail = "cjbdev@icloud.com";
    userName = "Christopher Bayliss";
  };

  programs.mpv = {
    enable = true;
    package = (pkgs.mpv.override { scripts = [ mpvScripts.mpris ]; });

    bindings = {
      "q" = "stop";
      "Ctrl+w" = "ignore";
      "Ctrl+q" = "ignore";
    };

    config = {
      script-opts = "ytdl_hook-ytdl_path=yt-dlp";
      ytdl-format = "[format_id*=adaptive_hls-audio-jaJP][height<=?1080]/bestvideo[height<=?1080]+bestaudio/best";
      slang = "eng,en,enUS";
      cache = "auto";
      embeddedfonts = "no";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 11.5;
      };

      cursor = {
        blink_interval = 500;
        style = {
          blinking = "Always";
          shape = "Underline";
        };
      };

      # https://gitlab.com/protesilaos/dotfiles/-/raw/487affab/emacs/.emacs.d/prot-lisp/modus-themes-exporter.el
      colors = {
        bright = {
          black = "#595959";
          blue = "#79a8ff";
          cyan = "#6ae4b9";
          green = "#70b900";
          magenta = "#b6a0ff";
          red = "#ef8b50";
          white = "#ffffff";
          yellow = "#c0c530";
        };
        normal = {
          black = "#000000";
          blue = "#2fafff";
          cyan = "#00d3d0";
          green = "#44bc44";
          magenta = "#feacd0";
          red = "#ff8059";
          white = "#bfbfbf";
          yellow = "#d0bc00";
        };
        primary = {
          background = "#000000";
          foreground = "#ffffff";
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      character = {
        format = "» ";
      };
      cmd_duration = {
        disabled = true;
      };
      directory = {
        fish_style_pwd_dir_length = 1;
        format = "[$path]($style) ";
        style = "bright-cyan";
        truncate_to_repo = false;
        truncation_length = 1;
      };

      git_branch = {
        format = "[$branch]($style) ";
        style = "bright-purple";
      };
      git_commit = {
        format = "(\\($hash$tag\\) )";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "purple";
        conflicted = "!!";
        deleted = "D";
        modified = "M";
        renamed = "R";
        staged = "M";
      };

      hostname = {
        format = "[$hostname](bright-white) ";
        ssh_only = false;
      };
      line_break = {
        disabled = true;
      };
      status = {
        disabled = false;
        format = "[$status]($style) ";
      };
      nix_shell = {
        format = "[\\[nix-$name\\]]($style) ";
        style = "bold bright-red";
      };
      format = "$nix_shell\$hostname\$directory\$git_branch\$git_commit\$git_state\$git_status\$env_var\$status\$character";

    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      any-nix-shell fish | source

      # allow urls with '?' in them
      set -U fish_features qmark-noglob

      # colors
      set -U fish_color_autosuggestion      brblue
      set -U fish_color_cancel              -r
      set -U fish_color_command             'white' '--bold'
      set -U fish_color_comment             brblue
      set -U fish_color_cwd                 brcyan
      set -U fish_color_cwd_root            red
      set -U fish_color_end                 brmagenta
      set -U fish_color_error               brred
      set -U fish_color_escape              brcyan
      set -U fish_color_history_current     --bold
      set -U fish_color_host                normal
      set -U fish_color_match               --background=brblue
      set -U fish_color_normal              normal
      set -U fish_color_operator            normal
      set -U fish_color_param               normal
      set -U fish_color_quote               yellow
      set -U fish_color_redirection         bryellow
      set -U fish_color_search_match        'bryellow' '--background=brblack'
      set -U fish_color_selection           'white' '--bold' '--background=brblack'
      set -U fish_color_status              red
      set -U fish_color_user                green
      set -U fish_color_valid_path          --underline
      set -U fish_pager_color_completion    normal
      set -U fish_pager_color_description   yellow
      set -U fish_pager_color_prefix        'white' '--bold' '--underline'
      set -U fish_pager_color_progress      '-r' 'white'
    '';

    loginShellInit = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]
          exec sx
      end
    '';
  };

  programs.yt-dlp = {
    enable = true;
    extraConfig = ''
      # this means 'keep downloading the rest of the playlist even is one item on the
      # list fails'
      --ignore-errors

      # select the optimal format for my desktop
      -f [format_id*=adaptive_hls-audio-jaJP][height<=?1080]/bestvideo[ext=webm][height<=?1080]+bestaudio[ext=webm]/best
    '';
  };

  home.sessionVariables = {
    PYTHONSTARTUP = "${config.xdg.configHome}/python/startup.py";
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
    MOZ_GTK_TITLEBAR_DECORATION = "system"; # proper theming
    MOZ_USE_XINPUT2 = "1";

    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    VISUAL = "nvim";

    EMAIL = "cjbdev@icloud.com";
    NAME = "Christopher Bayliss";
  };

  programs.home-manager.enable = true;
}
