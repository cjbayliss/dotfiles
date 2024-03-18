{pkgs, ...}: {
  home.packages = with pkgs; [
    ansible-language-server
    clang-tools
    cmake-language-server
    dockerfile-language-server-nodejs
    elixir-ls
    erlang-ls
    gleam
    gopls
    haskell-language-server
    lua-language-server
    nil
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    racket
    rust-analyzer
    taplo
    vscode-langservers-extracted
    yaml-language-server
    zls
  ];

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

    languages = {
      language-server.pylsp.config.pylsp.plugins.pylint.enabled = true;
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
        }
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "${pkgs.black}/bin/black";
            args = ["--quiet" "-"];
          };
        }
      ];
    };

    themes = {
      cjb = let
        special-blue = "#afd7ff";
        dark-gray = "#111111";
        medium-gray = "#222222";
      in {
        "attribute" = "light-magenta";
        "comment" = {
          fg = "light-cyan";
          modifiers = ["italic"];
        };
        "constant" = {
          fg = special-blue;
          modifiers = ["bold"];
        };
        "constant.builtin" = {
          fg = "magenta";
          modifiers = ["italic"];
        };
        "constant.character.escape" = "light-cyan";
        "constant.numeric" = special-blue;
        "constructor" = "light-blue";
        "diagnostic" = {modifiers = ["underlined"];};
        "function" = "light-magenta";
        "keyword" = {
          fg = "light-cyan";
          modifiers = ["italic"];
        };
        "keyword.control" = "red";
        "keyword.control.return" = {
          fg = "light-cyan";
          modifiers = ["italic"];
        };
        "keyword.function" = {
          fg = special-blue;
          modifiers = ["italic"];
        };
        "label" = "light-magenta";
        "markup.bold" = {
          fg = "light-yellow";
          modifiers = ["bold"];
        };
        "markup.heading" = "light-blue";
        "markup.italic" = {
          fg = "light-magenta";
          modifiers = ["italic"];
        };
        "markup.link.text" = "light-red";
        "markup.link.url" = {
          fg = "yellow";
          modifiers = ["underlined"];
        };
        "markup.list" = "light-red";
        "markup.quote" = "light-cyan";
        "markup.raw" = "light-green";
        "markup.strikethrough" = {modifiers = ["crossed_out"];};
        "namespace" = "light-magenta";
        "operator" = "red";
        "special" = "light-blue";
        "string" = "light-blue";
        "type" = {
          fg = "light-cyan";
          modifiers = ["bold"];
        };
        "variable" = "white";
        "variable.builtin" = {
          fg = "light-cyan";
          modifiers = ["italic"];
        };

        "debug" = {
          fg = "gray";
          modifiers = ["bold"];
        };
        "error" = {
          fg = "light-red";
          modifiers = ["bold"];
        };
        "hint" = {
          fg = "gray";
          modifiers = ["bold"];
        };
        "info" = {
          fg = "blue";
          modifiers = ["bold"];
        };
        "warning" = {
          fg = "yellow";
          modifiers = ["bold"];
        };

        "diff.delta" = "yellow";
        "diff.minus" = "light-red";
        "diff.plus" = "green";

        "ui.cursor" = {
          fg = "light-gray";
          modifiers = ["reversed"];
        };
        "ui.cursor.match" = {
          fg = "light-yellow";
          modifiers = ["underlined"];
        };
        "ui.cursor.primary" = {
          fg = "light-gray";
          modifiers = ["reversed"];
        };
        "ui.cursorline" = {bg = dark-gray;};
        "ui.gutter" = {bg = "black";};
        "ui.gutter.selected" = {bg = dark-gray;};
        "ui.help" = {
          fg = "white";
          bg = "black";
        };
        "ui.linenr" = {
          fg = "light-gray";
          bg = "black";
        };
        "ui.linenr.selected" = {
          fg = "white";
          bg = dark-gray;
          modifiers = ["bold"];
        };
        "ui.menu" = {
          fg = "light-gray";
          bg = dark-gray;
        };
        "ui.menu.selected" = {
          fg = "light-blue";
          modifiers = ["reversed"];
        };
        "ui.popup" = {bg = dark-gray;};
        "ui.selection" = {bg = medium-gray;};
        "ui.statusline" = {
          fg = "light-gray";
          bg = dark-gray;
        };
        "ui.statusline.inactive" = {
          fg = "gray";
          bg = "black";
        };
        "ui.virtual.whitespace" = "light-gray";
        "ui.window" = {bg = "black";};
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "hx";
    SUDO_EDITOR = "hx";
    VISUAL = "hx";
  };
}
