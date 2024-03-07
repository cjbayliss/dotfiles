{config, ...}: {
  home = {
    homeDirectory = "/home/cjb";
    sessionPath = ["$HOME/.local/bin" "${config.xdg.dataHome}/npm/bin"];
    stateVersion = "23.05";
    username = "cjb";
  };

  programs.home-manager.enable = true;
}
