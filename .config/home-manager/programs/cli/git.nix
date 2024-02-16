{...}: {
  programs.git = {
    enable = true;
    userEmail = "cjbdev@icloud.com";
    userName = "Christopher Bayliss";
    extraConfig = {
      init.defaultBranch = "main";
    };

    delta = {
      enable = true;
      options = {
        diff-highlight = true;
      };
    };
  };
}
