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

  nixpkgs.config = {
    chromium = { enableWideVine = true; };
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "VCV-Rack"
      "bitwig-studio"
      "chrome-widevine-cdm"
      "chromium-unwrapped"
      "discord"
      "intelephense"
      "ungoogled-chromium"
    ];
  };

  home.packages = with pkgs; [
    # libs
    aspell
    aspellDicts.en
    mangohud
    pulseaudio # for pactl
    tofi

    # langs
    chicken
    fennel
    gcc
    ghc
    nodejs_20
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
    bubblewrap
    jq
    lm_sensors
    playerctl
    podman-compose
    nu_scripts

    # replacements written in rust
    procs # ps
    uutils-coreutils-noprefix # coreutils
    xh # http request tool. has --download and --continue

    # gui
    (ungoogled-chromium.override { commandLineArgs = ''--js-flags="--jitless --noexpose_wasm" --no-pings ''; })
    discord
    firefox
    j4-dmenu-desktop

    # music
    bitwig-studio4
    vcv-rack
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

    ".config/tofi/config".text = ''
            anchor = top
            width = 100%
            height = 22
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
            min-input-width = 120
            result-spacing = 15
            padding-top = 0
            padding-bottom = 0
            padding-left = 0
            padding-right = 0
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    settings = {
      env = [ "XCURSOR_SIZE,32" "WLR_NO_HARDWARE_CURSORS,1" ];

      exec-once = [
        "waybar"
        "hyprctl setcursor Yaru 32"
      ];

      general = {
        border_size = 2;
        gaps_in = 2;
        gaps_out = 2;

        "col.active_border" = "0xffb6a0ff";
        "col.inactive_border" = "0xff444444";
      };

      animations = {
        enabled = false;
      };

      decoration = {
        rounding = 4;
        drop_shadow = false;

        blur = {
          enabled = false;
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mod" = "SUPER";

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        "$mod, p, exec, j4-dmenu-desktop --dmenu='tofi' --no-generic"
        "$mod SHIFT, Return, exec, alacritty"
        "$mod SHIFT, c, killactive"
        "$mod SHIFT, q, exit"

        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Move/resize windows with mod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 22;
        modules-left = [ "hyprland/workspaces" "custom/colon" "hyprland/window" ];
        modules-center = [ ];
        modules-right = [ "custom/mymodule#with-css-id" "temperature" ];

        # "hyprland/workspaces" = {
        #   format = "[{id}]";
        # };
        # "hyprland/window" = {
        #   format = " : {title}";
        # };
        #   disable-scroll = true;
        #   all-outputs = true;
        # };
        "custom/colon" = {
          format = " : ";
          max-length = 4;
          interval = "once";
          # exec = pkgs.writeShellScript "hello-from-waybar" ''
          #   echo "from within waybar"
          # '';
        };
      };
  };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: monospace;
        font-size: 16px;
        padding: 0;
        margin-bottom: -0.01;
        background: none;
      }
      window#waybar {
        background: #000000;
        color: #ffffff;
      }
      #workspaces button.active {
        background: #b6a0ff;
        color: #000000;
      }
      #window {
        color: #b0d6f5;
      }
    '';
  };

  gtk = {
    enable = true;

    cursorTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
      size = 32;
    };

    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 12;
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

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "cjb";
      editor = {
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "underline";
        };
      };
      keys.normal = {
        "}" = "goto_next_paragraph";
        "{" = "goto_prev_paragraph";
      };
    };

    themes = {
      cjb =
        let
          special-blue = "#afd7ff";
          dark-gray = "#111111";
          medium-gray = "#222222";
        in
        {
          "attribute" = "light-magenta";
          "comment" = { fg = "light-cyan"; modifiers = [ "italic" ]; };
          "constant" = { fg = special-blue; modifiers = [ "bold" ]; };
          "constant.builtin" = { fg = "magenta"; modifiers = [ "italic" ]; };
          "constant.character.escape" = "light-cyan";
          "constant.numeric" = special-blue;
          "constructor" = "light-blue";
          "diagnostic" = { modifiers = [ "underlined" ]; };
          "function" = "light-magenta";
          "keyword" = { fg = "light-cyan"; modifiers = [ "italic" ]; };
          "keyword.control" = "red";
          "keyword.control.return" = { fg = "light-cyan"; modifiers = [ "italic" ]; };
          "keyword.function" = { fg = special-blue; modifiers = [ "italic" ]; };
          "label" = "light-magenta";
          "markup.bold" = { fg = "light-yellow"; modifiers = [ "bold" ]; };
          "markup.heading" = "light-blue";
          "markup.italic" = { fg = "light-magenta"; modifiers = [ "italic" ]; };
          "markup.link.text" = "light-red";
          "markup.link.url" = { fg = "yellow"; modifiers = [ "underlined" ]; };
          "markup.list" = "light-red";
          "markup.quote" = "light-cyan";
          "markup.raw" = "light-green";
          "markup.strikethrough" = { modifiers = [ "crossed_out" ]; };
          "namespace" = "light-magenta";
          "operator" = "red";
          "special" = "light-blue";
          "string" = "light-blue";
          "type" = { fg = "light-cyan"; modifiers = [ "bold" ]; };
          "variable" = "white";
          "variable.builtin" = { fg = "light-cyan"; modifiers = [ "italic" ]; };

          "debug" = { fg = "gray"; modifiers = [ "bold" ]; };
          "error" = { fg = "light-red"; modifiers = [ "bold" ]; };
          "hint" = { fg = "gray"; modifiers = [ "bold" ]; };
          "info" = { fg = "blue"; modifiers = [ "bold" ]; };
          "warning" = { fg = "yellow"; modifiers = [ "bold" ]; };

          "diff.delta" = "yellow";
          "diff.minus" = "light-red";
          "diff.plus" = "green";

          "ui.cursor" = { fg = "light-gray"; modifiers = [ "reversed" ]; };
          "ui.cursor.match" = { fg = "light-yellow"; modifiers = [ "underlined" ]; };
          "ui.cursor.primary" = { fg = "light-gray"; modifiers = [ "reversed" ]; };
          "ui.cursorline" = { bg = dark-gray; };
          "ui.gutter" = { bg = "black"; };
          "ui.gutter.selected" = { bg = dark-gray; };
          "ui.help" = { fg = "white"; bg = "black"; };
          "ui.linenr" = { fg = "light-gray"; bg = "black"; };
          "ui.linenr.selected" = { fg = "white"; bg = dark-gray; modifiers = [ "bold" ]; };
          "ui.menu" = { fg = "light-gray"; bg = dark-gray; };
          "ui.menu.selected" = { fg = "light-blue"; modifiers = [ "reversed" ]; };
          "ui.popup" = { bg = dark-gray; };
          "ui.selection" = { bg = medium-gray; };
          "ui.statusline" = { fg = "light-gray"; bg = dark-gray; };
          "ui.statusline.inactive" = { fg = "gray"; bg = "black"; };
          "ui.virtual.whitespace" = "light-gray";
          "ui.window" = { bg = "black"; };
        };
    };
  };

  programs.git = {
    enable = true;
    userEmail = "cjbdev@icloud.com";
    userName = "Christopher Bayliss";

    delta = {
      enable = true;
      options = {
        diff-highlight = true;
      };
    };
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
        size = 12.5;
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

  programs.tmux = {
    enable = true;
    extraConfig = ''
      # status bar config
      set -g status-position top
      set -g status-style "fg=white bg=black"
      set -g status-left ""
      set -g status-right "#[fg=colour255,bg=colour235] %H#[fg=brightcyan]:#[fg=colour255]%M#[fg=brightcyan]:#[fg=colour255]%S "

      setw -g window-status-current-style "fg=brightmagenta bg=colour235"
      setw -g window-status-current-format " #I#[fg=brightmagenta]:#[fg=colour255]#W#[fg=brightcyan]#F "
      setw -g window-status-format " #I:#W#F "

      # set title like normal
      set -g set-titles on
      set -g set-titles-string "#T"

      # allow italics
      set -g default-terminal xterm-256color
      set -ga terminal-overrides ",*:RGB"

      # don"t intercept ESC
      set -sg escape-time 25

      # tmux doesn't use emacs keybindings if VISUAL||EDITOR=vi{m,} 🤮
      set -g mode-keys emacs
      set -g status-keys emacs

      # enable mouse support
      set -g mouse on

      # scratch buffer/popup
      bind-key -n "M-'" if-shell -F "#{==:#{session_name},scratch}" {
          detach-client
      } {
          display-popup -E -w 85% -h 85% "tmux new-session -A -s scratch \; set status off"
      }

      # easy open command-prompt
      bind-key -n "M-;" command-prompt

      # fast window switching/creation
      bind-key -n "M-1" run-shell "tmux select-window -t0 || tmux new-window"
      bind-key -n "M-2" run-shell "tmux select-window -t1 || tmux new-window"
      bind-key -n "M-3" run-shell "tmux select-window -t2 || tmux new-window"
      bind-key -n "M-4" run-shell "tmux select-window -t3 || tmux new-window"
      bind-key -n "M-5" run-shell "tmux select-window -t4 || tmux new-window"
      bind-key -n "M-6" run-shell "tmux select-window -t5 || tmux new-window"
      bind-key -n "M-7" run-shell "tmux select-window -t6 || tmux new-window"
      bind-key -n "M-8" run-shell "tmux select-window -t7 || tmux new-window"
      bind-key -n "M-9" run-shell "tmux select-window -t8 || tmux new-window"
    '';
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
        ahead = "A";
        behind = "B";
        diverged = "#";
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

  programs.nushell = {
    enable = true;
    environmentVariables = {
      # this isn't set properly under nushell
      NIX_PATH = "/home/${config.home.username}/.nix-defexpr/channels:nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels";

      # vancy colours in man pages
      LESS_TERMCAP_mb = "(tput bold; tput setaf 1)";
      LESS_TERMCAP_md = "(tput bold; tput setaf 1)";
      LESS_TERMCAP_me = "(tput sgr0)";
      LESS_TERMCAP_so = "(tput bold; tput setaf 12)";
      LESS_TERMCAP_se = "(tput sgr0)";
      LESS_TERMCAP_us = "(tput bold; tput setaf 14)";
      LESS_TERMCAP_ue = "(tput sgr0)";

      # required for colours in man pages to work
      GROFF_NO_SGR = "1";
    };

    configFile = {
      text = ''
        $env.config = {
          show_banner: false
        }
        use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
        use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu *
        # use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/man/man-completions.nu *

        def colours [] {
          nu ${pkgs.nu_scripts}/share/nu_scripts/modules/coloring/256_color_testpattern.nu
        }
      '';
    };

    loginFile.text = ''
      if ($env.DISPLAY? | is-empty) and ($env.XDG_VTNR == "1") { exec Hyprland}
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

    EDITOR = "hx";
    SUDO_EDITOR = "hx";
    VISUAL = "hx";

    PAGER = "cat"; # NOTE: setting no pager breaks bad software
    MANPAGER = "less --mouse --wheel-lines 3";
    MANWIDTH = 72;

    EMAIL = "cjbdev@icloud.com";
    NAME = "Christopher Bayliss";
  };

  programs.home-manager.enable = true;
}
