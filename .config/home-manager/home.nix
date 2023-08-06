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
    appimage-run
    ffmpeg
    git
    hexyl
    himalaya
    neovim
    pandoc
    pass
    playerctl
    podman-compose
    protonup
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
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
        set fish_greeting

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

        # prompt
        function __git_branch
            git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
        end

        function __git_status
            if [ (git ls-files 2>/dev/null | wc -l) -lt 2000 ]
                git status --short 2>/dev/null | sed 's/^ //g' | cut -d' ' -f1 | sort -u | tr -d '\n' | sed 's/^/ /'
            else
                printf " [NOSTAT]"
            end
        end

        function fish_right_prompt
            set -l last_status $status
            if [ $last_status -ne 0 ]
                set_color --bold $fish_color_error
                printf '%s ' $last_status
                set_color normal
            end
        end

      function fish_prompt
          # host
          set_color normal
          printf '%s ' (prompt_hostname)

          # pwd
          set_color $fish_color_cwd
          echo -n (prompt_pwd)
          set_color normal

          # git stuff
          set_color brmagenta
          printf '%s' (__git_branch)
          set_color magenta
          printf '%s ' (__git_status)
          set_color normal

          # prompt delimiter
          echo -n '» '
      end
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
    PASSWORD_STORE_DIR = "$XDG_DATA_HOME/pass";
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
