{...}: {
  programs.ripgrep = {
    enable = true;
    arguments = ["--hyperlink-format=vscode" "--no-heading"];
  };
}
