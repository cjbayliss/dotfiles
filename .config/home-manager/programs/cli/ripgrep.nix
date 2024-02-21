{...}: {
  programs.ripgrep = {
    enable = true;
    arguments = ["--no-heading"];
  };
}
