{...}: {
  # TODO: finish configuring firefox using home-manager:
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enable
  programs.firefox = {
    enable = true;
  };

  home.sessionVariables = {
    MOZ_GTK_TITLEBAR_DECORATION = "system"; # proper theming
    MOZ_USE_XINPUT2 = "1";
  };
}
