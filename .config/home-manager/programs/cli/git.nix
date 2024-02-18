{...}: {
  programs.git = {
    enable = true;
    userEmail = "cjbdev@icloud.com";
    userName = "Christopher Bayliss";
    extraConfig = {
      commit.verbose = true;
      diff.algorithm = "histogram";
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      url."git@codeberg.org:".pushInsteadOf = "https://codeberg.org/";
      url."git@github.com:".pushInsteadOf = "https://github.com/";
    };

    delta = {
      enable = true;
      options = {
        diff-highlight = true;
      };
    };
  };
}
