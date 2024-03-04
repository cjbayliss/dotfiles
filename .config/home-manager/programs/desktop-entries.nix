{...}: {
  xdg.desktopEntries = {
    "Steam Settings" = {
      name = "Steam Settings";
      exec = "steam steam://open/settings";
      terminal = false;
    };
    "Exit Steam" = {
      name = "Exit Steam";
      exec = "steam steam://exit";
      terminal = false;
    };
  };
}
