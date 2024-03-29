{...}: {
  imports = [
    # desktop
    ./desktop/common.nix
    ./desktop/x11.nix

    # languages
    ./languages/bucket.nix # langs not being managed by home-manager
    ./languages/lua.nix
    ./languages/python.nix

    # programs
    ./programs/cli/bucket.nix # cli programs not being managed by home-manager
    ./programs/cli/git.nix
    ./programs/cli/home-manager.nix
    ./programs/cli/ripgrep.nix
    ./programs/cli/tmux.nix
    ./programs/cli/yt-dlp.nix
    ./programs/desktop-entries.nix
    ./programs/editor.nix
    ./programs/gui/bucket.nix # gui programs not being managed by home-manager
    ./programs/gui/firefox.nix
    ./programs/gui/mpv.nix
    ./programs/shell.nix
    ./programs/terminal.nix

    # unfree
    ./unfree.nix

    # variables
    ./variables.nix
  ];
}
