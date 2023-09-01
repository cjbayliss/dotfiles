{ config, pkgs, ... }:

with pkgs;
let
  chromium = (ungoogled-chromium.override { commandLineArgs = ''--no-referrers --js-flags="--jitless --noexpose_wasm" --no-pings ''; });
  mpv-with-mpris = (mpv.override { scripts = [ mpvScripts.mpris ]; });
  python = python3.withPackages (pp: with pp; [ flake8 notify2 pylint ]);
in
{
  home.username = "cjb";
  home.homeDirectory = "/home/cjb";
  xdg.cacheHome = "/tmp/cache";

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
    git-filter-repo
    hsetroot
    mangohud
    opusTools
    pciutils
    pulseaudio # for pactl
    sx
    universal-ctags
    xmobar
    yaru-theme

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
    appimage-run
    bubblewrap
    ffmpeg
    git
    hexyl
    himalaya
    neovim
    nu_scripts
    pandoc
    pass
    playerctl
    podman-compose
    protonup
    ratpoison
    scrot
    tmux
    unzip
    w3m
    wget
    winePackages.stagingFull
    winetricks
    yt-dlp

    # gui
    alacritty
    chromium
    discord
    firefox
    j4-dmenu-desktop
    mpv-with-mpris
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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

  programs.nushell = {
    enable = true;
    configFile = {
      text = ''
        $env.config = {
          show_banner: false
        }

        use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
        use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu *
      '';
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

  home.sessionVariables = {
    XDG_DESKTOP_DIR = "$HOME/stuff/desktop";
    XDG_DOCUMENTS_DIR = "$HOME/stuff";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
    XDG_MUSIC_DIR = "$HOME/music";
    XDG_PICTURES_DIR = "$HOME/pictures";
    XDG_VIDEOS_DIR = "$HOME/videos";

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "/tmp/cache";
    XDG_DATA_HOME = "$HOME/.local/share";

    PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/startup.py";
    PASSWORD_STORE_DIR = "$HOME/.local/share/pass";
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
