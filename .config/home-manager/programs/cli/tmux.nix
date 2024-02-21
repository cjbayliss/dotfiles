{...}: {
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
      bind-key -n "M-j" if-shell "tmux list-clients -t scratch 2>/dev/null | grep -q ." {
          detach-client -s scratch
      } {
          split-window -v -l 25% "TMUX= tmux new-session -A -s scratch \\; set status off"
      }

      # find and open
      bind-key -n "M-f" display-popup -E -w 85% -h 85% 'sk-rg-tmux'

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
