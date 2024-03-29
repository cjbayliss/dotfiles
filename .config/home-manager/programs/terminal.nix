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
}
