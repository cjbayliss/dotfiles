{
  config,
  pkgs,
  ...
}: {
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.local/cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";

    userDirs.enable = true;
    userDirs.createDirectories = true;

    userDirs.desktop = "${config.home.homeDirectory}/stuff/desktop";
    userDirs.documents = "${config.home.homeDirectory}/stuff";
    userDirs.download = "${config.home.homeDirectory}/downloads";
    userDirs.music = "${config.home.homeDirectory}/music";
    userDirs.pictures = "${config.home.homeDirectory}/pictures";
    userDirs.videos = "${config.home.homeDirectory}/videos";

    # disable these
    userDirs.publicShare = null;
    userDirs.templates = null;
  };

  home.packages = with pkgs; [
    aspell
    aspellDicts.en
    bubblewrap
    mangohud
    playerctl
    pulseaudio # for pactl
    wineWowPackages.stagingFull
  ];

  gtk = {
    enable = true;

    font = {
      name = "Liberation Sans";
      package = pkgs.liberation_ttf;
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
    };
  };
}
