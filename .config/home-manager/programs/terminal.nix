{...}: {
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

  programs.foot = {
    enable = true;
    settings = {
      main.font = "Iosevka:size=12.5";
      cursor.style = "underline";
      cursor.blink = "yes";

      colors = {
        background = "000000";
        foreground = "ffffff";

        regular0 = "000000";
        regular1 = "ff8059";
        regular2 = "44bc44";
        regular3 = "d0bc00";
        regular4 = "2fafff";
        regular5 = "feacd0";
        regular6 = "00d3d0";
        regular7 = "bfbfbf";

        bright0 = "595959";
        bright1 = "ef8b50";
        bright2 = "70b900";
        bright3 = "c0c530";
        bright4 = "79a8ff";
        bright5 = "b6a0ff";
        bright6 = "6ae4b9";
        bright7 = "ffffff";
      };
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      # count from 1 not zero (this makes keybindings line up with the pane index)
      set -g base-index 1
      setw -g pane-base-index 1
      # status bar config
      set -g status-position top
      set -g status-style "fg=white bg=black"
      set -g status-left ""
      set -g status-right "#[fg=colour255,bg=colour235] %H#[fg=brightcyan]:#[fg=colour255]%M "

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
      bind-key -n "C-j" if-shell "tmux list-clients -t scratch 2>/dev/null | grep -q ." {
          detach-client -s scratch
      } {
          split-window -v -l 25% "TMUX= tmux new-session -A -s scratch \\; set status off"
      }

      # easy open command-prompt
      bind-key -n "M-;" command-prompt

      # fast window switching/creation
      bind-key -n "M-1" run-shell "tmux select-window -t1 || tmux new-window"
      bind-key -n "M-2" run-shell "tmux select-window -t2 || tmux new-window"
      bind-key -n "M-3" run-shell "tmux select-window -t3 || tmux new-window"
      bind-key -n "M-4" run-shell "tmux select-window -t4 || tmux new-window"
      bind-key -n "M-5" run-shell "tmux select-window -t5 || tmux new-window"
      bind-key -n "M-6" run-shell "tmux select-window -t6 || tmux new-window"
      bind-key -n "M-7" run-shell "tmux select-window -t7 || tmux new-window"
      bind-key -n "M-8" run-shell "tmux select-window -t8 || tmux new-window"
      bind-key -n "M-9" run-shell "tmux select-window -t9 || tmux new-window"
    '';
  };
}
