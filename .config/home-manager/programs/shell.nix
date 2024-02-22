{pkgs, ...}: {
  home.packages = with pkgs; [
    nix-your-shell
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      if command -q nix-your-shell
        nix-your-shell fish | source
      end

      # allow urls with '?' in them
      set -U fish_features qmark-noglob

      # colours
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

      alias ps "echo \"don't you mean procs(1)?\""

      # man colours
      export LESS_TERMCAP_mb="$(tput bold; tput setaf 1)"
      export LESS_TERMCAP_md="$(tput bold; tput setaf 1)"
      export LESS_TERMCAP_me="$(tput sgr0)"
      export LESS_TERMCAP_so="$(tput bold; tput setaf 12)"
      export LESS_TERMCAP_se="$(tput sgr0)"
      export LESS_TERMCAP_us="$(tput bold; tput setaf 14)"
      export LESS_TERMCAP_ue="$(tput sgr0)"
      # required for man colours to work
      export GROFF_NO_SGR=1;

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

    shellAliases = {
      ls = "ls --hyperlink --color=auto";
    };
  };

  home.sessionVariables = {
    PAGER = "cat"; # NOTE: setting no pager breaks bad software
    MANPAGER = "less --mouse --wheel-lines 3";
    MANWIDTH = 72;

    EMAIL = "cjbdev@icloud.com";
    NAME = "Christopher Bayliss";
  };
}
